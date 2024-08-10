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


