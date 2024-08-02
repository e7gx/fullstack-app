from ninja import NinjaAPI
from django.shortcuts import get_object_or_404
from typing import List
from .models import Todo
from .schema import TodoIn, TodoOut

ninjaapi = NinjaAPI()

# Create a new todo
@ninjaapi.post("/todo/create", response=TodoOut)
def create_todo(request, payload: TodoIn):
    todo = Todo.objects.create(**payload.dict())
    return todo

# Fetch a single todo by id
@ninjaapi.get("/todo/{todo_id}", response=TodoOut)
def get_todo(request, todo_id: int):
    todo = get_object_or_404(Todo, id=todo_id)
    return todo

# Fetch all todos
@ninjaapi.get("/todo/get/", response=List[TodoOut])
def get_todos(request):
    todos = Todo.objects.all()
    return todos

# Update an existing todo
@ninjaapi.put("/todo/put/{todo_id}", response=dict)
def update_todo(request, todo_id: int, payload: TodoIn):
    todo = get_object_or_404(Todo, id=todo_id)
    for attr, value in payload.dict().items():
        setattr(todo, attr, value)
    todo.save()
    return {"success": True}

# Delete a todo
@ninjaapi.delete("/todo/delete/{todo_id}", response=dict)
def delete_todo(request, todo_id: int):
    todo = get_object_or_404(Todo, id=todo_id)
    todo.delete()
    return {"success": True}
