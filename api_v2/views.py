from django.forms import model_to_dict
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django_celery_results.models import TaskResult

from api_v2.tasks import foo as task_foo
from django.core.exceptions import PermissionDenied
from api_v2.models import UsersTasks
from project.celery import app


@csrf_exempt
def foo(request):
    if request.user.is_anonymous:
        raise PermissionDenied()
    user = request.user
    i = task_foo.delay()
    UsersTasks.objects.create(
        task_id=i.task_id,
        user=user
    )
    print([model_to_dict(i) for i in TaskResult.objects.all()])
    return JsonResponse({'data': 'data'})


@csrf_exempt
def celery_queue(request):
    queue_celery = app.control.inspect().active()
    queue_list = queue_celery.get('celery@localhost')
    return JsonResponse({'tasks': queue_list})
