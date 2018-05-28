# SIXPHERE Meetups #

## Implement in prod your machine learning R models with Docker and Plumber ##

## Overview ##

This repo contains the needed resources to implement a basic continuous integration system about R machine learning models API servers.

## Quick start ##

* Compile the base docker image for Plumber. Run below command from repo root path.

```
docker build -t 6phr_plumber -f plumber/Dockerfile .
```

* To setup the development env, run below docker compose command from repo root path.

```
docker-compose up -d
```

* To setup an API container, for a specific api R script, ie. keras-mnist-api.R, run below commands from repo root path.

```
 docker build -t 6phr_keras-mnist:1.0 --build-arg api_path=rstudio/home/apis/keras-mnist-api.R  -f DockerfileApis .

 docker run -it -d --name 6phr_keras-mnist -p 8001:8000 6phr_keras-mnist:1.0
```

* You can access to the API frontpage using http://localhost:8001
* You can access to the API swagger documentation using http://localhost:8001/__swagger__.

## License ##

All resources in this repository are licensed under the AGPL licence.
