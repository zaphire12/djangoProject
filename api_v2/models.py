from basic_auth.models import User

from django.db import models
from django_celery_results.models import TaskResult
from django.utils.translation import gettext as _



class UsersTasks(models.Model):
    user = models.ForeignKey(User, on_delete=models.PROTECT)
    task = models.ForeignKey(TaskResult,  on_delete=models.PROTECT, to_field='task_id')


class TokenInfo(models.Model):
    access_token = models.CharField(max_length=255)
    token_type = models.CharField(max_length=25, default='Bearer')
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    creation_date = models.DateTimeField(auto_now_add=True)
