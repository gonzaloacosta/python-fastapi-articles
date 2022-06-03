#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
 service: ingest article dummy
```usage: python main.py -h```
"""
__author__ = "Gonzalo Acosta"
__email__ = "gonzaloacostapeiro@gmail.com"
__version__ = "0.0.1"

from fastapi import FastAPI, status, HTTPException, Response
from fastapi.encoders import jsonable_encoder
from database import Base, engine
from sqlalchemy.orm import Session
from typing import List

import models
import schemas
#import os
import datetime
import time


def get_date():
    """
    Day of the day
    """
    return datetime.datetime.now()


# Create the database
Base.metadata.create_all(engine)

# Initialize app
app = FastAPI()


@app.get("/")
def root(response: Response):
    """
    Root base path
    """
    start_time = time.time()
    message = "Hello DevOps to Dummy API REST"
    response_content = {
        "message": message
    }
    process_time = time.time() - start_time
    response.headers["X-Process-Time"] = str(process_time)
    return response_content


@app.post("/article",
          status_code=status.HTTP_201_CREATED,
          response_model=schemas.Articles)
def create_articles(
        article: schemas.ArticlesCreate, response: Response):
    """
    Create a new article to enrich
    """
    start_time = time.time()

    session = Session(bind=engine, expire_on_commit=False)
    article_db = models.Articles(
        text=article.text,
        username=article.username
    )
    session.add(article_db)
    session.commit()
    session.refresh(article_db)
    session.close()

    process_time = time.time() - start_time
    response.headers["X-Process-Time"] = str(process_time)

    return article_db


@app.get("/article/{id}",
         response_model=schemas.Articles, status_code=status.HTTP_200_OK)
def read_article(id: int):
    """
    Read a raw article
    """

    session = Session(bind=engine, expire_on_commit=False)
    article = session.query(models.Articles).get(id)
    session.close()

    if not article:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"article item with id {id} not found"
        )

    return article


@app.get("/article/{id}",
         response_model=schemas.Articles,
         status_code=status.HTTP_201_CREATED)
def update_article(id: int, username: str, text: str):
    """
    Update a raw article
    """

    session = Session(bind=engine, expire_on_commit=False)
    article = session.query(models.Articles).get(id)

    if article:
        article.username = username
        article.text = text
        session.commit()

    session.close()

    if not article:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"article item with id {id} not found"
        )

    return article


@app.delete("/article/{id}",
            status_code=status.HTTP_201_CREATED,
            response_model=schemas.Articles)
def delete_articles(id: int):
    """
    Delete a raw article
    """

    session = Session(bind=engine, expire_on_commit=False)
    article = session.query(models.Articles).get(id)

    print(article)

    if article:
        session.delete(article)
        session.commit()
        session.close()
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"articles item with id {id} not found"
        )

    return article


@app.get("/articles",
         status_code=status.HTTP_201_CREATED,
         response_model=List[schemas.Articles])
def read_articles_list():
    """
    Read all articles stored in db
    """

    session = Session(bind=engine, expire_on_commit=False)
    articles_list = session.query(models.Articles).all()

    if not articles_list:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"articles item with id {id} not found"
        )

    session.close()

    return articles_list
