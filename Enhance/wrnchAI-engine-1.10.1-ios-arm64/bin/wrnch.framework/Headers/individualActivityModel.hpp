/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/
#ifndef WRNCH_INDIVIDUAL_ACTIVITY_MODEL_CXX_API
#define WRNCH_INDIVIDUAL_ACTIVITY_MODEL_CXX_API

#include <wrnch/individualActivityModel.h>

#include <string>
#include <vector>

/// @file individualActivityModel.h

namespace wrnch
{
/// @brief IndividualActivityModelView RAII C++ wrapper around wrIndividualActivityModel.
///         Estimates activities (or "gestures") and their probabilities for an individual person.
///         Currently, poses cannot be passed directly to IndividualActivityModel to update its
///         internal state. Instead, they are passed through ActivityModelGroup instances.
/// @see ActivityModelGroup
/// @see ActivityModel
/// @see wrIndividualActivityModel
class IndividualActivityModelView
{
  public:
    explicit IndividualActivityModelView(wrIndividualActivityModel const* impl)
    : m_impl(impl)
    {
    }

    /// @brief Return the number of estimated activities. Semantically equivalent to:
    ///         `static_cast<int>(ClassNames().size())`
    int NumClasses() const;

    /// @brief Return a vector of strings containing the class names estimated by the activity
    ///         model.
    std::vector<std::string> ClassNames() const;

    /// @brief Return the current estimated gesture-wise probabilities held in `*this`. The
    ///         returned pointer is valid for at least `NumClasses()` floats. The
    ///         order of probabilities corresponds to the order of the classes returned in
    ///         `ClassNames`.
    float const* Probabilities() const;

    wrIndividualActivityModel const* Get() const;
    wrIndividualActivityModel const* GetPtr() const;

  private:
    wrIndividualActivityModel const* const m_impl;
};

inline bool operator==(IndividualActivityModelView modelView, std::nullptr_t) noexcept
{
    return modelView.GetPtr() == nullptr;
}
inline bool operator==(std::nullptr_t, IndividualActivityModelView modelView) noexcept
{
    return modelView.GetPtr() == nullptr;
}
inline bool operator!=(IndividualActivityModelView modelView, std::nullptr_t) noexcept
{
    return modelView.GetPtr() != nullptr;
}
inline bool operator!=(std::nullptr_t, IndividualActivityModelView modelView) noexcept
{
    return modelView.GetPtr() != nullptr;
}

inline int IndividualActivityModelView::NumClasses() const
{
    return wrIndividualActivityModel_NumClasses(m_impl);
}

inline std::vector<std::string> IndividualActivityModelView::ClassNames() const
{
    int const numClasses = NumClasses();

    std::vector<std::string> result(numClasses);
    std::vector<char const*> intermediateResult(numClasses);

    wrIndividualActivityModel_ClassNames(m_impl, intermediateResult.data());

    for (int ix = 0; ix < numClasses; ++ix)
    {
        result[ix] = intermediateResult[ix];
    }

    return result;
}

inline float const* IndividualActivityModelView::Probabilities() const
{
    return wrIndividualActivityModel_Probabilities(m_impl);
}

inline wrIndividualActivityModel const* IndividualActivityModelView::Get() const
{
    return GetPtr();
}

inline wrIndividualActivityModel const* IndividualActivityModelView::GetPtr() const
{
    return m_impl;
}

}  // namespace wrnch

#endif /* WRNCH_INDIVIDUAL_ACTIVITY_MODEL_CXX_API*/
