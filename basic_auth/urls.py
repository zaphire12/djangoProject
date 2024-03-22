from django.urls import path, reverse_lazy
from django.contrib.auth.views import PasswordChangeDoneView, PasswordResetView, PasswordResetConfirmView, \
    PasswordResetCompleteView, PasswordResetDoneView

from . import views

app_name = 'basic_auth'

urlpatterns = [
    path("login/", views.LoginUser.as_view(), name="login"),

    path('logout/', views.logout_view, name='logout'),

    path('password-reset/', views.PasswordResetViewCustom.as_view(), name='password_reset'),
    path('password-reset/done/',
         PasswordResetDoneView.as_view(template_name="basic_auth/password_reset_done.html"),
         name='password_reset_done'),
    path('password-reset/<uidb64>/<token>/',
         views.PasswordResetConfirmViewCustom.as_view(),
         name='password_reset_confirm'),
    path('password-reset/complete/',
         PasswordResetCompleteView.as_view(template_name="basic_auth/password_reset_complete.html"),
         name='password_reset_complete'),

    path('password-change/', views.UserPasswordChange.as_view(), name="password_change"),
    path('password-change/done/', PasswordChangeDoneView.as_view(template_name="basic_auth/password_change_done.html"),
         name="password_change_done"),

    path('register/', views.RegisterUser.as_view(), name='register'),
]