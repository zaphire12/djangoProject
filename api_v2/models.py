from django.db import models

from basic_auth.models import User


class TokenInfo(models.Model):
    access_token = models.CharField(max_length=255)
    token_type = models.CharField(max_length=25, default='Bearer')
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    creation_date = models.DateTimeField(auto_now_add=True)
