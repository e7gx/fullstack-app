from ninja import NinjaAPI, Router
from django.shortcuts import get_object_or_404
from typing import List
from .schema import TodoIn, TodoOut

from .models import Todo


todosApi = Router()


# Create a new todo
@todosApi.post("/todo/create", response=TodoOut)
def create_todo(request, payload: TodoIn):
    """
    Create a new todo item.
    """
    todo = Todo.objects.create(**payload.dict())
    return todo

# Fetch a single todo by id
@todosApi.get("/todo/{todo_id}", response=TodoOut)
def get_todo(request, todo_id: int):
    """
    Retrieve a single todo item by its ID.
    """
    todo = get_object_or_404(Todo, id=todo_id)
    return todo

# Fetch all todos
@todosApi.get("/todo/get/", response=List[TodoOut])
def get_todos(request):
    """
    Retrieve all todo items.
    """
    todos = Todo.objects.all()
    return todos

# Update an existing todo
@todosApi.put("/todo/put/{todo_id}", response=dict)
def update_todo(request, todo_id: int, payload: TodoIn):
    """
    Update an existing todo item by its ID.
    """
    todo = get_object_or_404(Todo, id=todo_id)
    for attr, value in payload.dict().items():
        setattr(todo, attr, value)
    todo.save()
    return {"success": True}

# Delete a todo
@todosApi.delete("/todo/delete/{todo_id}", response=dict)
def delete_todo(request, todo_id: int):
    """
    Delete a todo item by its ID.
    """
    todo = get_object_or_404(Todo, id=todo_id)
    todo.delete()
    return {"success": True}