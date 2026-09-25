.PHONY: deps config build run spec clear run-clean

deps:
	@echo "Installing dependencies..."
	@shards install

config:
	@echo "Configuring the project..."
	@cp configs/config.example.yaml configs/config.yaml

clear:
	@echo "Clearing build artifacts..."
	@rm -rf bin
	@crystal clear_cache

build:
	@echo "Building the project..."
	@mkdir -p bin
	@crystal build src/apps/server/main.cr -o bin/server

run: build
	@echo "Running the server..."
	@./bin/server --config=configs/config.yaml

run-clean: clear build
	@echo "Running the server after cleaning..."
	@./bin/server --config=configs/config.yaml

spec:
	@echo "Running specs..."
	@crystal spec -v
