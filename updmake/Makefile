NAME := replace_src

CC := c++
CFLAGS := -Wall -Wextra -Werror

SRC := replace_src.cpp

all: $(NAME)

$(NAME):
	$(CC) $(CFLAGS) $(SRC) -o $@

clean:
	@rm -rf $(NAME)

fclean: clean

re: clean all

.PHONY: clean all re
