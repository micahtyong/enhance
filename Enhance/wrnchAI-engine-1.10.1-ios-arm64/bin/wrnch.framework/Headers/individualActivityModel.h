/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/
#ifndef WRNCH_INDIVIDUAL_ACTIVITY_MODEL_C_API
#define WRNCH_INDIVIDUAL_ACTIVITY_MODEL_C_API

#include <wrnch/definitions.h>


#ifdef __cplusplus
extern "C" {
#endif

/// @file individualActivityModel.h
/// @brief wrIndividualActivityModel
///         Estimates activities (or "gestures") and their probabilities for an individual person.
///         Currently, poses cannot be passed directly to `wrIndividualActivityModel` to update its
///         internal state. Instead, they are passed through `wrActivityModelGroup` instances.
/// @see `wrActivityModelGroup`
/// @see `wrActivityModel`
/// @see activityModelGroup.h
/// @see activityModel.h
struct wrIndividualActivityModel;
typedef struct wrIndividualActivityModel* wrIndividualActivityModelHandle;
typedef struct wrIndividualActivityModel const* wrIndividualActivityModelHandleConst;

/// @brief Return the number of estimated activities.
WRNCH_DLL_INTERFACE int wrIndividualActivityModel_NumClasses(
    wrIndividualActivityModelHandleConst activityModel);

/// @brief Fill out the estimated gesture names into `outNames`.
/// @note The behavior is undefined unless `outNames` is valid for at least
///         `wrIndividualActivityModel_NumClasses(activityModel)` `char const*'s`
WRNCH_DLL_INTERFACE void wrIndividualActivityModel_ClassNames(
    wrIndividualActivityModelHandleConst activityModel, char const** outNames);

/// @brief Return the current estimated gesture-wise probabilities held in `activityModel`. The
///         returned pointer is valid for at least
///         `wrIndividualActivityModel_NumClasses(activityModel)` floats. The order of the
///         probabilities corresponds to the order of the classes written in
///         `wrIndividualActivityModel_ClassNames`
WRNCH_DLL_INTERFACE float const* wrIndividualActivityModel_Probabilities(
    wrIndividualActivityModelHandleConst activityModel);

#ifdef __cplusplus
}
#endif

#endif /* WRNCH_INDIVIDUAL_ACTIVITY_MODEL_C_API*/
