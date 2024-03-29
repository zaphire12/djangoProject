from django.urls import path
from django.contrib.auth.decorators import login_required
from . import views

app_name = 'app'

urlpatterns = [
    path("", views.IndexView.as_view(), name="index"),
    path('verification/', views.VerificationView.as_view(), name='verification'),
    path('verification/update/<int:id>/', login_required(views.VerificationChangeView.as_view()), name='verification_change'),
    path('dashboard/', views.MainDocumentView.as_view(), name='dashboard'),
    path('notification/', views.UserNotificationView.as_view(), name='notification'),
    path('designer/', views.Designer.as_view(), name='designer'),
    path('chart/', views.Charts.as_view(), name='chart'),
    path('tasks/', views.Tasks.as_view(), name='tasks'),
    path('slots/', views.SlotsReport.as_view(), name='slots'),
    path('month_report/', views.MonthReport.as_view(), name='month_report')
]
