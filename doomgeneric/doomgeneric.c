#include <stdio.h>

#include "m_argv.h"

#include "doomgeneric.h"

uint32_t* DG_ScreenBuffer = 0;

void M_FindResponseFile(void);
void D_DoomMain (void);

#include <memview.h>

static void doomgeneric_init_memview()
{
	uint64_t bytes_for_stacktrace = 1024 * 1024 * 2;
	uint64_t memview_buffer_size = memview_calc_min_required_memory(bytes_for_stacktrace);
	char* buffer = malloc(memview_buffer_size);
	if (memview_init(buffer, memview_buffer_size, bytes_for_stacktrace)) {
		printf("memview init successful\n");
	} else {
		printf("memview init failed\n");
	}
	memview_wait_for_connection();
}


void doomgeneric_Create(int argc, char **argv)
{
	// save arguments
    myargc = argc;
    myargv = argv;

    doomgeneric_init_memview();

	M_FindResponseFile();

	DG_ScreenBuffer = malloc(DOOMGENERIC_RESX * DOOMGENERIC_RESY * 4);

	DG_Init();

	D_DoomMain ();
}

