from pydantic import BaseModel
from datetime import datetime


class ArticlesCreate(BaseModel):
    """
    Create Article Schema (Pydantic Model)
    """
    username: str
    text: str
    appname: str
    request_id: str


class Articles(BaseModel):
    """
    Complete Article Schema (Pydantic Model)
    """
    id: int
    stamp_created: datetime
    stamp_updated: datetime
    appname: str
    request_id: str
    username: str
    text: str

    class Config:
        orm_mode = True
