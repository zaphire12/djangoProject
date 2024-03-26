from django.db import models
from app.models import DataTransfusionInfo


def foo(model: models.Model):
    table = model._meta.label

