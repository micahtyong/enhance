/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/

#ifndef WRNCH_POSE_ESTIMATOR_OPTIONS_C_API
#define WRNCH_POSE_ESTIMATOR_OPTIONS_C_API

#include <wrnch/definitions.h>

#ifdef __cplusplus
extern "C" {
#endif

// Special IDs for automatically selecting the main person
typedef enum {
    wrnch_MAIN_ID_NONE = -1,
    wrnch_MAIN_ID_LARGEST = -2,
    wrnch_MAIN_ID_ALL = -3,
    wrnch_MAIN_ID_CENTER = -4
} wrMainPersonId;

struct wrPoseEstimatorOptions;
typedef struct wrPoseEstimatorOptions* wrPoseEstimatorOptionsHandle;
typedef const struct wrPoseEstimatorOptions* wrPoseEstimatorOptionsHandleConst;

WRNCH_DLL_INTERFACE wrPoseEstimatorOptionsHandle wrPoseEstimatorOptions_Create();
WRNCH_DLL_INTERFACE void wrPoseEstimatorOptions_Destroy(wrPoseEstimatorOptionsHandle);
WRNCH_DLL_INTERFACE void wrPoseEstimatorOptions_SetEstimateMask(wrPoseEstimatorOptionsHandle,
                                                                int yesNo);
WRNCH_DLL_INTERFACE void wrPoseEstimatorOptions_SetEstimate3d(wrPoseEstimatorOptionsHandle,
                                                              int yesNo);
WRNCH_DLL_INTERFACE void wrPoseEstimatorOptions_SetEstimateHands(wrPoseEstimatorOptionsHandle,
                                                                 int yesNo);
WRNCH_DLL_INTERFACE void wrPoseEstimatorOptions_SetEstimateAllHandBoxes(
    wrPoseEstimatorOptionsHandle, int yesNo);
WRNCH_DLL_INTERFACE void wrPoseEstimatorOptions_SetUseIK(wrPoseEstimatorOptionsHandle, int yesNo);
WRNCH_DLL_INTERFACE void wrPoseEstimatorOptions_SetMainPersonId(wrPoseEstimatorOptionsHandle,
                                                                wrMainPersonId mainPersonId);
WRNCH_DLL_INTERFACE void wrPoseEstimatorOptions_SetEnableJointSmoothing(
    wrPoseEstimatorOptionsHandle, int yesNo);
WRNCH_DLL_INTERFACE void wrPoseEstimatorOptions_SetEnableHeadSmoothing(wrPoseEstimatorOptionsHandle,
                                                                       int yesNo);
WRNCH_DLL_INTERFACE void wrPoseEstimatorOptions_SetEstimateHead(wrPoseEstimatorOptionsHandle,
                                                                int yesNo);
WRNCH_DLL_INTERFACE void wrPoseEstimatorOptions_SetEstimatePoseFace(wrPoseEstimatorOptionsHandle,
                                                                    int yesNo);
WRNCH_DLL_INTERFACE void wrPoseEstimatorOptions_SetEstimateSingle(wrPoseEstimatorOptionsHandle,
                                                                  int yesNo);
WRNCH_DLL_INTERFACE void wrPoseEstimatorOptions_SetRotationMultipleOf90(
    wrPoseEstimatorOptionsHandle, int rotationMultipleOf90);

WRNCH_DLL_INTERFACE int wrPoseEstimatorOptions_GetEstimateMask(wrPoseEstimatorOptionsHandleConst);
WRNCH_DLL_INTERFACE int wrPoseEstimatorOptions_GetEstimate3D(wrPoseEstimatorOptionsHandleConst);
WRNCH_DLL_INTERFACE int wrPoseEstimatorOptions_GetEstimateHands(wrPoseEstimatorOptionsHandleConst);
WRNCH_DLL_INTERFACE int wrPoseEstimatorOptions_GetEstimateAllHandBoxes(
    wrPoseEstimatorOptionsHandleConst);
WRNCH_DLL_INTERFACE int wrPoseEstimatorOptions_GetUseIK(wrPoseEstimatorOptionsHandleConst);
WRNCH_DLL_INTERFACE wrMainPersonId
    wrPoseEstimatorOptions_GetMainPersonId(wrPoseEstimatorOptionsHandleConst);
WRNCH_DLL_INTERFACE int wrPoseEstimatorOptions_GetEnableJointSmoothing(
    wrPoseEstimatorOptionsHandleConst);
WRNCH_DLL_INTERFACE int wrPoseEstimatorOptions_GetEnableHeadSmoothing(
    wrPoseEstimatorOptionsHandleConst);
WRNCH_DLL_INTERFACE int wrPoseEstimatorOptions_GetEstimateHead(wrPoseEstimatorOptionsHandleConst);
WRNCH_DLL_INTERFACE int wrPoseEstimatorOptions_GetEstimatePoseFace(
    wrPoseEstimatorOptionsHandleConst);
WRNCH_DLL_INTERFACE int wrPoseEstimatorOptions_GetEstimateSingle(wrPoseEstimatorOptionsHandleConst);
WRNCH_DLL_INTERFACE int wrPoseEstimatorOptions_GetRotationMultipleOf90(
    wrPoseEstimatorOptionsHandleConst);

#ifdef __cplusplus
}
#endif

#endif /* WRNCH_POSE_ESTIMATOR_OPTIONS_C_API */
