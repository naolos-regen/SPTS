CC          = gcc
CFLAGS      = -Wall -Wextra
CLIBS       = -lm
TEST_LIBS   = $(CLIBS) -lcriterion
DEBUG_FLAGS = -DDEBUG -g

SRC_DIR     = src
TEST_DIR    = test
INCLUDE_DIR = inc
BIN_DIR     = bin
OBJ_DIR     = obj

SRCS        = $(SRC_DIR)/main.c
OBJS        = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRCS))

EXECUTABLE        = spts
TEST_EXECUTABLE   = run_tests

TEST_SRCS := $(shell find $(TEST_DIR) -name '*.c')
TEST_SRCS := $(filter-out $(SRC_DIR)/main.c, $(TEST_SRCS))

all: debug

$(OBJ_DIR) $(BIN_DIR):
	@mkdir -p $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@ $(CLIBS)

debug: CFLAGS += $(DEBUG_FLAGS)
debug: $(BIN_DIR)/$(EXECUTABLE)

$(BIN_DIR)/$(EXECUTABLE): $(OBJS) | $(BIN_DIR)
	$(CC) $(CFLAGS) $(OBJS) -o $@ $(CLIBS)

test: $(BIN_DIR)/$(TEST_EXECUTABLE)

$(BIN_DIR)/$(TEST_EXECUTABLE): $(SRCS) $(TEST_SRCS) | $(BIN_DIR)
	@if [ -z "$(TEST_SRCS)" ]; then \
		echo "No test sources found."; \
		exit 1; \
	fi
	$(CC) $(CFLAGS) $(DEBUG_FLAGS) -I./inc \
		$(filter-out $(SRC_DIR)/main.c, $(SRCS)) \
		$(TEST_SRCS) \
		-o $@ \
		$(TEST_LIBS)

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

.PHONY: all debug test clean
