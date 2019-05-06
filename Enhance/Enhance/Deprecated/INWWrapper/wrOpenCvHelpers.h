/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/

/*
#ifndef WRNCH_SAMPLES_OPEN_CV_HELPERS
#define WRNCH_SAMPLES_OPEN_CV_HELPERS
#include <wrAPI/engine.h>

//
//  The C-API for openCV is deprecated in favour of the C++ Api.
//  This is just a thin C-wrapper to some openCV operations
//

struct wrCvMat;
typedef struct wrCvMat* wrCvMatHandle;
typedef const struct wrCvMat* wrCvMatHandleConst;

#ifdef __cplusplus
extern "C" {
#endif

wrReturnCode wrCvMat_LoadImage(const char* filename, wrCvMatHandle* handle);
void wrCvMat_Release(wrCvMatHandle);

const unsigned char* wrCvMat_GetData(wrCvMatHandleConst);
int wrCvMat_GetCols(wrCvMatHandleConst);
int wrCvMat_GetRows(wrCvMatHandleConst);


#ifdef __cplusplus
}
#endif

#endif
*/
