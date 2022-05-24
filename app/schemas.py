from pydantic import BaseModel


class ArticlesCreate(BaseModel):
    """
    Create Article Schema (Pydantic Model)
    """
    username: str
    text: str


class Articles(BaseModel):
    """
    Complete Article Schema (Pydantic Model)
    """
    id: int
    username: str
    text: str

    class Config:
        orm_mode = True
