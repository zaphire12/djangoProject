from django.db import models
from django.contrib.auth.models import AbstractUser


class Lpu(models.Model):
    fullname = models.CharField(max_length=248, verbose_name='Наименование ЛПУ')

    class Meta:
        db_table_comment = "ЛПУ"
        verbose_name = "Список ЛПУ"

    def __str__(self):
        return f'{self.fullname}'

    def __repr__(self):
        return f'{self.fullname}'


class User(AbstractUser):
    available_lpu = models.ManyToManyField(Lpu, blank=True, related_name='user_lpu', verbose_name='Доступные ЛПУ', related_query_name='user_available_lpu')
    is_verified = models.BooleanField(
        "Статус верификации",
        default=False,
    )
