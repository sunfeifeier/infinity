# https://github.com/tiangolo/uvicorn-gunicorn-fastapi-docker

FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8-slim

# set environment variables
ENV PYTHONWRITEBYTECODE 1
ENV PYTHONBUFFERED 1

# set working directory in container
WORKDIR /code

# copy dependencies into container code folder
COPY requirements.txt /code/

# upgrade pip install dependencies 
RUN pip install -U pip
RUN pip install -r requirements.txt

# copy all the app origial project into code folder
COPY . /code/
# let contrainer has the right to run this entrypoint
RUN chmod 755 /code/entrypoint.sh

# run server
CMD ["/code/entrypoint.sh"]
