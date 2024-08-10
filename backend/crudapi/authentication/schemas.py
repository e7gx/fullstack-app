from ninja import Schema

class TokenSchema(Schema):
    token: str

class SignUpSchema(Schema):
    username: str
    password: str
    address: str

class LoginSchema(Schema):
    username: str
    password: str
