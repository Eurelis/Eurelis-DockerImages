TAG_NAME := aws-ami-php7
TAG_VERSION := php73

build-container:
	docker build --tag ${TAG_NAME} .

push-container: build-container
	docker login
	docker tag ${TAG_NAME} eurelis/${TAG_NAME}:${TAG_VERSION}
	docker push eurelis/${TAG_NAME}

run-container: build-container
	docker run -i -t aws-ami-php7 /bin/bash