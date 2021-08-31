## Traditional build
### To Run Locally
$ uvicorn main:app

### To Run for All Hosts
```bash
# Go into the app folder
$ cd app
# Run the following command
$ uvicorn main:app --host 0.0.0.0 --port 8000
```

### To Build
$ python setup.py bdist_wheel

### To Upload
$ aws s3 cp .dist/fastapi_example-1.0.0-py3-none-any.whl s3://usc-tony-infinity-example-us-east-1/

## Docker build
```bash
$ docker build -t registry/infinity:v1 -f ./Dockerfile .
$ docker images
$ docker run -d -p 8000:8000 registry/infinity:v1
```


## update docker hub username