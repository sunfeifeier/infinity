### To Run Locally
$ uvicorn main:app

### To Run for All Hosts
$ uvicorn main:app --host 0.0.0.0 --port 8000

### To Build
$ python setup.py bdist_wheel

### To Upload
$ aws s3 cp .dist/fastapi_example-1.0.0-py3-none-any.whl s3://usc-tony-fastapi-example-us-east-1/
