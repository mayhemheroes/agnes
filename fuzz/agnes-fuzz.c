#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../agnes.h"

agnes_t *agnes;

int LLVMFuzzerInitialize(int *argc, char ***argv) {
    agnes = agnes_make();
         
    if (agnes == NULL) {
        fprintf(stderr, "Making agnes failed.\n");
        return 1;
    }
}

int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {    
    if (Size > 0 && agnes_load_ines_data(agnes, Data, Size)) {
        agnes_next_frame(agnes);
    }
}