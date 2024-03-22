from collections import defaultdict

from django.contrib.auth.models import Permission
from .models import NotificationModel, Modules, ModulesTags


def get_user_permissions(user):
    if user.is_superuser:
        return Permission.objects.all()
    return user.user_permissions.all() | Permission.objects.filter(group__user=user)


def notification_len_processor(request):
    user = request.user
    if user.is_anonymous:
        return {}
    notification_len = NotificationModel.objects.filter(user=user, is_read=False).count()
    if notification_len > 9:
        return {'notification_len': '9+'}
    return {'notification_len': notification_len}


def available_modules(request):
    user = request.user
    if user.is_anonymous:
        return {'modules_dict': {}}
    permission_list = [per.id for per in get_user_permissions(user).all()]
    modules = set(Modules.objects.select_related('tag').filter(permission_list__in=permission_list).order_by('tag__modules'))  # TODO: обязательно закешировать в проде
    modules_dict = defaultdict(list)
    for i in modules:
        modules_dict[i.tag].append({'module': i})
    return {'modules_dict': dict(modules_dict)}
