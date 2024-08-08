from ninja import NinjaAPI
from django.shortcuts import get_object_or_404
from typing import List
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from django.contrib.auth.hashers import make_password
from rest_framework_simplejwt.tokens import RefreshToken
from .schema import TodoIn, TodoOut, UserCreate, UserLogin, UserOut
from .models import Todo


ninjaapi = NinjaAPI()

def get_tokens_for_user(user):
    """
    Generate JWT tokens for the given user.
    """
    refresh = RefreshToken.for_user(user)
    return {
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    }

@ninjaapi.post("/register", response=UserOut)
def register(request, payload: UserCreate):
    """
    Register a new user and return JWT tokens.
    """
    # Validate if username already exists
    if User.objects.filter(username=payload.username).exists():
        return {"error": "Username already exists"}

    # Create a new user
    user = User.objects.create(
        first_name=payload.first_name,
        last_name=payload.last_name,
        username=payload.username,
        email=payload.email,
        password=make_password(payload.password),  # Hash the password
    )
    # Generate JWT tokens
    tokens = get_tokens_for_user(user)
    return UserOut(username=user.username, token=tokens)

@ninjaapi.post("/login", response=UserOut)
def login(request, payload: UserLogin):
    """
    Authenticate user and return JWT tokens.
    """
    user = authenticate(request, username=payload.username, password=payload.password)
    if user is not None:
        tokens = get_tokens_for_user(user)
        return UserOut(username=user.username, token=tokens)
    else:
        # Return a 401 Unauthorized error for invalid credentials
        return {"error": "Invalid credentials"}

# Create a new todo
@ninjaapi.post("/todo/create", response=TodoOut)
def create_todo(request, payload: TodoIn):
    """
    Create a new todo item.
    """
    todo = Todo.objects.create(**payload.dict())
    return todo

# Fetch a single todo by id
@ninjaapi.get("/todo/{todo_id}", response=TodoOut)
def get_todo(request, todo_id: int):
    """
    Retrieve a single todo item by its ID.
    """
    todo = get_object_or_404(Todo, id=todo_id)
    return todo

# Fetch all todos
@ninjaapi.get("/todo/get/", response=List[TodoOut])
def get_todos(request):
    """
    Retrieve all todo items.
    """
    todos = Todo.objects.all()
    return todos

# Update an existing todo
@ninjaapi.put("/todo/put/{todo_id}", response=dict)
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
@ninjaapi.delete("/todo/delete/{todo_id}", response=dict)
def delete_todo(request, todo_id: int):
    """
    Delete a todo item by its ID.
    """
    todo = get_object_or_404(Todo, id=todo_id)
    todo.delete()
    return {"success": True}
