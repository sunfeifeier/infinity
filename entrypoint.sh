#!/bin/sh

cd /code/app
uvicorn main:app --workers 1 --host 0.0.0.0 --port 8000