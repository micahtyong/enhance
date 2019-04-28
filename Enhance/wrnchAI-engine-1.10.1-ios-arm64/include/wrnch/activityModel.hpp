/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/
#ifndef WRNCH_ACTIVITY_MODEL_CXX_API
#define WRNCH_ACTIVITY_MODEL_CXX_API

#include <wrnch/activityModel.h>
#include <wrnch/individualActivityModel.hpp>

/// @file activityModel.hpp

namespace wrnch
{
/// @brief `ActivityModelView` RAII C++ wrapper around the (incomplete) C type `wrActivityModel`.
///         Estimates pose-based activities (or "gestures")
///         for people ("individuals") over time. The underlying model is usually temporal, and
///         requires processing of poses through time for best behavior. Currently, processing of
///         poses is not exposed directly through functions on this class. Instead, poses are
///         processed by an `ActivityModelGroup`, which holds a collection of `ActivityModel` (even
///         just one).
/// @see `ActivityModelGroup`
/// @see `wrActivityModelGroup_ProcessFrameWithPoseEstimator`
/// @see `wrActivityModelGroup_ProcessPoses`
/// @see `IndividualActivityModelView`
/// @see individualActivityModel.h
/// @see activityModel.h
class ActivityModelView
{
  public:
    explicit ActivityModelView(wrActivityModel const* impl)
    : m_impl(impl)
    {
    }

    /// @brief Return the number of classes estimated by the activity model
    int NumClasses() const;

    /// @brief Return a vector of strings containing the class names estimated by the activity
    ///         model.
    std::vector<std::string> ClassNames() const;

    /// @brief Attempt to access the individual activity model of a given person. If no such person
    ///         is estimated by `activityModel`, return an empty view (which is compares equal to
    ///         `nullptr` under `operator==`). Generally speaking, this should only be
    ///         called on `personId` found by the last call to ProcessFrame the relevant
    ///         poseEstimator.
    IndividualActivityModelView IndividualModel(int personId) const;

    /// @brief Return the number of individual models held by the activity model
    int NumIndividualModels() const;

    /// @brief semantically equivalent to:
    ///         `for (personId const : activityModel.PersonIds()) { visitFun(personId, userData); }`
    void VisitPersonIds(void (*visitFun)(int personId, void* userData), void* userData) const;

    /// @brief Return a list of personIds that have been estimated by this activity model. Note that
    /// some of these personIds may not have been seen for many frames.
    std::vector<int> PersonIds() const;

    wrActivityModel const* Get() const;
    wrActivityModel const* GetPtr() const;

  private:
    wrActivityModel const* const m_impl;
};

inline bool operator==(ActivityModelView modelView, std::nullptr_t) noexcept
{
    return modelView.GetPtr() == nullptr;
}
inline bool operator==(std::nullptr_t, ActivityModelView modelView) noexcept
{
    return modelView.GetPtr() == nullptr;
}
inline bool operator!=(ActivityModelView modelView, std::nullptr_t) noexcept
{
    return modelView.GetPtr() != nullptr;
}
inline bool operator!=(std::nullptr_t, ActivityModelView modelView) noexcept
{
    return modelView.GetPtr() != nullptr;
}

inline int ActivityModelView::NumClasses() const { return wrActivityModel_NumClasses(m_impl); }

inline std::vector<std::string> ActivityModelView::ClassNames() const
{
    int const numClasses = NumClasses();

    std::vector<std::string> result(numClasses);
    std::vector<char const*> intermediateResult(numClasses);

    wrActivityModel_ClassNames(m_impl, intermediateResult.data());

    for (int ix = 0; ix < numClasses; ++ix)
    {
        result[ix] = intermediateResult[ix];
    }

    return result;
}

inline IndividualActivityModelView ActivityModelView::IndividualModel(int personId) const
{
    return IndividualActivityModelView{ wrActivityModel_IndividualModel(m_impl, personId) };
}

inline int ActivityModelView::NumIndividualModels() const
{
    return wrActivityModel_NumIndividualModels(m_impl);
}

inline void ActivityModelView::VisitPersonIds(void (*visitFun)(int personId, void* userData),
                                              void* userData) const
{
    wrActivityModel_VisitPersonIds(m_impl, visitFun, userData);
}

inline std::vector<int> ActivityModelView::PersonIds() const
{
    std::vector<int> result(NumIndividualModels());
    wrActivityModel_PersonIds(GetPtr(), result.data());
    return result;
}

inline wrActivityModel const* ActivityModelView::Get() const { return GetPtr(); }
inline wrActivityModel const* ActivityModelView::GetPtr() const { return m_impl; }

}  // namespace wrnch

#endif /* WRNCH_ACTIVITY_MODEL_CXX_API*/
