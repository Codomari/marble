.PHONY: config, build, run, spec

config:
	@echo "Configuring the project..."
	@cp configs/config.example.yaml configs/config.yaml
	@shards install

build:
	@echo "Building the project..."
	@mkdir -p bin
	@crystal build src/apps/server/main.cr -o bin/server

run:
	@echo "Running the server..."
	@./bin/server

spec:
	@echo "Running specs..."
	@find spec -name "*_spec.cr" -exec crystal spec {} -v \;