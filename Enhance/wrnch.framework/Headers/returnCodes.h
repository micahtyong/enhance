/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/

#ifndef WRNCH_ENGINE_RETURN_CODES
#define WRNCH_ENGINE_RETURN_CODES

#include <wrnch/definitions.h>

typedef enum {
    wrReturnCode_OK = 0,
    wrReturnCode_BAD_ALLOC,
    wrReturnCode_PATH_ERROR,
    wrReturnCode_LICENSE_EXPIRED,
    wrReturnCode_LICENSE_ERROR_MALFORMED,
    wrReturnCode_LICENSE_ERROR_VERSION,
    wrReturnCode_LICENSE_ERROR_HOST,
    wrReturnCode_LICENSE_ERROR_NOT_FOUND,
    wrReturnCode_LICENSE_ERROR_OS,
    wrReturnCode_LICENSE_ERROR_OTHER,
    wrReturnCode_OTHER_ERROR,
    wrReturnCode_NO_MODELS,
    wrReturnCode_MODEL_LOAD_FAILED,
    wrReturnCode_HEAD_NOT_INITIALIZED,
    wrReturnCode_HAND_SEGMENTER_NOT_SET,
    wrReturnCode_HANDS_NOT_INITIALIZED,
    wrReturnCode_3D_NOT_INITIALIZED,
    wrReturnCode_JOINT_DEFINITION_ERROR,
    wrReturnCode_HEAD_NOT_SUPPORTED,
    wrReturnCode_CLASSIFIER_NOT_SUPPORTED,
    wrReturnCode_CLONING_NOT_SUPPORTED,
    wrReturnCode_INCOMPATIBLE_POSE_ESTIMATOR_REQUIREMENTS,
    wrReturnCode_DESERIALIZE_ERROR,
    wrReturnCode_UNSUPPORTED_ON_PLATFORM,
    wrReturnCode_NO_SUCH_GPU
} wrReturnCode;

#ifdef __cplusplus
extern "C" {
#endif

WRNCH_DLL_INTERFACE const char* wrReturnCode_Translate(wrReturnCode code);

#ifdef __cplusplus
}
#endif

#endif /* WRNCH_ENGINE_RETURN_CODES */
