/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/

#ifndef WRNCH_POSE_PARAMS_C_API
#define WRNCH_POSE_PARAMS_C_API

#include <wrnch/definitions.h>
#include <wrnch/poseTypes.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    wrHandSegmenterType_NAIVE,
    wrHandSegmenterType_FOUR_CHANNEL,
    wrHandSegmenterType_UNKNOWN
} wrHandSegmenterType;

struct wrPoseParams;
typedef struct wrPoseParams* wrPoseParamsHandle;
typedef const struct wrPoseParams* wrPoseParamsHandleConst;

WRNCH_DLL_INTERFACE wrPoseParamsHandle wrPoseParams_Create();
WRNCH_DLL_INTERFACE wrPoseParamsHandle wrPoseParams_Clone(wrPoseParamsHandleConst);
WRNCH_DLL_INTERFACE void wrPoseParams_Copy(wrPoseParamsHandleConst src, wrPoseParamsHandle dest);
WRNCH_DLL_INTERFACE void wrPoseParams_Destroy(wrPoseParamsHandle);

typedef enum { wrSensitivity_LOW, wrSensitivity_MEDIUM, wrSensitivity_HIGH } wrSensitivity;
typedef enum {
    wrNetPrecision_INT8,
    wrNetPrecision_FP16,
    wrNetPrecision_FP32,
    wrNetPrecision_AUTO
} wrNetPrecision;

WRNCH_DLL_INTERFACE void wrPoseParams_SetBoneSensitivity(wrPoseParamsHandle, wrSensitivity);
WRNCH_DLL_INTERFACE void wrPoseParams_SetJointSensitivity(wrPoseParamsHandle, wrSensitivity);
WRNCH_DLL_INTERFACE void wrPoseParams_SetEnableTracking(wrPoseParamsHandle, int yesNo);
WRNCH_DLL_INTERFACE void wrPoseParams_SetPreferredNetWidth2d(wrPoseParamsHandle, int width);
WRNCH_DLL_INTERFACE void wrPoseParams_SetPreferredNetHeight2d(wrPoseParamsHandle, int height);
WRNCH_DLL_INTERFACE void wrPoseParams_SetPreferredNetWidth3d(wrPoseParamsHandle, int width);
WRNCH_DLL_INTERFACE void wrPoseParams_SetPreferredNetHeight3d(wrPoseParamsHandle, int height);
WRNCH_DLL_INTERFACE void wrPoseParams_SetSmoothingBetaX(wrPoseParamsHandle, float betaX);
WRNCH_DLL_INTERFACE void wrPoseParams_SetSmoothingBetaY(wrPoseParamsHandle, float betaY);
WRNCH_DLL_INTERFACE void wrPoseParams_SetSmoothingBetaZ(wrPoseParamsHandle, float betaZ);
WRNCH_DLL_INTERFACE void wrPoseParams_SetSmoothingCutoffFreqVelocity(wrPoseParamsHandle handle,
                                                                     float cutoffFreq);
WRNCH_DLL_INTERFACE void wrPoseParams_SetSmoothingMinCutoffFreqPosition(wrPoseParamsHandle handle,
                                                                        float cutoffFreq);
WRNCH_DLL_INTERFACE void wrPoseParams_SetMinValidJoints(wrPoseParamsHandle, int minJoints);
WRNCH_DLL_INTERFACE void wrPoseParams_SetNetPrecision2d(wrPoseParamsHandle, wrNetPrecision);
WRNCH_DLL_INTERFACE void wrPoseParams_SetNetPrecision3d(wrPoseParamsHandle, wrNetPrecision);
WRNCH_DLL_INTERFACE wrSensitivity wrPoseParams_GetBoneSensitivity(wrPoseParamsHandleConst);
WRNCH_DLL_INTERFACE wrSensitivity wrPoseParams_GetJointSensitivity(wrPoseParamsHandleConst);
WRNCH_DLL_INTERFACE int wrPoseParams_GetEnableTracking(wrPoseParamsHandleConst);
WRNCH_DLL_INTERFACE int wrPoseParams_GetPreferredNetWidth2d(wrPoseParamsHandleConst);
WRNCH_DLL_INTERFACE int wrPoseParams_GetPreferredNetHeight2d(wrPoseParamsHandleConst);
WRNCH_DLL_INTERFACE float wrPoseParams_GetSmoothingBetaX(wrPoseParamsHandleConst);
WRNCH_DLL_INTERFACE float wrPoseParams_GetSmoothingBetaY(wrPoseParamsHandleConst);
WRNCH_DLL_INTERFACE float wrPoseParams_GetSmoothingBetaZ(wrPoseParamsHandleConst);
WRNCH_DLL_INTERFACE float wrPoseParams_GetSmoothingCutoffFreqVelocity(
    wrPoseParamsHandleConst handle);
WRNCH_DLL_INTERFACE float wrPoseParams_GetSmoothingMinCutoffFreqPosition(
    wrPoseParamsHandleConst handle);
WRNCH_DLL_INTERFACE int wrPoseParams_GetMinValidJoints(wrPoseParamsHandleConst);
WRNCH_DLL_INTERFACE wrNetPrecision wrPoseParams_GetNetPrecision2d(wrPoseParamsHandleConst);
WRNCH_DLL_INTERFACE wrNetPrecision wrPoseParams_GetNetPrecision3d(wrPoseParamsHandleConst);
WRNCH_DLL_INTERFACE int wrPoseParams_CheckEquivalent(wrPoseParamsHandleConst,
                                                     wrPoseParamsHandleConst);

struct wrIKParams;
typedef struct wrIKParams* wrIKParamsHandle;
typedef const struct wrIKParams* wrIKParamsHandleConst;

WRNCH_DLL_INTERFACE wrIKParamsHandle wrIKParams_Create();
WRNCH_DLL_INTERFACE wrIKParamsHandle wrIKParams_Clone(wrIKParamsHandleConst);
WRNCH_DLL_INTERFACE void wrIKParams_Copy(wrIKParamsHandleConst src, wrIKParamsHandle dest);
WRNCH_DLL_INTERFACE void wrIKParams_Destroy(wrIKParamsHandle);
WRNCH_DLL_INTERFACE void wrIKParams_SetTransReach(wrIKParamsHandle, float transReach);
WRNCH_DLL_INTERFACE void wrIKParams_SetRotReach(wrIKParamsHandle, float rotReach);
WRNCH_DLL_INTERFACE void wrIKParams_SetPull(wrIKParamsHandle, float pull);
WRNCH_DLL_INTERFACE void wrIKParams_SetResist(wrIKParamsHandle, float resist);
WRNCH_DLL_INTERFACE void wrIKParams_SetMaxAngularVelocity(wrIKParamsHandle,
                                                          float maxAngularVelocity);
WRNCH_DLL_INTERFACE void wrIKParams_SetFPS(wrIKParamsHandle, float fps);
WRNCH_DLL_INTERFACE void wrIKParams_SetJointVisibilityThresh(wrIKParamsHandle, float thresh);
WRNCH_DLL_INTERFACE float wrIKParams_GetTransReach(wrIKParamsHandleConst);
WRNCH_DLL_INTERFACE float wrIKParams_GetRotReach(wrIKParamsHandleConst);
WRNCH_DLL_INTERFACE float wrIKParams_GetPull(wrIKParamsHandleConst);
WRNCH_DLL_INTERFACE float wrIKParams_GetResist(wrIKParamsHandleConst);
WRNCH_DLL_INTERFACE float wrIKParams_GetMaxAngularVelocity(wrIKParamsHandleConst);
WRNCH_DLL_INTERFACE float wrIKParams_GetFPS(wrIKParamsHandleConst);
WRNCH_DLL_INTERFACE float wrIKParams_GetJointVisibilityThresh(wrIKParamsHandleConst);
WRNCH_DLL_INTERFACE int wrIKParams_CheckEquivalent(wrIKParamsHandleConst, wrIKParamsHandleConst);

#ifdef __cplusplus
}
#endif

#endif /* WRNCH_POSE_PARAMS_C_API */
