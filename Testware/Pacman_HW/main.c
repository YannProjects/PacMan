#include <stdio.h>
#include <xuartns550.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <util.h>
#include <xparameters.h>

#define SOUND_EN_REG			0x5001
#define DIP_SW_ADDR				0x5080
#define TILE_RAM_ADDR			0x4000
#define PALETTE_RAM_ADDR		0x4400

#define VOICE_1_WAVEFORM_CONFIG_ADDR	0x5045
#define VOICE_2_WAVEFORM_CONFIG_ADDR	0x504A
#define VOICE_3_WAVEFORM_CONFIG_ADDR	0x504F

#define VOICE_1_FREQ_CONFIG_ADDR		0x5050
#define VOICE_2_FREQ_CONFIG_ADDR		0x5056
#define VOICE_3_FREQ_CONFIG_ADDR		0x505B

#define VOICE_1_VOL_CONFIG_ADDR			0x5055
#define VOICE_2_VOL_CONFIG_ADDR			0x505A
#define VOICE_3_VOL_CONFIG_ADDR			0x505F

#ifdef UART_STUB
char flash_memory_stub[32*1024];
#define FLASH_MEMORY_BASE				flash_memory_stub
#else
#define FLASH_MEMORY_BASE				0x8000
#endif

#define IN0_REG_ADDR					0x5000
#define IN1_REG_ADDR					0x5040

#define EMPTY_TILE	64

const unsigned long frequency_table[][10] = {
	// C
	{0xB3, 0x165, 0x2CA, 0x595, 0xB2A, 0x1653, 0x2CA7, 0x594D, 0xB29A, 0x16535},
	// C#
	{0xBD, 0x17A, 0x2F5, 0x5EA, 0xBD4, 0x17A7, 0x2F4E, 0x5E9D, 0xBD39, 0x17A72},
	// D
	{0xC8, 0x191, 0x322, 0x644, 0xC88, 0x190F, 0x321E, 0x643D, 0xC87A, 0x190F3},
	// D#
	{0xD4, 0x1A9, 0x352, 0x6A3, 0xD46, 0x1A8D, 0x3519, 0x6A33, 0xD465, 0x1A8CB},
	// E
	{0xE1, 0x1C2, 0x384, 0x708, 0xE10, 0x1C21, 0x3842, 0x7083, 0xE107, 0x1C20D},
	// F
	{0xEE, 0x1DD, 0x3BA, 0x773, 0xEE7, 0x1DCD, 0x3B9A, 0x7734, 0xEE68, 0x1DCD0},
	// F#
	{0xFD, 0x1F9, 0x3F2, 0x7E5, 0xFC9, 0x1F93, 0x3F25, 0x7E4B, 0xFC95, 0x1F92A},
	// G
	{0x10C, 0x217, 0x42E, 0x85D, 0x10BA, 0x2173, 0x42E7, 0x85CD, 0x10B9A, 0x21734},
	// G#
	{0x11C, 0x237, 0x46E, 0X8DC, 0x11B8, 0x2370, 0x46E1, 0x8DC2, 0x11B84, 0x23708},
	// A
	{0x12C, 0X259, 0x4B1, 0x963, 0x12C6, 0x258C, 0x4B18, 0x9630, 0x12C60, 0x258BF},
	// A#
	{0x13E, 0x27C, 0X4F9, 0x9F2, 0x13E4, 0x27C8, 0x4F8F, 0x9F1E, 0X13E3C, 0x27C78},
	// B
	{0x151, 0x2A2, 0x545, 0xA89, 0X1513, 0X2A25, 0x544A, 0XA894, 0x15128, 0x2A251}
};

#define H_LEN					32
#define V_LEN					28

#define VRAM_ADDRESS(x,y) (y*0x20 + 0x40 + x)
#define UPPER_BORDER_VRAM_ADDRESS(x,y) (y*0x20 + 0x3C0 + x)
#define LOWER_BORDER_VRAM_ADDRESS(x,y) (y*0x20 + x)

char SendBuffer[320];
long int FrameCounter;

extern void sleep_ms(unsigned int duree_ms);
extern void UartSendBuffer(const unsigned char *buffer, unsigned int length);
extern char *UartReadLn();
extern unsigned char hexdigit( char hex );

const char title[] =
	"\r\n\n\n----------------------------------------\n\r"
	"Bienvenue dans le monde 80's du test de HW Pacman\n\r"
	"----------------------------------------\n\r"
	"Options disponible;\n\r"
	"1. Lecture compteur VBLANK\n\r"
	"2. Tester des tiles\n\r"
	"3. Tester des sprites\n\r"
	"4. Tester le son\n\r"
	"5. Tester les switch\n\r"
	"6. Test des entrees\n\r"
	"7. Memory dump\n\r"
	"8. Arret du son\n\r"
	"Option ?: ";

/*
int UartPrintf(const char* format, ...)
{
	int ret;
	va_list vl;

	va_start(vl, format);
	ret = vsprintf(SendBuffer, format, vl);
	va_end(vl);
	UartSendBuffer(SendBuffer, strlen(SendBuffer));
	return ret;
}
*/

void Lecture_DIPSw()
{
	unsigned char dip_sw, mask, i;

	dip_sw = *(unsigned char *)DIP_SW_ADDR;

	for (i=0; i < 6; i++) {
		mask = 1 << i;
		sprintf(SendBuffer, "SW%d : ", i);
		if (dip_sw & mask) {
			strcat(SendBuffer, "OFF\n\r");
		} else {
			strcat(SendBuffer, "ON\n\r");
		}

		UartSendBuffer(SendBuffer, strlen(SendBuffer));
	}
}

void ClearScreen()
{
	unsigned char x, y;

	// Effacement ecran
	for (y = 0; y < V_LEN; y++)
	{
		for (x=0; x < H_LEN; x++)
		{
			*(volatile unsigned char *)(TILE_RAM_ADDR + VRAM_ADDRESS(x,y)) = EMPTY_TILE;
		}
	}

	// Effacement bandeaux supérieur et inférieur
	for (y=0; y < 2; y++)
	{
		for (x=0; x < 32; x++) {
			*(volatile unsigned char *)(TILE_RAM_ADDR + UPPER_BORDER_VRAM_ADDRESS(x,y)) = EMPTY_TILE;
			*(volatile unsigned char *)(TILE_RAM_ADDR + LOWER_BORDER_VRAM_ADDRESS(x,y)) = EMPTY_TILE;
		}
			
	}
}

const char tile_display[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 
							 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159,
							 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175};

void Change_Palette()
{
	unsigned char palette, x, y;

	for (palette = 1; palette < 11; palette += 2)
	{
		sprintf(SendBuffer, "\n\rUtilisation palette : %d", palette);
		UartSendBuffer(SendBuffer, strlen(SendBuffer));
		for (y = 0; y < V_LEN; y++)
		{
			for (x=0; x < H_LEN; x++)
			{
				*(volatile unsigned char *)(PALETTE_RAM_ADDR + VRAM_ADDRESS(x,y)) = palette;
			}
		}

		for (y=0; y < 2; y++)
		{
			for (x=0; x < 32; x++) {
				*(volatile unsigned char *)(PALETTE_RAM_ADDR + UPPER_BORDER_VRAM_ADDRESS(x,y)) = palette;
				*(volatile unsigned char *)(PALETTE_RAM_ADDR + LOWER_BORDER_VRAM_ADDRESS(x,y)) = palette;
			}
				
		}

		sleep_ms(2*1000);
	}
}

void Test_Tiles()
{
	unsigned char x, y;
	volatile unsigned char *tile_addr, *tile_palette_addr;
	unsigned char *input_tile_id, *input_palette_id;
	unsigned int tile_id;
		
	ClearScreen();

	for (y = 0; y < V_LEN; y++)
	{
		for (x=0; x < H_LEN; x++)
		{
			*(volatile unsigned char *)(TILE_RAM_ADDR + VRAM_ADDRESS(x,y)) = tile_display[V_LEN - y];
		}
	}
	Change_Palette();

	ClearScreen();
	sprintf(SendBuffer, "\n\rAffichage bandeau superieur");
	UartSendBuffer(SendBuffer, strlen(SendBuffer));
	for (y=0; y < 2; y++)
	{
		for (x=0; x < 32; x++)
		{
			*(volatile unsigned char *)(TILE_RAM_ADDR + UPPER_BORDER_VRAM_ADDRESS(x,y)) = tile_display[y];
		}
	}
	Change_Palette();

	ClearScreen();
	sprintf(SendBuffer, "\n\rAffichage bandeau inferieur");
	UartSendBuffer(SendBuffer, strlen(SendBuffer));
	for (y=0; y < 2; y++)
	{
		for (x=0; x < 32; x++)
		{
			*(volatile unsigned char *)(TILE_RAM_ADDR + LOWER_BORDER_VRAM_ADDRESS(x,y)) = tile_display[y + 2];
		}
	}
	Change_Palette();
}

void Test_Son()
{
	char *input_voice_1_waveform_id, *input_voice_1_note_id;
	char *input_voice_1_octave_id, *input_voice_1_volume_id;
	unsigned int voice_1_waveform_id, voice_1_note_id, voice_1_octave_id, voice_1_volume_id, nibble;
	unsigned long frequency;

	sprintf(SendBuffer, "\n\rVoice 1 waveform ID ? (0-15) : ");
	UartSendBuffer(SendBuffer, strlen(SendBuffer));
	input_voice_1_waveform_id = UartReadLn();
	sscanf((char *)input_voice_1_waveform_id, "%d", &voice_1_waveform_id);

	sprintf(SendBuffer, "\n\rDO=0, DO#=1, RE=2, RE#=3, MI=4, FA=5, FA#=6");
	UartSendBuffer(SendBuffer, strlen(SendBuffer));
	sprintf(SendBuffer, "\n\rSOL=7, SOL#=8, LA=9, LA#=10, SI=11");
	UartSendBuffer(SendBuffer, strlen(SendBuffer));

	sprintf(SendBuffer, "\n\rVoice 1 Note ID (0-11) ? : ");
	UartSendBuffer(SendBuffer, strlen(SendBuffer));
	input_voice_1_note_id = UartReadLn();
	sscanf((char *)input_voice_1_note_id, "%d", &voice_1_note_id);

	sprintf(SendBuffer, "\n\rVoice 1 octave ID (0-9) ? : ");
	UartSendBuffer(SendBuffer, strlen(SendBuffer));
	input_voice_1_octave_id = UartReadLn();
	sscanf((char *)input_voice_1_octave_id, "%d", &voice_1_octave_id);

	sprintf(SendBuffer, "\n\rVoice 1 volume ID ? : ");
	UartSendBuffer(SendBuffer, strlen(SendBuffer));
	input_voice_1_volume_id = UartReadLn();
	sscanf((char *)input_voice_1_volume_id, "%d", &voice_1_volume_id);

	*(unsigned char *)VOICE_1_WAVEFORM_CONFIG_ADDR = voice_1_waveform_id;
	*(unsigned char *)VOICE_1_VOL_CONFIG_ADDR = voice_1_volume_id;

	// Configuration de la frequence à l'aide de la table frequency_table
	frequency = frequency_table[voice_1_note_id][voice_1_octave_id];
	*(unsigned char *)(VOICE_1_FREQ_CONFIG_ADDR) = frequency & 0x0000000F;
	*(unsigned char *)(VOICE_1_FREQ_CONFIG_ADDR + 1) = (frequency & 0x000000F0) >> 4;
	*(unsigned char *)(VOICE_1_FREQ_CONFIG_ADDR + 2) = (frequency & 0x00000F00) >> 8;
	*(unsigned char *)(VOICE_1_FREQ_CONFIG_ADDR + 3) = (frequency & 0x0000F000) >> 12;
	*(unsigned char *)(VOICE_1_FREQ_CONFIG_ADDR + 4) = (frequency & 0x000F0000) >> 16;

	sprintf(SendBuffer, "\n\rGeneration son voice 1 : Waveform : %d, Frequency : %lu, Volume : %d", 
		voice_1_waveform_id, frequency, voice_1_volume_id);
	UartSendBuffer(SendBuffer, strlen(SendBuffer));

	// Activation du son
	*(unsigned char *)SOUND_EN_REG = 1;
}

void Stop_Son()
{
	// Désactivation du volumes des canaux non utilises
	*(unsigned char *)VOICE_1_VOL_CONFIG_ADDR = 0;
	*(unsigned char *)VOICE_2_VOL_CONFIG_ADDR = 0;
	*(unsigned char *)VOICE_3_VOL_CONFIG_ADDR = 0;

	// Desactivation du son
	*(unsigned char *)SOUND_EN_REG = 0;
}

const unsigned int sprite_x_registers_regs[] = {0x5060, 0x5062, 0x5064, 0x5066, 0x5068, 0x506A, 0x506C, 0x506E};
const unsigned int sprite_y_registers_regs[] = {0x5061, 0x5063, 0x5065, 0x5067, 0x5069, 0x506B, 0x506D, 0x506F};
const unsigned int sprite_ids_regs[] = {0x4FF0, 0x4FF2, 0x4FF4, 0x4FF6, 0x4FF8, 0x4FFA, 0x4FFC, 0x4FFE};
const unsigned int sprite_palette_regs[] = {0x4FF1, 0x4FF3, 0x4FF5, 0x4FF7, 0x4FF9, 0x4FFB, 0x4FFD, 0x4FFF};

void Test_Sprites()
{
	unsigned int sprite_x, sprite_y, sprite_palette, sprite_id, sprite_image, x, y;
	char *input_sprite_id, *input_sprite_palette, *input_sprite_x, *input_sprite_y, input_sprite_image_id;

	sprintf(SendBuffer, "\rTest des sprites\n\r");
	UartSendBuffer(SendBuffer, strlen(SendBuffer));

	// Remplissage de l'ecran
	ClearScreen();
	for (y = 0; y < V_LEN; y++)
	{
		for (x=0; x < H_LEN; x++)
		{
			*(volatile unsigned char *)(TILE_RAM_ADDR + VRAM_ADDRESS(x,y)) = tile_display[V_LEN - y];
		}
	}

	sprintf(SendBuffer, "\n\rSprite ID ? (1-6) : ");
	UartSendBuffer(SendBuffer, strlen(SendBuffer));
	input_sprite_id = UartReadLn();
	sscanf((char *)input_sprite_id, "%d", &sprite_id);

	sprintf(SendBuffer, "\n\rSprite image ID ? (0-63) : ");
	UartSendBuffer(SendBuffer, strlen(SendBuffer));
	input_sprite_image_id = UartReadLn();
	sscanf((char *)input_sprite_id, "%d", &sprite_image);

	sprintf(SendBuffer, "\n\rSprite palette ? (0-15) : ");
	UartSendBuffer(SendBuffer, strlen(SendBuffer));
	input_sprite_palette = UartReadLn();
	sscanf((char *)input_sprite_palette, "%d", &sprite_palette);

	sprintf(SendBuffer, "\n\rSprite X ? (16-240) : ");
	UartSendBuffer(SendBuffer, strlen(SendBuffer));
	input_sprite_x = UartReadLn();
	sscanf((char *)input_sprite_x, "%d", &sprite_x);

	sprintf(SendBuffer, "\n\rSprite Y ? (0-255) : ");
	UartSendBuffer(SendBuffer, strlen(SendBuffer));
	input_sprite_y = UartReadLn();
	sscanf((char *)input_sprite_y, "%d", &sprite_y);

	sprintf(SendBuffer, "\n\rProgrammation sprite#%d, image=%d X=%d, Y=%d avec la palette %d", sprite_id, sprite_image, sprite_x, sprite_y, sprite_palette);
	UartSendBuffer(SendBuffer, strlen(SendBuffer));

	*(volatile unsigned char *)(sprite_x_registers_regs[sprite_id]) = (char)sprite_x;
	*(volatile unsigned char *)(sprite_y_registers_regs[sprite_id]) = (char)sprite_y;
	*(volatile unsigned char *)(sprite_palette_regs[sprite_id]) = (char)sprite_palette;
	*(volatile unsigned char *)(sprite_ids_regs[sprite_id]) = (((char)sprite_image) << 2);
}

#define DUMP_LINES_NB	128/16

/* Code modifie avec l'aide de Copilot qui conseille de supprimer l'utilisation de sscanf et
	de le remplacer par strtoul. Il explique aussi que z88dk introduit des décalage sur les adresses 
	Ce comportement est connu : les pointeurs locaux sont décalés car Z88DK réserve 2 octets pour l’auto‑sauvegarde du pointeur dans la pile.
	J'ai donc suivi ses coneil et récupéré la fonction qu'il a proposée */
void MemoryDump(void)
{
    unsigned int i, j;
    unsigned long addr;
    unsigned char *memory_ptr;
    unsigned char valeur;
    char *hex_mem_addr, hexbuffer[16];

	sprintf(SendBuffer, "Addresse memoire a dumper ? : 0x");
	UartSendBuffer(SendBuffer, strlen(SendBuffer));

	hex_mem_addr = UartReadLn();

    // Conversion fiable de l'adresse
    addr = strtoul(hex_mem_addr, NULL, 16);

    // Cast propre vers un pointeur 16 bits
    memory_ptr = (unsigned char *)(uintptr_t)addr;

    for (i = 0; i < DUMP_LINES_NB; i++) {

        // Affiche l'adresse de début de ligne
        sprintf(SendBuffer, "0x%04lX : ", addr);

        for (j = 0; j < 16; j++) {
            valeur = memory_ptr[j];
            sprintf(hexbuffer, "%02X ", valeur);
            strcat(SendBuffer, hexbuffer);
        }

        strcat(SendBuffer, "\n\r");
        UartSendBuffer(SendBuffer, strlen(SendBuffer));

        memory_ptr += 16;
        addr += 16;
    }
}

#define BUTTON_COIN1_MASK		0x20
#define BUTTON_START1_MASK		0x20
#define BUTTON_CREDIT_MASK		0x80

#define JOSTICK_DOWN_MASK		0x01
#define JOSTICK_RIGHT_MASK		0x02
#define JOSTICK_LEFT_MASK		0x04
#define JOSTICK_UP_MASK			0x08

void Inputs_Test()
{
	char in0, in0_change, in0_old;
	char in1, in1_change, in1_old, exit_loop = 0;

	in0_old = *(volatile char *)(IN0_REG_ADDR);
	in1_old = *(volatile char *)(IN1_REG_ADDR);

	while (exit_loop == 0)
	{
		in0 = *(volatile char *)(IN0_REG_ADDR);
		in1 = *(volatile char *)(IN1_REG_ADDR);

		in0_change = in0 ^ in0_old;
		in1_change = in1 ^ in1_old;

		// COIN1
		if ((in0_change & BUTTON_COIN1_MASK) == BUTTON_COIN1_MASK) {
			if ((in0 & BUTTON_COIN1_MASK) == BUTTON_COIN1_MASK) {
				sprintf(SendBuffer, "\rBouton COIN1 relache\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
			} else {
				sprintf(SendBuffer, "\rBouton COIN1 appuyé\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
			}
		}

		// CREDIT
		if ((in0_change & BUTTON_CREDIT_MASK) == BUTTON_CREDIT_MASK) {
			if ((in0 & BUTTON_CREDIT_MASK) == BUTTON_CREDIT_MASK) {
				sprintf(SendBuffer, "\rBouton CREDIT relache\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
			} else {
				sprintf(SendBuffer, "\rBouton CREDIT appuye\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
			}
		}		

		// UP1
		if ((in0_change & JOSTICK_UP_MASK) == JOSTICK_UP_MASK) {
			if ((in0 & JOSTICK_UP_MASK) == JOSTICK_UP_MASK) {
				sprintf(SendBuffer, "\rJoystick UP relache\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
			} else {
				sprintf(SendBuffer, "\rJoystick UP appuye\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
			}
		}

		// RIGHT1
		if ((in0_change & JOSTICK_RIGHT_MASK) == JOSTICK_RIGHT_MASK) {
			if ((in0 & JOSTICK_RIGHT_MASK) == JOSTICK_RIGHT_MASK) {
				sprintf(SendBuffer, "\rJoystick RIGHT relache\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
			} else {
				sprintf(SendBuffer, "\rJoystick RIGHT appuye\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
			}
		}

		// DOWN1
		if ((in0_change & JOSTICK_DOWN_MASK) == JOSTICK_DOWN_MASK) {
			if ((in0 & JOSTICK_DOWN_MASK) == JOSTICK_DOWN_MASK) {
				sprintf(SendBuffer, "\rJoystick DOWN relache\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
			} else {
				sprintf(SendBuffer, "\rJoystick DOWN appuye\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
			}
		}

		// LEFT1
		if ((in0_change & JOSTICK_LEFT_MASK) == JOSTICK_LEFT_MASK) {
			if ((in0 & JOSTICK_LEFT_MASK) == JOSTICK_LEFT_MASK) {
				sprintf(SendBuffer, "\rJoystick LEFT relache\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
			} else {
				sprintf(SendBuffer, "\rJoystick LEFT appuye\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
			}
		}		

		// START1
		if ((in1_change & BUTTON_START1_MASK) == BUTTON_START1_MASK) {
			if ((in1 & BUTTON_START1_MASK) == BUTTON_START1_MASK) {
				sprintf(SendBuffer, "\rBouton START1 relache\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
			} else {
				sprintf(SendBuffer, "\rBouton START1 appuye\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
			}
		}

		// Combinaison de sortie : UP + START1
		if (((in0 & JOSTICK_UP_MASK) == 0) && ((in1 & BUTTON_START1_MASK) == 0)) {
			exit_loop = 1;
		}

		in0_old = in0;
		in1_old = in1;
	}
}

void DisplayUpTime()
{
	unsigned long duree_s;
	unsigned int  duree_h, duree_mn, duree_sec;

	duree_s = (FrameCounter * VBLANK_PERIOD) / 1000;
	duree_h = duree_s / 3600;
	duree_mn = (duree_s - 3600*duree_h) / 60;
	duree_sec = duree_s - 3600*duree_h - 60*duree_mn;

	// Affichage sur l'ecran et envoi sur le port serie
	printf("Uptime : %d h : %d mn : %d s\n\r", duree_h, duree_mn, duree_sec);
	sprintf(SendBuffer, "Uptime : %d h : %d mn : %d s\n\r", duree_h, duree_mn, duree_sec);
	UartSendBuffer(SendBuffer, strlen(SendBuffer));
}

int main(int a, char **arg) {

	char *input_ptr, input_option;
    unsigned int c, Status, mcr, LsrRegister, choice;

    Status = XUartNs550_Initialize();

	ClearScreen();

	while(1) {
		UartSendBuffer(title, strlen(title));
		input_ptr = UartReadLn();
		sscanf((char *)input_ptr, "%d", &choice);

		switch (choice)
		{
			case 1:
				sprintf(SendBuffer, "\rLecture compteur VBLANK sur l'ecran\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
				DisplayUpTime();
				break;
			case 2:
				sprintf(SendBuffer, "\rDemarrage du test des tiles\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
				Test_Tiles();
				break;
			case 3:
				sprintf(SendBuffer, "\rDemarrage du test des sprites\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
				Test_Sprites();
				break;
			case 4:
				sprintf(SendBuffer, "\rDemarrage du test du son\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
				Test_Son();
				break;
			case 5:
				sprintf(SendBuffer, "\rDemarrage du test des switch\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
				Lecture_DIPSw();
				break;
			case 6:
				sprintf(SendBuffer, "\rDemarrage du test des entrees\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
				Inputs_Test();
				break;
			case 7:
				sprintf(SendBuffer, "\rMemory dump\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
				MemoryDump();
				break;
			case 8:
				sprintf(SendBuffer, "\rArret du son\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
				Stop_Son();
				break;								
			default:
				sprintf(SendBuffer, "\rOption inconnue !\n\r");
				UartSendBuffer(SendBuffer, strlen(SendBuffer));
		}
	}
}
