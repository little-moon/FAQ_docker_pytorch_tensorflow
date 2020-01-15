help:
	@cat Makefile

DATA?="${HOME}/Data"
GPU?=0
DOCKER_FILE=Dockerfile
DOCKER=docker
BACKEND=pytorch
PYTHON_VERSION?=3.6
CUDA_VERSION?=9.0
CUDNN_VERSION?=7
TEST=tests/
SRC?=$(shell dirname `pwd`)

build:
	docker build -t faq_pytorch_image --build-arg python_version=$(PYTHON_VERSION) --build-arg cuda_version=$(CUDA_VERSION) --build-arg cudnn_version=$(CUDNN_VERSION) -f $(DOCKER_FILE) .

bash: build
	$(DOCKER) run -it -v $(SRC):/src/workspace -v $(DATA):/data --env BACKEND=$(BACKEND) faq_pytorch_image bash

ipython: build
	$(DOCKER) run -it -v $(SRC):/src/workspace -v $(DATA):/data --env BACKEND=$(BACKEND) faq_pytorch_image ipython

notebook: build
	$(DOCKER) run -it -v $(SRC):/src/workspace -v $(DATA):/data --net=host --env BACKEND=$(BACKEND) faq_pytorch_image

test: build
	$(DOCKER) run -it -v $(SRC):/src/workspace -v $(DATA):/data --env BACKEND=$(BACKEND) faq_pytorch_image py.test $(TEST)

