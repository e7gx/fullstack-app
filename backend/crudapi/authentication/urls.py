from django.urls import path
from .api import authApi

urlpatterns = [
    path('', authApi.urls),
]
