from django.contrib.auth.models import Permission
from django.core.exceptions import ValidationError
from django.db import models
from django.db.models.signals import pre_save
from django.dispatch import receiver
from basic_auth.models import User, Lpu


class ModulesTags(models.Model):
    name = models.CharField(max_length=255)

    class Meta:
        verbose_name = "Теги модулей"

    def __str__(self):
        return f'{self.name}'


class Modules(models.Model):
    name = models.CharField(max_length=255, db_index=True)
    description = models.CharField(max_length=255, db_index=True, blank=True)
    icon = models.TextField(blank=True, null=True, default=None)
    tag = models.ForeignKey(ModulesTags, on_delete=models.CASCADE)
    url = models.CharField(max_length=255)
    permission_list = models.ForeignKey(Permission, on_delete=models.PROTECT)

    class Meta:
        verbose_name = "Модули"

    def __str__(self):
        return f'{self.name}'


class MainDocumentData(models.Model):
    lpu = models.ForeignKey(Lpu, on_delete=models.PROTECT, db_index=True)
    lpu_dep = models.TextField(db_index=True, blank=True, null=True)
    dep_oid = models.TextField(blank=True, null=True)
    doc_type = models.TextField(db_index=True, blank=True, null=True)
    employer = models.TextField(db_index=True)
    position = models.TextField(blank=True, null=True)
    date_provide = models.DateField(verbose_name='Дата оказания услуги', db_index=True)
    services_success = models.IntegerField(verbose_name='Оказано услуг')
    services_not_send = models.IntegerField()
    services_error = models.IntegerField()
    services_send = models.IntegerField()
    semd_reg = models.IntegerField()
    semd_formed = models.IntegerField()
    semd_success_reg = models.IntegerField()
    semd_success_summ = models.IntegerField()

    class Meta:
        db_table_comment = "Основная информация по СЭМД"
        verbose_name = "Основная информация по СЭМД"


class NotificationCategory(models.Model):
    title = models.CharField(max_length=255)


class NotificationNewsModel(models.Model):
    title = models.CharField(max_length=255)
    category = models.ForeignKey(NotificationCategory, on_delete=models.CASCADE, blank=True,  related_name='news_cat')
    content = models.TextField(blank=True, null=True, verbose_name='Контент')
    created_at = models.DateTimeField(auto_now_add=True)


class NotificationModel(models.Model):
    user = models.ManyToManyField(
        User,
        blank=True,
        related_name='notification_users',
        verbose_name='Новость для пользователя',
        related_query_name='notification_user')
    news = models.ForeignKey(NotificationNewsModel, on_delete=models.CASCADE)
    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)


class SlotReport(models.Model):
    lpu = models.TextField(db_index=True, blank=True, null=True)
    dep = models.TextField(db_index=True, blank=True, null=True)
    cab = models.TextField(db_index=True, blank=True, null=True)
    spec = models.TextField(db_index=True, blank=True, null=True)
    emp = models.TextField(db_index=True, blank=True, null=True)
    date = models.DateField()
    vsego_slotov = models.IntegerField()
    vsego_konkyr = models.IntegerField()
    vsego_internet = models.IntegerField()
    vsego_call_center = models.IntegerField()
    kol_vo = models.IntegerField()
    kol_vo_zap_otkaz = models.IntegerField()

    class Meta:
        db_table_comment = "Основная информация по слотам"
        verbose_name = "Отчет по слотам"


class DataTransfusionInfo(models.Model):
    table_name = models.CharField(max_length=56)
    date_begin = models.DateTimeField(blank=True, null=True)
    date_end = models.DateTimeField(blank=True, null=True)
    update_date = models.DateTimeField(blank=True, null=True)


# @receiver(pre_save, sender=NotificationModel)
# def checker(sender, instance, **kwargs):
#     if not instance.news.is_notification:
#         raise ValidationError("Не удается сохранить NotificationModel,"
#                               " если связанный NewsModel не является уведомлением")


# class FileManager(models.Model):
#     name = models.CharField(max_length=255)
#     file = models.FileField(upload_to='uploads/')
#     uploaded_at = models.DateTimeField(auto_now_add=True)
#     user = models.ForeignKey(User, on_delete=models.PROTECT)
#     size_in_bytes = models.IntegerField()
#     content_type = models.CharField(max_length=100)
