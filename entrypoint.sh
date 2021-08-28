#!/bin/sh

cd code
export PYTHONPATH=$PYTHONPATH:..
uvicorn api.main:app --reload --workers 1 --host 0.0.0.0 --port 8000