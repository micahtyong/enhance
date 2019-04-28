/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/

#ifndef WRNCH_POSE_TYPES_C_API
#define WRNCH_POSE_TYPES_C_API

#include <wrnch/definitions.h>

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

struct wrSerializedEstimator;
typedef struct wrSerializedEstimator* wrSerializedEstimatorHandle;
typedef const struct wrSerializedEstimator* wrSerializedEstimatorHandleConst;

/// @brief Return the number of bytes stored in a serialized estimator.
WRNCH_DLL_INTERFACE int wrSerializedEstimator_NumBytes(wrSerializedEstimatorHandleConst);
/// @brief Return a pointer to the bytes stored in a serialized estimator.
WRNCH_DLL_INTERFACE char const* wrSerializedEstimator_Data(wrSerializedEstimatorHandleConst);
WRNCH_DLL_INTERFACE void wrSerializedEstimator_Destroy(wrSerializedEstimatorHandle);

struct wrBox2d;
typedef struct wrBox2d* wrBox2dHandle;
typedef const struct wrBox2d* wrBox2dHandleConst;

WRNCH_DLL_INTERFACE wrBox2dHandle wrBox2d_Create(float x, float y, float width, float height);
WRNCH_DLL_INTERFACE wrBox2dHandle wrBox2d_Clone(wrBox2dHandleConst);
WRNCH_DLL_INTERFACE wrBox2dHandleConst wrBox2d_Advance(wrBox2dHandleConst, ptrdiff_t);
WRNCH_DLL_INTERFACE ptrdiff_t wrBox2d_Difference(wrBox2dHandleConst minuend,
                                                 wrBox2dHandleConst subtrahend);
WRNCH_DLL_INTERFACE void wrBox2d_Copy(wrBox2dHandleConst src, wrBox2dHandle dest);
WRNCH_DLL_INTERFACE void wrBox2d_Destroy(wrBox2dHandle);
WRNCH_DLL_INTERFACE float wrBox2d_GetMinX(wrBox2dHandleConst);
WRNCH_DLL_INTERFACE float wrBox2d_GetMinY(wrBox2dHandleConst);
WRNCH_DLL_INTERFACE float wrBox2d_GetWidth(wrBox2dHandleConst);
WRNCH_DLL_INTERFACE float wrBox2d_GetHeight(wrBox2dHandleConst);
WRNCH_DLL_INTERFACE int wrBox2d_Equals(wrBox2dHandleConst, wrBox2dHandleConst);

struct wrHandBoxPair;
typedef struct wrHandBoxPair* wrHandBoxPairHandle;
typedef const struct wrHandBoxPair* wrHandBoxPairHandleConst;

WRNCH_DLL_INTERFACE wrHandBoxPairHandle wrHandBoxPair_Create();
WRNCH_DLL_INTERFACE wrHandBoxPairHandle wrHandBoxPair_Clone(wrHandBoxPairHandleConst);
WRNCH_DLL_INTERFACE wrHandBoxPairHandleConst wrHandBoxPair_Advance(wrHandBoxPairHandleConst,
                                                                   ptrdiff_t);
WRNCH_DLL_INTERFACE ptrdiff_t wrHandBoxPair_Difference(wrHandBoxPairHandleConst minuend,
                                                       wrHandBoxPairHandleConst subtrahend);
WRNCH_DLL_INTERFACE void wrHandBoxPair_Copy(wrHandBoxPairHandleConst src, wrHandBoxPairHandle dest);
WRNCH_DLL_INTERFACE void wrHandBoxPair_Destroy(wrHandBoxPairHandle);
/*
  returns an unowned reference
 */
WRNCH_DLL_INTERFACE wrBox2dHandleConst wrHandBoxPair_GetLeft(wrHandBoxPairHandleConst);
/*
  returns an unowned reference
 */
WRNCH_DLL_INTERFACE wrBox2dHandleConst wrHandBoxPair_GetRight(wrHandBoxPairHandleConst);
WRNCH_DLL_INTERFACE int wrHandBoxPair_GetId(wrHandBoxPairHandleConst);
WRNCH_DLL_INTERFACE int wrHandBoxPair_Equals(wrHandBoxPairHandleConst, wrHandBoxPairHandleConst);

struct wrPose2d;
typedef struct wrPose2d* wrPose2dHandle;
typedef const struct wrPose2d* wrPose2dHandleConst;

WRNCH_DLL_INTERFACE wrPose2dHandle wrPose2d_Create();
WRNCH_DLL_INTERFACE void wrPose2d_Destroy(wrPose2dHandle);
WRNCH_DLL_INTERFACE wrPose2dHandle wrPose2d_Clone(wrPose2dHandleConst);
WRNCH_DLL_INTERFACE wrPose2dHandleConst wrPose2d_Advance(wrPose2dHandleConst, ptrdiff_t n);
WRNCH_DLL_INTERFACE ptrdiff_t wrPose2d_Difference(wrPose2dHandleConst minuend,
                                                  wrPose2dHandleConst subtrahend);
WRNCH_DLL_INTERFACE void wrPose2d_Copy(wrPose2dHandleConst src, wrPose2dHandle dest);
WRNCH_DLL_INTERFACE int wrPose2d_GetId(wrPose2dHandleConst);
WRNCH_DLL_INTERFACE void wrPose2d_SetId(wrPose2dHandle, int id);
WRNCH_DLL_INTERFACE int wrPose2d_GetIsMain(wrPose2dHandleConst);

/// @deprecated This function is deprecated. Instead, use wrJointDefinition_GetNumJoints
/// @see        wrJointDefinition_GetNumJoints
WRNCH_DLL_INTERFACE unsigned int wrPose2d_GetNumOutputJoints();
WRNCH_DLL_INTERFACE const float* wrPose2d_GetJoints(wrPose2dHandleConst);
WRNCH_DLL_INTERFACE float* wrPose2d_GetJointsMutable(wrPose2dHandle);
WRNCH_DLL_INTERFACE const float* wrPose2d_GetScores(wrPose2dHandleConst);
WRNCH_DLL_INTERFACE float wrPose2d_GetScore(wrPose2dHandleConst);
/*
  returns an unowned reference to a wrBox2d (the box is owned by the wrPose2d struct).
*/
WRNCH_DLL_INTERFACE wrBox2dHandleConst wrPose2d_GetBoundingBox(wrPose2dHandleConst);
WRNCH_DLL_INTERFACE int wrPose2d_Equals(wrPose2dHandleConst, wrPose2dHandleConst);

struct wrBox3d;
typedef const struct wrBox3d* wrBox3dHandleConst;

WRNCH_DLL_INTERFACE float wrBox3d_GetMinX(wrBox3dHandleConst);
WRNCH_DLL_INTERFACE float wrBox3d_GetMinY(wrBox3dHandleConst);
WRNCH_DLL_INTERFACE float wrBox3d_GetMinZ(wrBox3dHandleConst);
WRNCH_DLL_INTERFACE float wrBox3d_GetWidth(wrBox3dHandleConst);
WRNCH_DLL_INTERFACE float wrBox3d_GetHeight(wrBox3dHandleConst);
WRNCH_DLL_INTERFACE float wrBox3d_GetDepth(wrBox3dHandleConst);
WRNCH_DLL_INTERFACE int wrBox3d_Equals(wrBox3dHandleConst, wrBox3dHandleConst);

struct wrPose3d;
typedef struct wrPose3d* wrPose3dHandle;
typedef const struct wrPose3d* wrPose3dHandleConst;

WRNCH_DLL_INTERFACE wrPose3dHandle wrPose3d_Create();
WRNCH_DLL_INTERFACE void wrPose3d_Destroy(wrPose3dHandle);
WRNCH_DLL_INTERFACE wrPose3dHandle wrPose3d_Clone(wrPose3dHandleConst);
WRNCH_DLL_INTERFACE wrPose3dHandleConst wrPose3d_Advance(wrPose3dHandleConst, ptrdiff_t);
WRNCH_DLL_INTERFACE ptrdiff_t wrPose3d_Difference(wrPose3dHandleConst minuend,
                                                  wrPose3dHandleConst subtrahend);
WRNCH_DLL_INTERFACE void wrPose3d_Copy(wrPose3dHandleConst src, wrPose3dHandle dest);
WRNCH_DLL_INTERFACE int wrPose3d_GetId(wrPose3dHandleConst);
WRNCH_DLL_INTERFACE void wrPose3d_SetId(wrPose3dHandle, int id);
/// @deprecated This function is deprecated. Instead, use wrJointDefinition_GetNumJoints
/// @see        wrJointDefinition_GetNumJoints
WRNCH_DLL_INTERFACE unsigned int wrPose3d_GetNumOutputJoints();
WRNCH_DLL_INTERFACE const float* wrPose3d_GetPositions(wrPose3dHandleConst);
WRNCH_DLL_INTERFACE float* wrPose3d_GetPositionsMutable(wrPose3dHandle);
WRNCH_DLL_INTERFACE const float* wrPose3d_GetRotations(wrPose3dHandleConst);
WRNCH_DLL_INTERFACE float* wrPose3d_GetRotationsMutable(wrPose3dHandle);
WRNCH_DLL_INTERFACE unsigned int wrPose3d_GetScaleHintLength();
WRNCH_DLL_INTERFACE const float* wrPose3d_GetScaleHint(wrPose3dHandleConst);
WRNCH_DLL_INTERFACE float* wrPose3d_GetScaleHintMutable(wrPose3dHandle);
WRNCH_DLL_INTERFACE int wrPose3d_Equals(wrPose3dHandleConst, wrPose3dHandleConst);

struct wrArrow;
typedef const struct wrArrow* wrArrowHandleConst;

WRNCH_DLL_INTERFACE float wrArrow_GetTipX(wrArrowHandleConst);
WRNCH_DLL_INTERFACE float wrArrow_GetTipY(wrArrowHandleConst);
WRNCH_DLL_INTERFACE float wrArrow_GetBaseX(wrArrowHandleConst);
WRNCH_DLL_INTERFACE float wrArrow_GetBaseY(wrArrowHandleConst);

struct wrPoseFace;
typedef struct wrPoseFace* wrPoseFaceHandle;
typedef const struct wrPoseFace* wrPoseFaceHandleConst;

WRNCH_DLL_INTERFACE wrPoseFaceHandle wrPoseFace_Create();
WRNCH_DLL_INTERFACE void wrPoseFace_Destroy(wrPoseFaceHandle);
WRNCH_DLL_INTERFACE wrPoseFaceHandle wrPoseFace_Clone(wrPoseFaceHandleConst);
WRNCH_DLL_INTERFACE wrPoseFaceHandleConst wrPoseFace_Advance(wrPoseFaceHandleConst, ptrdiff_t);
WRNCH_DLL_INTERFACE ptrdiff_t wrPoseFace_Difference(wrPoseFaceHandleConst minuend,
                                                    wrPoseFaceHandleConst subtrahend);
WRNCH_DLL_INTERFACE void wrPoseFace_Copy(wrPoseFaceHandleConst src, wrPoseFaceHandle dst);
WRNCH_DLL_INTERFACE int wrPoseFace_GetId(wrPoseFaceHandleConst);
WRNCH_DLL_INTERFACE unsigned int wrPoseFace_GetNumLandmarks(wrPoseFaceHandleConst);
WRNCH_DLL_INTERFACE const float* wrPoseFace_GetLandmarks(wrPoseFaceHandleConst);
WRNCH_DLL_INTERFACE float* wrPoseFace_GetLandmarksMutable(wrPoseFaceHandle);
WRNCH_DLL_INTERFACE wrArrowHandleConst wrPoseFace_GetFaceArrow(wrPoseFaceHandleConst);
WRNCH_DLL_INTERFACE int wrPoseFace_Equals(wrPoseFaceHandleConst, wrPoseFaceHandleConst);
WRNCH_DLL_INTERFACE wrBox2dHandleConst wrPoseFace_GetBoundingBox(wrPoseFaceHandleConst);

struct wrPoseHead;
typedef struct wrPoseHead* wrPoseHeadHandle;
typedef const struct wrPoseHead* wrPoseHeadHandleConst;

WRNCH_DLL_INTERFACE wrPoseHeadHandle wrPoseHead_Create();
WRNCH_DLL_INTERFACE void wrPoseHead_Destroy(wrPoseHeadHandle);
WRNCH_DLL_INTERFACE wrPoseHeadHandle wrPoseHead_Clone(wrPoseHeadHandleConst);
WRNCH_DLL_INTERFACE wrPoseHeadHandleConst wrPoseHead_Advance(wrPoseHeadHandleConst, ptrdiff_t);
WRNCH_DLL_INTERFACE ptrdiff_t wrPoseHead_Difference(wrPoseHeadHandleConst minuend,
                                                    wrPoseHeadHandleConst subtrahend);
WRNCH_DLL_INTERFACE void wrPoseHead_Copy(wrPoseHeadHandleConst src, wrPoseHeadHandle dest);
WRNCH_DLL_INTERFACE int wrPoseHead_GetId(wrPoseHeadHandleConst);
WRNCH_DLL_INTERFACE const float* wrPoseHead_GetHeadRotation(wrPoseHeadHandleConst);
WRNCH_DLL_INTERFACE wrBox3dHandleConst wrPoseHead_GetFaceBoundingBox(wrPoseHeadHandleConst);
WRNCH_DLL_INTERFACE int wrPoseHead_GetEstimationSuccess(wrPoseHeadHandleConst);
WRNCH_DLL_INTERFACE unsigned int wrPoseHead_GetHeadRotationLength();
WRNCH_DLL_INTERFACE unsigned int wrPoseHead_GetFaceBoundingBoxLength();
WRNCH_DLL_INTERFACE int wrPoseHead_Equals(wrPoseHeadHandleConst, wrPoseHeadHandleConst);

#ifdef __cplusplus
}
#endif

#endif /* WRNCH_POSE_TYPES_C_API */
