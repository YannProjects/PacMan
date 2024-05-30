CC=zcc
CC2=gcc
TEST_DIR=/cygdrive/d/Documents/Projets_HW/PacMan/Testware/Test_HW

INCLUDES=-Iuart_stub -Iuartns550_lite\common -Iuartns550_lite -Iembeddedsw-master\XilinxProcessorIPLib\drivers\common\src

C_FILES=main.c uartns550_lite/xuartns550.c uartns550_lite/xuartns550_sinit.c
OBJECT_FILES=$(C_FILES:%.c=%.o)

clean:
	rm -f PacMan_Hw_test.bin $(OBJECT_FILES)

PacMan_Hw_test.bin: $(OBJECT_FILES)
	$(CC) +pacman -vn -startup=2 -m -s -lm $(OBJECT_FILES) -o $@
	python ../../Tools/bin_to_coe_converter.py $@


%.o: %.asm
	$(CC) +pacman -vn -startup=2 --list -c $<

%.o: %.c
	$(CC) +pacman $(INCLUDES) -startup=2 -vn --list -c $<
