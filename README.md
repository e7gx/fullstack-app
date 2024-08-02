# Fullstack App

A full-stack Todo List application built with Django for the backend and Flutter for the frontend.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Prerequisites](#prerequisites)
- [Backend Setup (Django)](#backend-setup-django)
- [Frontend Setup (Flutter)](#frontend-setup-flutter)
- [API Endpoints](#api-endpoints)
- [Contributing](#contributing)
- [License](#license)

## Introduction

This project is a simple Todo List application that allows users to manage their tasks. The backend is powered by Django and Django Ninja, while the frontend is built using Flutter. The app supports creating, reading, updating, and deleting (CRUD) todo items.

## Features

- Add new todo items
- View all todo items
- Update existing todo items
- Delete todo items

## Technologies Used

- **Backend**: Django, Django Ninja
- **Frontend**: Flutter
- **Database**: SQLite (default for Django, can be changed to PostgreSQL, MySQL, etc.)

## Prerequisites

- Python 3.x
- Flutter SDK
- Node.js (for package management)
- A code editor like VS Code or PyCharm

## Backend Setup (Django)

1. **Clone the Repository**

    ```sh
    git clone https://github.com/your-username/todo-list-app.git
    cd todo-list-app/backend
    ```

2. **Create a Virtual Environment and Activate It**

    ```sh
    python -m venv venv
    source venv/bin/activate  # On Windows use `venv\Scripts\activate`
    ```

3. **Install Dependencies**

    ```sh
    pip install django django-ninja
    ```

4. **Create Django Project and App**

    ```sh
    django-admin startproject todolist_project
    cd todolist_project
    django-admin startapp todos
    ```

5. **Configure Django Settings**

    In `todolist_project/settings.py`, add `todos` and `ninja` to the `INSTALLED_APPS` list.

6. **Create Todo Model**

    In `todos/models.py`, define the `Todo` model.

7. **Run Migrations**

    ```sh
    python manage.py makemigrations
    python manage.py migrate
    ```

8. **Create Ninja API Endpoints**

    In `todos/api.py`, set up the Ninja API.

9. **Include the API in Django Project**

    In `todolist_project/urls.py`:

    ```python
    from django.contrib import admin
    from django.urls import path
    from todos.api import api

    urlpatterns = [
        path('admin/', admin.site.urls),
        path('api/', api.urls),
    ]
    ```

10. **Run the Server**

    ```sh
    python manage.py runserver
    ```

## Frontend Setup (Flutter)

1. **Clone the Repository**

    ```sh
    git clone https://github.com/e7gx/fullstack-app.git
   
    ```

2. **Install Dependencies**

    ```sh
    flutter pub get
    ```

3. **Create Models**

    Create a `todo.dart` file in the `lib` folder to define the `Todo` model.

4. **Create API Service**

    Create an `api_service.dart` file in the `lib` folder to interact with the Django Ninja API.

5. **Create the UI**

    In the `lib` folder, create the UI for the todo list, adding screens for displaying, adding, and editing todos.

6. **Run the App**

    ```sh
    flutter run
    ```

## API Endpoints

- **GET /api/todos**: List all todo items
- **POST /api/todos**: Create a new todo item
- **GET /api/todos/{todo_id}**: Retrieve a specific todo item
- **PUT /api/todos/{todo_id}**: Update a specific todo item
- **DELETE /api/todos/{todo_id}**: Delete a specific todo item

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
