from django.urls import path
from django.views.decorators.gzip import gzip_page

from . import views

app_name = 'api_v1'

urlpatterns = [
    path("_main_report/", views.index, name="main_report"),
    path('_modules/', views.get_available_modules, name='modules'),
    path('_lpu_list/', views.lpus, name='_lpu_list'),
    path('_doc_type_list/', views.doc_type, name='doc_type'),
    path('_data_set_dashboard/', gzip_page(views.data_set_dashboard), name='data_set_dashboard'),
    path('_lpu_dep_list/', views.lpu_dep, name='doc_type'),
    path('_emp_list/', views.emp_list, name='emp_list'),
    path('_data_set_designer/', gzip_page(views.data_set_designer), name='foo'),
    path('celery/', views.celery, name='celery'),
    path('celery_queue/', views.celery_queue, name='celery_queue'),
    path('foo/', gzip_page(views.foo), name='foo')
]
