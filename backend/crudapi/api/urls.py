from django.urls import path
from ninja import NinjaAPI,Schema



api = NinjaAPI()


class Todo(Schema):
    title: str
    description: str
    done : bool
    

@api.post("/create")
def create(request, todo: Todo):
    return todo


urlpatterns = [
    path('', api.urls),
]
