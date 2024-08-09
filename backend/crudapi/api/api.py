from ninja import NinjaAPI
from django.shortcuts import get_object_or_404
from typing import List
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from django.contrib.auth.hashers import make_password
from pydantic import validate_email
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
    try:
        # Validate if username already exists
        if User.objects.filter(username=payload.username).exists():
            return {"error": "Username already exists. Please choose a different username."}

        # Validate if email already exists
        if User.objects.filter(email=payload.email).exists():
            return {"error": "Email already exists. Please use a different email address."}

        # Validate email format
        if not validate_email(payload.email):
            return {"error": "Invalid email format. Please enter a valid email address."}

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
    except Exception as e:
        # Return a 500 Internal Server Error for unexpected issues
        return {"error": "An unexpected error occurred. Please try again later."}


@ninjaapi.post("/login", response=UserOut)
def login(request, payload: UserLogin):
    """
    Authenticate user and return JWT tokens.
    """
    try:
        user = User.objects.filter(username=payload.username).first()
        if user is None:
            # User does not exist
            return {"error": "Invalid username. Please check your username and try again."}
        
        # User exists, now check password
        if not authenticate(request, username=payload.username, password=payload.password):
            return {"error": "Invalid password. Please check your password and try again."}

        # If authentication is successful
        tokens = get_tokens_for_user(user)
        return UserOut(username=user.username, token=tokens)
    except Exception as e:
        # Return a 500 Internal Server Error for unexpected issues
        return {"error": "An unexpected error occurred. Please try again later."}


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
