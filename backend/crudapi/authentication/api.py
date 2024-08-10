from ninja import Router
from ninja.security import HttpBearer
from django.contrib.auth import authenticate, get_user_model
from rest_framework.authtoken.models import Token
from .schemas import TokenSchema, SignUpSchema, LoginSchema

User = get_user_model()

authApi = Router()

class AuthBearer(HttpBearer):
    def authenticate(self, request, token):
        try:
            token_obj = Token.objects.get(key=token)
            return token_obj.user
        except Token.DoesNotExist:
            return None

auth = AuthBearer()

@authApi.post("/signup/", response=TokenSchema)
def signup(request, data: SignUpSchema):
    user = User.objects.create_user(username=data.username, password=data.password, address=data.address)
    token, _ = Token.objects.get_or_create(user=user)
    return {"token": token.key}

@authApi.post("/login/", response=TokenSchema)
def login(request, data: LoginSchema):
    user = authenticate(username=data.username, password=data.password)
    if user is None:
        return authApi.create_response(request, {"error": "Invalid credentials"}, status=401)
    token, _ = Token.objects.get_or_create(user=user)
    return {"token": token.key}

@authApi.get("/protected", auth=auth)
def protected(request):
    return {"message": f"Hello, {request.auth.username}!", "address": request.auth.address}
