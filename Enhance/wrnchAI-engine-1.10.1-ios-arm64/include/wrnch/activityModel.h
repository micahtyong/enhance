/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/
#ifndef WRNCH_ACTIVITY_MODEL_C_API
#define WRNCH_ACTIVITY_MODEL_C_API

#include <wrnch/definitions.h>
#include <wrnch/individualActivityModel.h>


#ifdef __cplusplus
extern "C" {
#endif

/// @file activityModel.h
/// @brief Estimates pose-based activities (or "gestures") for people ("individuals") over time. The
///         underlying model is usually temporal, and requires processing of poses through time for
///         best behavior. Currently, processing of poses is not exposed directly through functions
///         on this struct. Instead, poses are processed by a wrActivityModelGroup, which holds a
///         collection of wrActivityModel (even just one).
/// @see `wrActivityModelGroup_ProcessFrame`
/// @see `wrActivityModelGroup_ProcessFrameWithPoseEstimator`
/// @see `wrActivityModelGroup_ProcessPoses`
/// @see `wrIndividualActivityModel`
struct wrActivityModel;
typedef struct wrActivityModel* wrActivityModelHandle;
typedef struct wrActivityModel const* wrActivityModelHandleConst;

/// @brief Return the number of classes estimated by `activityModel`
WRNCH_DLL_INTERFACE int wrActivityModel_NumClasses(wrActivityModelHandleConst activityModel);

/// @brief Fill out class names estimated by `activityModel` into `outNames`.
/// @note The behavior is undefined unless `outNames` is valid for at least
///         `wrActivityModel_NumClasses(activityModel)` `char const*'s`
WRNCH_DLL_INTERFACE void wrActivityModel_ClassNames(wrActivityModelHandleConst activityModel,
                                                    char const** outNames);

/// @brief Attempt to access the individual activity model of a given person. If no such person has
///         been estimated by activityModel, return null. Generally speaking, this should only be
///         called on `personId` found by the last call to ProcessFrame on the relevant
///         poseEstimator.
WRNCH_DLL_INTERFACE wrIndividualActivityModelHandleConst
wrActivityModel_IndividualModel(wrActivityModelHandleConst activityModel, int personId);

/// @brief Return the number of individual models held by `activityModel`
WRNCH_DLL_INTERFACE int wrActivityModel_NumIndividualModels(
    wrActivityModelHandleConst activityModel);

/// @brief internally, for each `personId` that would be written in `wrActivityModel_PersonIds`,
///         calls visitFun(personId, userData)`
WRNCH_DLL_INTERFACE void wrActivityModel_VisitPersonIds(
    wrActivityModelHandleConst, void (*visitFun)(int personId, void* userData), void* userData);

/// @brief Fill out the estimated personIds held in `activityModel`.
/// @note The behavior is undefined unless personIds is valid for at least
///         `wrActivityModel_NumIndividualModels(activityModel)` ints.
WRNCH_DLL_INTERFACE void wrActivityModel_PersonIds(wrActivityModelHandleConst activityModel,
                                                   int* personIds);

#ifdef __cplusplus
}
#endif

#endif /* WRNCH_ACTIVITY_MODEL_C_API*/
