from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('app.urls', 'app')),
    path('auth/', include('basic_auth.urls', "basic_auth")),
    path('api/v1/', include('api_v1.urls', 'api_v1')),
    path('api/v2/', include('api_v2.urls', 'api_v2'))
]
