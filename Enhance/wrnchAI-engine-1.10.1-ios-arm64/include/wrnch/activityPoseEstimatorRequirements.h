/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/

#ifndef WRNCH_ACTIVITY_POSE_ESTIMATOR_REQUIREMENTS_C_API
#define WRNCH_ACTIVITY_POSE_ESTIMATOR_REQUIREMENTS_C_API

#include <wrnch/definitions.h>
#include <wrnch/jointDefinition.h>
#include <wrnch/returnCodes.h>
#include <wrnch/poseEstimator.h>
#include <wrnch/poseEstimatorOptions.h>


#ifdef __cplusplus
extern "C" {
#endif

/// @file activityPoseEstimatorRequirements.h
/// @brief describes requirements on `wrPoseEstimator` instances to be compatible with a
///         `wrActivityModelGroup`
/// @see `wrPoseEstimator`
/// @see `wrActivityModelGroup`
/// @see poseEstimator.h
/// @see activityModelGroup.h
struct wrPoseEstimatorRequirements;
typedef struct wrPoseEstimatorRequirements const* wrPoseEstimatorRequirementsHandleConst;

/// @brief Return 1 if hands are required, 0 otherwise.
WRNCH_DLL_INTERFACE int wrPoseEstimatorRequirements_RequiresHands(
    wrPoseEstimatorRequirementsHandleConst);

/// @brief Return the "preferred" joint format to be used in a `wrPoseEstimator`.
WRNCH_DLL_INTERFACE wrJointDefinitionHandleConst
    wrPoseEstimatorRequirements_PreferredOutputFormat(wrPoseEstimatorRequirementsHandleConst);

/// @brief Attempt to create a "minimal" `wrPoseEstimator` compatible which is compatible with
///         requirements. If the returned value is not `wrReturnCode_OK`, no `wrPoseEstimator` is
///         created, and nothing is written to `outPoseEstimatorHandle`.
/// @param requirements the `requirements` to be satisfied.
/// @param outPoseEstimatorHandle a pointer to pointer to `wrPoseEstimator`, to be updated on
///         successful creation of a pose estimator
/// @param poseModelDir the name of the directory holding the wrnch pose models.
/// @param deviceId the GPU device id on which the pose estimator should be created.
/// @param desiredNetWidth the desired "network width" of the pose estimator
/// @param desiredNetHeight the desired "network height" of the pose estimator
WRNCH_DLL_INTERFACE wrReturnCode wrPoseEstimatorRequirements_CreateCompatibleEstimator(
    wrPoseEstimatorRequirementsHandleConst requirements,
    wrPoseEstimatorHandle* outPoseEstimatorHandle,
    char const* poseModelDir,
    int deviceId,
    int desiredNetWidth,
    int desiredNetHeight);

/// @brief Create minimal `wrPoseEstimatorOptions` which are compatible with requirements
WRNCH_DLL_INTERFACE wrPoseEstimatorOptionsHandle
wrPoseEstimatorRequirements_CreateCompatibleOptions(
    wrPoseEstimatorRequirementsHandleConst requirements);

/// @brief return 1 if `poseEstimator` is compatible with `requirements`, else return 0
WRNCH_DLL_INTERFACE int wrPoseEstimatorRequirements_IsEstimatorCompatible(
    wrPoseEstimatorRequirementsHandleConst requirements, wrPoseEstimatorHandleConst poseEstimator);

/// @brief return 1 if `options` is compatible with `requirements`, else return 0
WRNCH_DLL_INTERFACE int wrPoseEstimatorRequirements_AreOptionsCompatible(
    wrPoseEstimatorRequirementsHandleConst requirements, wrPoseEstimatorOptionsHandleConst options);

#ifdef __cplusplus
}
#endif

#endif /*WRNCH_ACTIVITY_POSE_ESTIMATOR_REQUIREMENTS_C_API*/
