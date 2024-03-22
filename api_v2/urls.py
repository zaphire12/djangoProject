from django.urls import path
from django.views.decorators.gzip import gzip_page

from . import views

app_name = 'api_v2'

urlpatterns = [
    # path('foo/', gzip_page(views.foo), name='foo')
]
