from basic_auth.models import User

from django.db import models
from django_celery_results.models import TaskResult


# Create your models here.
class UsersTasks(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    task = models.ForeignKey(TaskResult, on_delete=models.CASCADE)

