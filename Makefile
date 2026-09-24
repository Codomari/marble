.PHONY: spec
spec:
	@echo "Running specs..."
	@find spec -name "*_spec.cr" -exec crystal spec {} -v \;