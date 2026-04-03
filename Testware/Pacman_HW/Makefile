CC=zcc
INCLUDES=-Iuart_stub -Iuartns550_lite\common -Iuartns550_lite

C_FILES=main.c util.c uartns550_lite/xuartns550.c uartns550_lite/xuartns550_sinit.c
OBJECT_FILES=$(C_FILES:%.c=%.o)

clean:
	rm -f PacMan_Hw_test.bin $(OBJECT_FILES)

PacMan_Hw_test.bin: $(OBJECT_FILES)
	$(CC) +pacman -m -s -lm $(OBJECT_FILES) -startup=2 -o $@
	python ../../../Tools/bin_to_coe_converter.py $@


%.o: %.asm
	$(CC) +pacman --list -c $<

%.o: %.c
	$(CC) +pacman $(INCLUDES) --list -c $<
