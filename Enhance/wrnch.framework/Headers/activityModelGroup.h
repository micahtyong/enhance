/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/
#ifndef WRNCH_ACTIVITY_MODEL_GROUP_C_API
#define WRNCH_ACTIVITY_MODEL_GROUP_C_API

#include <wrnch/definitions.h>
#include <wrnch/returnCodes.h>
#include <wrnch/engine.h>
#include <wrnch/activityPoseEstimatorRequirements.h>
#include <wrnch/activityModel.h>


#ifdef __cplusplus
extern "C" {
#endif

/// @file activityModelGroup.h
/// @brief wrActivityModelGroup
///         Represents an optional wrPoseEstimator along with a collection of wrActivityModel
///         "submodels"
/// @see activityModel.h
/// @see poseEstimator.h
struct wrActivityModelGroup;
typedef struct wrActivityModelGroup* wrActivityModelGroupHandle;
typedef struct wrActivityModelGroup const* wrActivityModelGroupHandleConst;

/// @brief Attempt to process an image: first pass to (internal) `wrPoseEstimator`
///         (which must not be null) to process into joint data, then pass joint data to the
///         `wrActivityModel` submodels. Modifies the internal state of the `wrPoseEstimator` and
///         the `wrActivityModel` submodels to hold results based on the image. `wrReturnCode_OK` is
///         returned if and only if no error occurred during processing.
/// @note The behavior is undefined unless the optional `wrPoseEstimator` member of `groupHandle` is
///         not null. We access the optional `wrPoseEstimator` member by either
///         `wrActivityModelGroup_PoseEstimator(groupHandle)` or
///         `wrActivityModelGroup_PoseEstimatorNonConst(groupHandle)`. If either of these return
///         null, then the behavior of `wrActivityModelGroup_ProcessFrame` is undefined. Also note
///         that `wrActivityModelGroup_PoseEstimator(groupHandle)` is null if and only if
///         `wrActivityModelGroup_PoseEstimatorNonConst(groupHandle)` is null.
WRNCH_DLL_INTERFACE wrReturnCode
wrActivityModelGroup_ProcessFrame(wrActivityModelGroupHandle groupHandle,
                                  unsigned char const* rowMajorBgrData,
                                  int imageWidth,
                                  int imageHeight);

/// @brief Attempt to process an image: first pass image to the wrPoseEstimatorHandle estimator
///         argument, which produces joint data, then pass computed joints to the wrActivityModel
///         submodels. Modifies the internal state of estimator and of the submodels.
///         wrReturnCode_OK is returned if and only if no error occurred during processing.
/// @note For best results, the estimator argument should be compatible with
///         `wrActivityModelGroup_Requirements(groupHandle)`. However, it is not undefined behavior
///         to pass an incompatible `wrPoseEstimator`.
/// @see wrPoseEstimatorRequirements
/// @see wrActivityModelGroup_Requirements
WRNCH_DLL_INTERFACE wrReturnCode
wrActivityModelGroup_ProcessFrameWithPoseEstimator(wrActivityModelGroupHandle groupHandle,
                                                   unsigned char const* rowMajorBgrData,
                                                   int imageWidth,
                                                   int imageHeight,
                                                   wrPoseEstimatorHandle estimator);

/// @brief Process joint data held in a pose estimator. Pass the joint data to the `wrActivityModel`
///         submodels of groupHandle.
/// @param groupHandle
/// @param estimator should be compatible with the requirements of `groupHandle`, as returned by
///         `wrActivityModelGroup_Requirements`. In addition, the frame processed by this pose
///         estimator should have used `wrPoseEstimatorOptions` compatible with the requirements as
///         well.
/// @param imageWidth The width of the image used in the last call to
/// `wrPoseEstimator_ProcessFrame`
///         on estimator.
/// @param imageHeight The height of the image used in the last call to
/// `wrPoseEstimator_ProcessFrame`
///         on estimator.
/// @see `wrActivityModelGroup_Requirements`
/// @see `wrPoseEstimatorRequirements_IsEstimatorCompatible`
/// @see `wrPoseEstimatorRequirements_AreOptionsCompatible`
WRNCH_DLL_INTERFACE void wrActivityModelGroup_ProcessPoses(wrActivityModelGroupHandle groupHandle,
                                                           wrPoseEstimatorHandleConst estimator,
                                                           int imageWidth,
                                                           int imageHeight);

/// @brief Return the number of `wrActivityModel` submodels contained in modelGroup.
///         This number corresponds to the number of times the `wrActivityModelGroupBuilder` which
///         built this model group called `wrActivityModelGroupBuilder_AddSubmodel` or
///         `wrActivityModelGroupBuilder_AddReflectedSubmodel`
WRNCH_DLL_INTERFACE int wrActivityModelGroup_NumSubmodels(
    wrActivityModelGroupHandleConst modelGroup);

/// @brief Return a submodel at a given index.
/// @note The behavior is undefined unless `0 <= index` and `index <
///         wrActivityModelGroup_NumSubmodels(modelGroup)`
WRNCH_DLL_INTERFACE wrActivityModelHandleConst
wrActivityModelGroup_Submodel(wrActivityModelGroupHandleConst modelGroup, int index);

/// @brief Return the requirements a pose estimator should satisfy in order to be used in
///         `wrActivityModelGroup_ProcessFrameWithPoseEstimator`
/// @param groupHandle
/// @see `wrActivityModelGroup_ProcessFrameWithPoseEstimator`
WRNCH_DLL_INTERFACE wrPoseEstimatorRequirementsHandleConst
wrActivityModelGroup_Requirements(wrActivityModelGroupHandleConst groupHandle);

/// @brief If `modelGroup` was created with `wrActivityModelGroupBuilder_BuildWithPoseEstimator`,
///         return a const reference to the internal pose estimator held in `modelGroup`. Otherwise,
///         return null.
WRNCH_DLL_INTERFACE wrPoseEstimatorHandleConst
wrActivityModelGroup_PoseEstimator(wrActivityModelGroupHandleConst modelGroup);

/// @brief If `modelGroup` was created with `wrActivityModelGroupBuilder_BuildWithPoseEstimator`,
///         return a non const reference to the internal pose estimator held in `modelGroup`.
///         Otherwise, return null.
WRNCH_DLL_INTERFACE wrPoseEstimatorHandle
    wrActivityModelGroup_PoseEstimatorNonConst(wrActivityModelGroupHandle);

/// @brief Destroy an activity model group. It is safe to call on a null pointer (and has no
///         effect). Model groups created by a builder should be destroyed.
WRNCH_DLL_INTERFACE void wrActivityModelGroup_Destroy(wrActivityModelGroupHandle);

/// @brief `wrActivityModelGroupBuilder` struct whose purpose is to create `wrActivityModelGroup`
///         instances.
struct wrActivityModelGroupBuilder;
typedef struct wrActivityModelGroupBuilder* wrActivityModelGroupBuilderHandle;
typedef struct wrActivityModelGroupBuilder const* wrActivityModelGroupBuilderHandleConst;

/// @brief Create a `wrActivityModelGroupBuilder`. Created `wrActivityModelGroupBuilder` instances
///         should eventually be passed to `wrActivityModelGroupBuilder_Destroy`.
WRNCH_DLL_INTERFACE wrActivityModelGroupBuilderHandle wrActivityModelGroupBuilder_Create();

/// @brief Destroy a `wrActivityModelGroupBuilder` instance. It is safe to pass a null pointer to
///         this function.
WRNCH_DLL_INTERFACE void wrActivityModelGroupBuilder_Destroy(wrActivityModelGroupBuilderHandle);

/// @brief Set the GPU device id to be used for activity models. If `builder` is called with
///         `wrActivityModelGroupBuilder_BuildWithPoseEstimator`, then the built poseEstimator is
///         set to use the same device id.
WRNCH_DLL_INTERFACE void wrActivityModelGroupBuilder_SetDeviceId(
    wrActivityModelGroupBuilderHandle builder, int deviceId);

/// @brief Add an additional wrActivityModel submodel.
/// @param modelPath the full path to the on-disk activity model file.
WRNCH_DLL_INTERFACE void wrActivityModelGroupBuilder_AddSubmodel(wrActivityModelGroupBuilderHandle,
                                                                 char const* modelPath);

/// @brief Add a "reflected" `wrActivityModel` submodel. For the resulting `wrActivityModelGroup`,
///         this means that in the `wrActivityModelGroup_ProcessFrameXXX` variants, human poses are
///         reflected about a vertical axis (as if by a mirror) before passing to the
///         `wrActivityModel` submodels. The reason this exists is because certain activity models
///         are "handed", and only predict (for example) gestures for one side of the body (eg the
///         left). To infer gestures for the other hand (eg the right), the body pose is reflected
///         and then passed to the left-handed model.
WRNCH_DLL_INTERFACE void wrActivityModelGroupBuilder_AddReflectedSubmodel(
    wrActivityModelGroupBuilderHandle, char const* modelPath);

/// @brief Attempt to create a `wrActivityModelGroup`.
///         If the return code is `wrReturnCode_OK`, then a `wrActivityModelGroup` is created (and
///         written to `outActivityModel`) which holds a `wrPoseEstimator` internally (and hence it
///         is safe to call `wrActivityModelGroup_ProcessFrame` on the activity model group). The
///         created (internal) `wrPoseEstimator` is compatible with the requirements of the activity
///         model group (as returned by `wrActivityModelGroup_Requirements`). If the return code is
///         not `wrReturnCode_OK`, then it attempts to describe how it failed. Nothing is written to
///         outActivityModel if `wrReturnCode_OK` is not returned.
WRNCH_DLL_INTERFACE wrReturnCode
wrActivityModelGroupBuilder_BuildWithPoseEstimator(wrActivityModelGroupBuilderHandleConst,
                                                   wrActivityModelGroupHandle* outActivityModel,
                                                   char const* poseModelDir,
                                                   int desiredWidth,
                                                   int desiredHeight);

/// @brief Attempt to create a `wrActivityModelGroup`.
///         If the return code is `wrReturnCode_OK`, then a `wrActivityModelGroup` is created (and
///         written to `outActivityModel`) which *does not* hold a `wrPoseEstimator` internally (and
///         hence it is *not* safe to call `wrActivityModelGroup_ProcessFrame` on the activity model
///         group). If the return code is not `wrReturnCode_OK`, then it attempts to describe how it
///         failed. Nothing is written to `outActivityModel` if `wrReturnCode_OK` is not returned.
WRNCH_DLL_INTERFACE wrReturnCode wrActivityModelGroupBuilder_BuildWithoutPoseEstimator(
    wrActivityModelGroupBuilderHandleConst, wrActivityModelGroupHandle* outActivityModel);

/// @brief Attempt to create a compatible wrPoseEstimator.
///         If the return code is `wrReturnCode_OK`, then a `wrPoseEstimator` is created (and
///         written to `outPoseEstimator`).If the return code is not `wrReturnCode_OK`, then it
///         attempts to describe how it failed. Nothing is written to `outPoseEstimator` if
///         `wrReturnCode_OK` is not returned.
WRNCH_DLL_INTERFACE wrReturnCode
wrActivityModelGroupBuilder_BuildCompatiblePoseEstimator(wrActivityModelGroupBuilderHandleConst,
                                                         wrPoseEstimatorHandle* outPoseEstimator,
                                                         char const* poseModelDir,
                                                         int deviceId,
                                                         int desiredWidth,
                                                         int desiredHeight);

/// @brief Attempt to create a compatible wrPoseEstimatorOptions.
///         If the return code is `wrReturnCode_OK`, then a `wrPoseEstimatorOptions` is created
///         (and written to `outPoseEstimatorOptions`).If the return code is not `wrReturnCode_OK`,
///         then it attempts to describe how it failed. Nothing is written to
///         `outPoseEstimatorOptions` if `wrReturnCode_OK` is not returned.
WRNCH_DLL_INTERFACE wrReturnCode wrActivityModelGroupBuilder_BuildCompatiblePoseEstimatorOptions(
    wrActivityModelGroupBuilderHandleConst, wrPoseEstimatorOptionsHandle* outPoseEstimatorOptions);

#ifdef __cplusplus
}
#endif

#endif /*WRNCH_ACTIVITY_MODEL_GROUP_C_API*/
