from django.urls import path
from .api import todosApi

urlpatterns = [
    path('', todosApi.urls),
]
