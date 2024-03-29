from django.contrib.auth.decorators import login_required
from django.http import JsonResponse, HttpResponseRedirect
from django.contrib.auth import logout
from django.contrib.auth.views import PasswordChangeView, LoginView, PasswordResetView, PasswordResetDoneView, \
    PasswordResetConfirmView
from django.shortcuts import redirect
from django.views import View
from django.urls import reverse_lazy
from django.views.generic import CreateView
from .forms import UserPasswordChangeForm, LoginUserForm, RegisterUserForm, PasswordResetFormCustom, SetPasswordFormCustom


class RegisterUser(CreateView):
    form_class = RegisterUserForm
    template_name = 'basic_auth/register.html'
    extra_context = {'title': "Регистрация", 'button_label': 'Регистрация'}
    success_url = reverse_lazy('basic_auth:login')


class LoginUser(LoginView):
    form_class = LoginUserForm
    template_name = 'basic_auth/login.html'
    extra_context = {'title': 'Авторизация', 'button_label': 'Войти', 'type': True}

    def get_success_url(self):
        # TODO: Обрабатывать NEXT ссылку
        return reverse_lazy('app:index')


class PasswordResetViewCustom(PasswordResetView):
    email_template_name = "basic_auth/password_reset_email.html"
    template_name = "basic_auth/password_reset_form.html"
    form_class = PasswordResetFormCustom
    extra_context = {'title': 'Восстановление пароля', 'button_label': 'Восстановить'}
    success_url = reverse_lazy("basic_auth:password_reset_done")


class PasswordResetConfirmViewCustom(PasswordResetConfirmView):
    form_class = SetPasswordFormCustom
    template_name = "basic_auth/password_reset_confirm.html"
    extra_context = {'title': 'Восстановление пароля', 'button_label': 'Восстановить'}
    success_url = reverse_lazy("basic_auth:password_reset_complete")


class PasswordResetDoneViewCustom(PasswordResetDoneView):
    template_name = "basic_auth/password_reset_done.html"


@login_required(login_url=reverse_lazy('basic_auth:login'))
def logout_view(request):
    logout(request)
    return HttpResponseRedirect(reverse_lazy('basic_auth:login'))


class UserPasswordChange(PasswordChangeView):
    form_class = UserPasswordChangeForm
    success_url = reverse_lazy("basic_auth:password_change_done")
    extra_context = {'title': 'Изменение пароля', 'button_label': 'Изменить'}
    template_name = "basic_auth/password_change_form.html"
