STRIPE_SECRET=sk_test_51PJGDH1QJNrJbkBlECgB4wPjZAaP1TbDDqJmUlDEaTb00uI3HdahF7toK8JWqshMcG0KGUkFE8R86ihQUyaK60Jx00fJPemaFZ
STRIPE_KEY=pk_test_51PJGDH1QJNrJbkBlw4NUnXqdUaUuYAwAgqjjrO4Jgpj8c7oWc9Ho4C2HblZzTO55vz96Zf0uKOYgfl1cKz9C9yVe00dGRzmeLQ
GOSTRIPE_PORT=4000
API_PORT=4001


## build: build all the binaries
build: clean build_front build_back
	@printf "All binaries built!\n"

## clean: cleans all binaries and runs go clean
clean:
	@echo "Cleanin..."
	@- rm -f dist/*
	@go clean
	@echo "Cleaned!"

## build_front: builds the front end
build_front:
	@echo "Building front end"
	@go build -o dist/gostripe ./cmd/web
	@echo "Front end built!"

## build_back: builds the back end
build_back:
	@echo "Building back end"
	@go build -o dist/gostripe_api ./cmd/api
	@echo "back end built!"

## start: start both front and back end
start: start_front start_back

## start_front: starts the front end
start_front: build_front
	@echo "Starting the front end..."
	@env STRIPE_KEY=${STRIPE_KEY} STRIPE_SECRET=${STRIPE_SECRET} ./dist/gostripe -port=${GOSTRIPE_PORT} &
	@echo "front end running !"

## start_back: starts the front end
start_back: build_back
	@echo "Starting the back end..."
	@env STRIPE_KEY=${STRIPE_KEY} STRIPE_SECRET=${STRIPE_SECRET} ./dist/gostripe_api -port=${API_PORT} &
	@echo "back end running !"


## stop: stops both front and back end
stop: stop_front stop_back

## stop_front: stops the front end
stop_front:
	@echo "Stopping the front end..."
	@-pkill -SIGTERM -f "gostripe -port=${GOSTRIPE_PORT}"
	@echo "Stopped front end"

## stop_back: stops the front end
stop_back:
	@echo "Stopping the back end..."
	@-pkill -SIGTERM -f "gostripe_api -port=${API_PORT}"
	@echo "Stopped back end"



