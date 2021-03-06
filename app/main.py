#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
 service: ingest article dummy
```usage: python main.py -h```
"""
__author__ = "Gonzalo Acosta"
__email__ = "gonzaloacostapeiro@gmail.com"
__version__ = "0.0.8"

from fastapi import FastAPI, status, HTTPException, Response, Request, Query
from database import Base, engine
from sqlalchemy.orm import Session
from typing import List

import models
import schemas
import datetime
import time
from time import sleep


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

    message = "Hello DevOps to Dummy API REST version {}".format(__version__)
    response_content = {
        "message": message
    }

    process_time = time.time() - start_time
    response.headers["x-process-time"] = str(process_time)

    return response_content


@app.post("/article",
          status_code=status.HTTP_201_CREATED,
          response_model=schemas.Articles)
def create_articles(
        article: schemas.ArticlesCreate,
        request: Request,
        response: Response,
        appname: str = "app-name"
        ):
    """
    Create a new article to enrich
    """
    start_time = time.time()

    session = Session(
        bind=engine,
        expire_on_commit=False)

    print("request.headers: {}".format(request.headers))
    print("pre appname: {}".format(appname))

    if article.wait_time > 0:
        sleep(article.wait_time)

    if 'appname' in request.headers:
        # appname in header
        appname = request.headers['appname']
    elif article.appname and appname == "local-app":
        # appname in body
        appname = article.appname

    article_db = models.Articles(
        text=article.text,
        username=article.username,
        appname=appname,
        request_id=article.request_id,
        wait_time=article.wait_time,
        stamp_created=get_date(),
        stamp_updated=get_date(),
    )

    session.add(article_db)
    session.commit()
    session.refresh(article_db)
    session.close()

    process_time = time.time() - start_time
    response.headers["x-process-time"] = str(process_time)

    return article_db


@app.get("/article/{id}",
         response_model=schemas.Articles,
         status_code=status.HTTP_200_OK)
def read_article(
        id: int, 
        request: Request,
        response: Response
    ):
    """
    Read a raw article
    """
    start_time = time.time()

    # work here

    print("request.headers: {}".format(request.headers))

    session = Session(bind=engine, expire_on_commit=False)
    article = session.query(models.Articles).get(id)
    session.close()

    if not article:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"article item with id {id} not found"
        )

    process_time = time.time() - start_time
    response.headers["x-process-time"] = str(process_time)

    print("response.headers: {}".format(response.headers))

    return article


@app.get("/article/{id}",
         response_model=schemas.Articles,
         status_code=status.HTTP_201_CREATED)
def update_article(id: int,
                   username: str,
                   text: str,
                   appname: str,
                   request_id: str,
                   request: Request,
                   response: Response
                   ):
    """
    Update a raw article
    """

    start_time = time.time()

    print("request.headers: {}".format(request.headers))

    session = Session(bind=engine, expire_on_commit=False)
    article = session.query(models.Articles).get(id)

    if article:
        article.username = username
        article.text = text
        article.appname = appname
        article.request_id = request_id
        article.stamp_updated = get_date()
        session.commit()

    session.close()

    if not article:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"article item with id {id} not found"
        )

    process_time = time.time() - start_time
    response.headers["x-process-time"] = str(process_time)

    print("response.headers: {}".format(response.headers))
    return article


@app.delete("/article/{id}",
            status_code=status.HTTP_201_CREATED,
            response_model=schemas.Articles)
def delete_articles(id: int, response: Response):
    """
    Delete a raw article
    """
    start_time = time.time()

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

    process_time = time.time() - start_time
    response.headers["x-process-time"] = str(process_time)
    return article

@app.get("/articles",
         status_code=status.HTTP_201_CREATED,
         response_model=List[schemas.Articles])
def read_articles_list(response: Response):
    """
    Read all articles stored in db
    """
    start_time = time.time()

    session = Session(bind=engine, expire_on_commit=False)
    articles_list = session.query(models.Articles).all()

    if not articles_list:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"articles item with id {id} not found"
        )

    session.close()

    process_time = time.time() - start_time
    response.headers["x-process-iime"] = str(process_time)

    return articles_list
