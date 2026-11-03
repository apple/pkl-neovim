.PHONY: test

test:
	nvim --headless -l tests/verify_configuration.lua
