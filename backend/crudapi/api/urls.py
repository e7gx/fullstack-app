from django.urls import path
from .api import ninjaapi

urlpatterns = [
    path('', ninjaapi.urls),
]
