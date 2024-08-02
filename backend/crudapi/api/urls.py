from django.urls import path
from ninja import NinjaAPI
from .models import Todo
from django.shortcuts import get_object_or_404
from typing import List
from .schema import TodoIn,TodoOut

ninjaapi = NinjaAPI()


##! CRUD operations
@ninjaapi.post("/todo")
def create_todo(request, payload: TodoIn):
    todo = Todo.objects.create(**payload.dict())
    return {'id':todo.id}


@ninjaapi.get("/todo/{todo_id}",response=TodoOut)
def get_todo(request,todo_id:int):
    todo = get_object_or_404(Todo,id=todo_id)
    return todo



@ninjaapi.get("/todo",response=List[TodoOut])
def get_todos(request):
    qs = Todo.objects.all()
    return qs



@ninjaapi.put("/todo/{todo_id}")
def update_todo(request,todo_id:int,payload:TodoIn):
    
    todo = get_object_or_404(Todo,id=todo_id)
    
    for atter,value in payload.dict().items():
        setattr(todo,atter,value)
        
    todo.save()
    return {"success":True}


@ninjaapi.delete("/todo/{todo_id}")
def delete_todo(request,todo_id:int):
    todo = get_object_or_404(Todo,id=todo_id)
    todo.delete()
    return {"success":True}


urlpatterns = [
    path('', ninjaapi.urls),
]
