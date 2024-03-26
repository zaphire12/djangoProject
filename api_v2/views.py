from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from project.celery import app


@csrf_exempt
def foo(request):
    return JsonResponse({'data': 'data'})


@csrf_exempt
def celery_queue(request):
    queue_celery = app.control.inspect().active()
    queue_list = queue_celery.get('celery@localhost')
    return JsonResponse({'tasks': queue_list})
