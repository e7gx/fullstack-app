from ninja import Schema

class TodoIn(Schema):
    title: str
    description: str
    done : bool

class TodoOut(Schema):
    id: int
    title: str
    description: str
    done : bool
    
# api/schema.py
class UserCreate(Schema):
    first_name: str
    last_name: str
    username: str
    email: str
    password: str

class UserLogin(Schema):
    username: str
    password: str

class TokenOut(Schema):
    access: str
    refresh: str

class UserOut(Schema):
    username: str
    token: TokenOut
