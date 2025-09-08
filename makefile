JQ ?= jq
LIBDIR ?= .
TESTS ?= ./test1.sh
# TESTS ?= tests2.jq

.PHONY: test
test:
	. $(TESTS)
# 	. $(TESTS)									## shell script... 
# 	$(JQ) -L $(LIBDIR) --run-tests $(TESTS)		## JQ --run-tests
    