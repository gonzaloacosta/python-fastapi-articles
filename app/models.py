from sqlalchemy import Column, Integer, String, DateTime
from database import Base
import datetime


def get_date():
    """
    Day of the day
    """
    return datetime.datetime.now()


class Articles(Base):
    """
    Inherit class from Base, represent to table articles,
    each instance is a row
    """
    __tablename__ = 'articles'
    id = Column(Integer, primary_key=True)
    username = Column(String(64))
    text = Column(String(500))
    stamp_created = Column(DateTime, default=get_date())
    stamp_updated = Column(DateTime, default=get_date())
