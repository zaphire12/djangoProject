import json
from datetime import datetime

from django.core.exceptions import PermissionDenied
from django.db.models.functions import Concat
from django.db import models
from django.db.models.functions import Cast, Floor
from django.http import JsonResponse, HttpResponse, Http404
from django.conf import settings

from app.context_processor import get_user_permissions
from app.models import MainDocumentData, Modules, SlotReport
from django.views.decorators.csrf import csrf_exempt
from django.db.models import Case, When, TextField, Value as V, Q, Sum, F, IntegerField
from basic_auth.models import Lpu


def json_helper(json_data):
    return [value if value else None for key, value in json_data.items()]


def filter_helper(request):
    if not request.body.decode('utf-8'):
        raise Http404()
    json_data = json.loads(request.body.decode('utf-8'))
    first_date, second_date, lpu_post, dep_post, employer_post, doc_post = json_helper(json_data)
    first_date = datetime.strptime(first_date, '%d/%m/%Y').date()
    second_date = datetime.strptime(second_date, '%d/%m/%Y').date()
    lpu_list = list(Lpu.objects.all()) if request.user.is_superuser \
        else list(request.user.available_lpu.all())
    filters = Q()
    if first_date and second_date:
        filters &= Q(date_provide__range=[first_date, second_date])
    else:
        return HttpResponse(status=404)
    if lpu_post:
        filters &= Q(lpu__in=lpu_post)
    else:
        filters &= Q(lpu__fullname__in=lpu_list)
    if dep_post:
        filters &= Q(lpu_dep__in=dep_post)
    if employer_post:
        filters &= Q(employer__in=employer_post)
    if doc_post:
        filters &= Q(doc_type__in=doc_post)
    filters &= Q(doc_type__in=settings.DOC_TYPE_LIST)
    return filters


@csrf_exempt
def index(request):
    json_data = json.loads(request.body.decode('utf-8'))
    first_date = datetime.strptime(json_data.get('first_date'), '%d/%m/%Y').date()
    second_date = datetime.strptime(json_data.get('second_date'), '%d/%m/%Y').date()
    _, __, lpu_post, dep_post, employer_post, doc_post = json_helper(json_data)
    filters = Q()
    filters &= Q(date_provide__range=[first_date, second_date], doc_type__in=settings.DOC_TYPE_LIST)
    # filters &= ~Q(lpu__fullname__in=settings.IGNORE_LPU)
    if lpu_post is not None:
        filters &= Q(lpu__in=lpu_post)
    elif request.user.is_superuser:
        filters &= Q(lpu__in=list(Lpu.objects.all()))
    else:
        filters &= Q(lpu__in=list(request.user.available_lpu.all()))
    if dep_post:
        filters &= Q(lpu_dep__in=dep_post)
    if employer_post:
        filters &= Q(employer__in=employer_post)
    if doc_post:
        filters &= Q(doc_type__in=doc_post)
    result = (
        MainDocumentData.objects
        .annotate(emp=Concat('employer', V(' ( '), 'position', V(') ')))
        .values('lpu__fullname', 'lpu_dep', 'emp', 'doc_type')
        .annotate(
            services_success=Sum(
                models.functions.Floor('services_success'),
                output_field=models.IntegerField()),
            semd_formed=models.Sum(models.functions.Floor('semd_formed'), output_field=IntegerField()),
            semd_reg=models.Sum(models.functions.Floor('semd_reg'), output_field=IntegerField()))
    ).order_by('lpu__fullname').filter(filters)  # TODO закершировать результат подготовить excel
    return JsonResponse({'data': list(result)})


@csrf_exempt
def get_available_modules(request):
    query = request.GET.get('search')
    user = request.user
    query_filter = Q()
    query_filter |= Q(name__icontains=query)
    query_filter |= Q(description__icontains=query)
    permission_list = [per.id for per in get_user_permissions(user).all()]
    i = list(Modules.objects.filter(permission_list_id__in=permission_list).filter(query_filter)
             .values('name', 'description', 'url'))
    return JsonResponse(
        {
            'result': i
        }
    )


@csrf_exempt
def lpu_dep(request):
    if not request.user.has_perm('app.dashboard'):
        raise PermissionDenied()
    lpu_list = list(Lpu.objects.all()) if request.user.is_superuser else list(request.user.available_lpu.all())
    i = MainDocumentData.objects.filter(lpu__in=lpu_list, doc_type__in=settings.DOC_TYPE_LIST)
    return JsonResponse({'data': list(i.values('lpu_dep').distinct().order_by('lpu_dep'))})


@csrf_exempt
def data_set_dashboard(request):
    if not request.user.has_perm('app.dashboard'):
        raise PermissionDenied()
    filters = filter_helper(request)
    result = (
        MainDocumentData.objects
        .values(d=F('lpu_dep'), e=F('employer'), t=F('doc_type'), l=F('lpu'))
        .annotate(
            x=Sum(
                Cast(Floor('semd_formed'), output_field=IntegerField())
            ),
            z=Sum(
                Cast(Floor('services_success'), output_field=IntegerField())
            ),
            c=Sum(
                Cast(Floor('semd_reg'), output_field=IntegerField())
            )
        )
    ).order_by('l').filter(filters)
    return JsonResponse({'data': list(result)})


@csrf_exempt
def doc_type(request):
    if not request.user.has_perm('app.dashboard'):
        raise PermissionDenied()
    lpu_list = list(Lpu.objects.all()) if request.user.is_superuser else list(request.user.available_lpu.all())
    i = MainDocumentData.objects.filter(lpu__in=lpu_list, doc_type__in=settings.DOC_TYPE_LIST)
    doc_type_list = list(i.values('doc_type').distinct())
    return JsonResponse({'data': doc_type_list})


@csrf_exempt
def lpus(request):
    if not request.user.has_perm('app.dashboard'):
        raise PermissionDenied()
    lpu_available = list(Lpu.objects.all()) if request.user.is_superuser else list(request.user.available_lpu.all())
    lpu_response = Lpu.objects.filter(fullname__in=lpu_available).values('id', 'fullname')
    return JsonResponse({'data': list(lpu_response)})


@csrf_exempt
def emp_list(request):
    if not request.user.has_perm('app.dashboard'):
        raise PermissionDenied()
    lpu_list = list(Lpu.objects.all()) if request.user.is_superuser else list(request.user.available_lpu.all())
    i = MainDocumentData.objects.filter(lpu__in=lpu_list, doc_type__in=settings.DOC_TYPE_LIST)
    return JsonResponse({'data': list(i.values('employer').distinct())})


@csrf_exempt
def data_set_designer(request):
    if not request.user.has_perm('app.dashboard'):
        raise PermissionDenied()
    filters = filter_helper(request)
    result = (
        MainDocumentData.objects
        .values(d=F('lpu_dep'),  t=F('doc_type'), l=F('lpu'), dp=F('date_provide'))
        .annotate(
            e=Case(
                When(position__isnull=False, then=Concat('employer', V(" ( "), 'position', V(" )"))),
                default='employer', output_field=TextField()),
            x=Sum(
                Cast(Floor('semd_formed'), output_field=IntegerField())
            ),
            z=Sum(
                Cast(Floor('services_success'), output_field=IntegerField())
            ),
            c=Sum(
                Cast(Floor('semd_reg'), output_field=IntegerField())
            )
        )
    ).order_by('l').filter(filters)
    return JsonResponse(
        {
            'data': list(result),
        }
    )


@csrf_exempt
def data_set_slots(request):
    first_date = request.GET.get('first_date')
    second_date = request.GET.get('second_date')
    first_date = datetime.strptime(first_date, '%d/%m/%Y').date()
    second_date = datetime.strptime(second_date, '%d/%m/%Y').date()
    result = (
        SlotReport.objects
        .values(
            'lpu',
            'dep',
            'cab',
            'date',
            empl=Concat('emp', V(" ("), 'spec', V(' )'), output_field=TextField()),

        )
        .annotate(
            sum_vs=Sum(
                Cast(
                    Floor(
                        'vsego_slotov'
                    ),
                    output_field=IntegerField()
                )
            ),
            sum_vk=Sum(
                Cast(
                    Floor(
                        'vsego_konkyr'
                    ),
                    output_field=IntegerField()
                )
            ),
        ).filter(date__range=[first_date, second_date])
    )
    return JsonResponse({'data': list(result)})
