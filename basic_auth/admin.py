from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.utils.translation import gettext as _
from .models import User, Lpu


@admin.register(User)
class ModelNameAdmin(UserAdmin):
    filter_horizontal = ('available_lpu', 'user_permissions', 'groups')
    list_filter = ("is_staff", "is_superuser", "is_active", "is_verified")
    description = "Пользователи"
    fieldsets = (
        (None, {"fields": ("username", "password")}),
        (_("Personal info"), {"fields": ("first_name", "last_name", "email")}),
        (
            _("Permissions"),
            {
                "fields": (
                    "is_active",
                    "is_staff",
                    "is_superuser",
                    "is_verified",
                    "groups",
                    "user_permissions",
                ),
            },
        ),
        (_("Important dates"), {"fields": ("last_login", "date_joined")}),
    )


@admin.register(Lpu)
class ModelNameAdmin(admin.ModelAdmin):
    description = "Список ЛПУ"


