#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../agnes.h"

int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {    
    agnes_t *agnes = agnes_make();
    if (agnes == NULL) {
        fprintf(stderr, "Making agnes failed.\n");
        return 1;
    }

    if (Size > 0 && agnes_load_ines_data(agnes, Data, Size - 1)) {
        uint8_t times = Data[Size - 1];
        while(times > 0) {
            agnes_next_frame(agnes);
            times--;
        }
    }

    agnes_destroy(agnes);
}