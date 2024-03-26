from django.contrib import admin
from django.contrib.auth.models import Permission

from .models import NotificationNewsModel, NotificationModel, NotificationCategory, MainDocumentData, Modules, ModulesTags, DataTransfusionInfo


admin.site.register(NotificationNewsModel)
admin.site.register(NotificationModel)
admin.site.register(NotificationCategory)
admin.site.register(MainDocumentData)
admin.site.register(Modules)
admin.site.register(Permission)
admin.site.register(ModulesTags)
admin.site.register(DataTransfusionInfo)
