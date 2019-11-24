CROSS	= 

CC 		= $(CROSS)gcc
STRIP	= $(CROSS)strip
LD 		= $(CROSS)ld

CFLAGS	= -O2 -Wall -lpthread
IFLAGS	= -I.

NAME	= testOutPut
SRCLST	= $(wildcard *.c)
OBJLST	= $(patsubst %.c,%.o,$(SRCLST))


all: $(NAME)

$(NAME): $(OBJLST)
	$(CC) $(IFLAGS) -o $@ $^ $(CFLAGS)
	chmod 777 $@
	sync

%.o: %.c
	$(CC) -c -o $@ $(CFLAGS) $<

.PHONY: clean

clean :
	rm -rf ./*.o $(NAME)

