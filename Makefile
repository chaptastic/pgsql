PROJECT = pgsql

DIALYZER = dialyzer
TYPER = typer
REBAR = $(CURDIR)/rebar

all: build

deps:
	@$(REBAR) get-deps
	@mkdir -p deps

build: deps
	@$(REBAR) compile

clean:
	@$(REBAR) clean
	@rm -f erl_crash.dump

# Tests
test: test-eunit

test-eunit:
	@$(REBAR) eunit skip_deps=true

# Dialyzer
.$(PROJECT).plt: | deps
	@echo "==> $(PROJECT) (dialyzer build-plt)"
	@$(DIALYZER) --build_plt --output_plt .$(PROJECT).plt \
		--apps erts kernel stdlib crypto compiler syntax_tools -r ./deps

dialyze: .$(PROJECT).plt
	@echo "==> $(PROJECT) (dialyzer dialyze)"
	@$(DIALYZER) -r ./ebin --fullpath --plt .$(PROJECT).plt \
		-Werror_handling -Wrace_conditions -Wunmatched_returns

type: .$(PROJECT).plt
	@echo "==> $(PROJECT) (typer)"
	@$(TYPER) -r ./src --plt .$(PROJECT).plt

.PHONY: all deps build clean test test-eunit dialyze
