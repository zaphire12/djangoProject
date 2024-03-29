import datetime
import json

from django.contrib.auth.mixins import PermissionRequiredMixin, LoginRequiredMixin
from django.http import JsonResponse, FileResponse, HttpResponse
from django.conf import settings
from django.shortcuts import render, redirect
from django.views.generic import TemplateView, ListView
from .models import MainDocumentData, NotificationModel, DataTransfusionInfo
from .forms import UserChangeFormCustom
from basic_auth.models import User, Lpu


class IndexView(LoginRequiredMixin, TemplateView):
    template_name = 'app/index.html'
    extra_context = {'title': 'Главная страница'}


class UserNotificationView(LoginRequiredMixin, PermissionRequiredMixin, ListView):
    permission_required = ["app.view_notificationmodel"]
    template_name = 'app/notifications.html'
    extra_context = {'title': 'Уведомления'}
    paginate_by = 4

    def post(self, *args, **kwargs):
        json_data = json.loads(self.request.body.decode('utf-8'))
        count = json_data.get('count')
        if count > 0:
            NotificationModel.objects.filter(user=self.request.user, is_read=False).update(is_read=True)
            return JsonResponse({'test': 'output'})
        return JsonResponse({'test': 'output'})

    def get_queryset(self):
        return NotificationModel.objects.filter(user=self.request.user).order_by('-created_at')


class VerificationView(LoginRequiredMixin, PermissionRequiredMixin, ListView):
    permission_required = ["basic_auth.change_user",
                           "basic_auth.view_user"]  # TODO: Разобраться как не выводить инфомацию исключения raise в консоль
    permission_denied_message = 'У вас нет доступа'

    template_name = 'app/verification.html'
    extra_context = {'title': 'Верификация'}

    def get_queryset(self):
        users = User.objects.all().values(
            'id', 'username', 'first_name', 'last_name', 'email', 'is_verified', 'is_active'
        )
        users_list = list(users)
        for user in users_list:
            user['is_verified'] = str(user['is_verified'])
            user['is_active'] = str(user['is_active'])
        return users_list


class VerificationChangeView(LoginRequiredMixin, PermissionRequiredMixin, TemplateView):
    permission_required = ["basic_auth.change_user",
                           "basic_auth.view_user"]  # TODO: Разобраться как не выводить инфомацию исключения raise в консоль
    permission_denied_message = 'У вас нет доступа'

    template_name = 'app/verification_change.html'
    extra_context = {'title': 'Редактирование пользователя', 'button_label': 'Сохранить'}
    form_class = UserChangeFormCustom

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user_id = context.get('id')
        user = User.objects.get(id=user_id)
        available_lpu_names = list(user.available_lpu.values_list('fullname', flat=True))
        context['form'] = self.form_class(instance=user)
        context['object'] = {
            'id': user.id,
            'username': user.username,
            'first_name': user.first_name,
            'last_name': user.last_name,
            'email': user.email,
            'is_verified': user.is_verified,
            'is_active': user.is_active,
            'available_lpu': available_lpu_names,
        }
        return context

    def post(self, request, *args, **kwargs):
        user_id = self.kwargs['id']
        user = User.objects.get(id=user_id)
        form = UserChangeFormCustom(request.POST, instance=user)
        if form.is_valid():
            form.save()
            return redirect('app:verification')
        return render(request, self.template_name, {'form': form})


class TemplateViewLpu(TemplateView):
    def get_context_data(self, **kwargs):
        if self.extra_context is not None:
            kwargs.update(self.extra_context)
        kwargs.setdefault("view", self)
        user = self.request.user
        label = kwargs.get('label')
        extra_context = {
            'first_date': (datetime.date.today() - datetime.timedelta(days=7)).strftime('%d/%m/%Y'),
            'second_date': (datetime.date.today()).strftime('%d/%m/%Y'),
            'available_lpu': (list(Lpu.objects.all()) if user.is_superuser else list(user.available_lpu.all())),
            'info': DataTransfusionInfo.objects.filter(table_name=label).first()
        }
        kwargs.update(extra_context)
        return kwargs


class MonthReport(LoginRequiredMixin, PermissionRequiredMixin, TemplateViewLpu):
    permission_required = ["app.dashboard"]
    permission_denied_message = 'У вас нет доступа'
    template_name = 'app/month_report.html'
    extra_context = {
        'title': 'Отчет за месяц',
        'grid_filter': True,
        'label': MainDocumentData._meta.label
    }


class MainDocumentView(LoginRequiredMixin, PermissionRequiredMixin, TemplateViewLpu):
    permission_required = ["app.dashboard"]
    permission_denied_message = 'У вас нет доступа'
    template_name = 'app/dashbord_beta.html'
    extra_context = {
        'title': 'Отчет по СЭМД',
        'grid_filter': True,
        'label': MainDocumentData._meta.label
    }


class Designer(LoginRequiredMixin, PermissionRequiredMixin, TemplateViewLpu):
    permission_required = ["app.dashboard"]
    permission_denied_message = 'У вас нет доступа'
    template_name = 'app/designer.html'
    extra_context = {'title': 'Конструктор', 'info': 'Тут будет информация об актуальности данных'}


class Charts(LoginRequiredMixin, PermissionRequiredMixin, TemplateViewLpu):
    permission_required = ["app.dashboard"]
    permission_denied_message = 'У вас нет доступа'
    template_name = 'app/chart.html'
    extra_context = {'title': 'Чарты'}


class Tasks(LoginRequiredMixin, PermissionRequiredMixin, TemplateView):
    permission_required = ["app.tasks"]
    permission_denied_message = 'У вас нет доступа'
    template_name = 'app/tasks.html'
    extra_context = {'title': 'Задачи'}


class SlotsReport(LoginRequiredMixin, PermissionRequiredMixin, TemplateView):
    permission_required = ["app.slots"]
    template_name = "app/slots.html"
    permission_denied_message = 'У вас нет доступа'
    extra_context = {'title': 'Отчет по слотам'}

    def get_context_data(self, **kwargs):
        kwargs.setdefault("view", self)
        self.extra_context['first_date'] = (datetime.date.today() - datetime.timedelta(days=14)).strftime('%d/%m/%Y')
        self.extra_context['second_date'] = (datetime.date.today() + datetime.timedelta(days=14)).strftime('%d/%m/%Y')
        if self.extra_context is not None:
            kwargs.update(self.extra_context)
        return kwargs
