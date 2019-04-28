/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/

#ifndef WRNCH_ACTIVITY_POSE_ESTIMATOR_REQUIREMENTS_CXX_API
#define WRNCH_ACTIVITY_POSE_ESTIMATOR_REQUIREMENTS_CXX_API

#include <wrnch/activityPoseEstimatorRequirements.h>

/// @file activityPoseEstimatorRequirements.hpp

namespace wrnch
{
/// @brief ActivityPoseEstimatorRequirementsView
///         Provides a C++ wrapper to the C-struct `wrPoseEstimatorRequirements` (of incomplete
///         type) and the free functions acting on it.
/// @see activityPoseEstimatorRequirements.h
class ActivityPoseEstimatorRequirementsView
{
  public:
    explicit ActivityPoseEstimatorRequirementsView(wrPoseEstimatorRequirements const* ptr)
    : m_ptr(ptr)
    {
    }

    /// @brief Return true if hands are required, false otherwise.
    bool RequiresHands() const;

    /// @brief Return the "preferred" joint format to be used in a pose estimator.
    JointDefinition PreferredOutputFormat() const;

    /// @brief Attempt to create a minimal PoseEstimator compatible which is compatible with
    ///         `*this`. Throws an exception if a poseEstimator cannot be created.
    /// @param poseModelDir the name of the directory holding the wrnch pose models.
    /// @param deviceId the GPU device id on which the pose estimator should be created.
    /// @param desiredNetWidth the desired "network width" of the pose estimator
    /// @param desiredNetHeight the desired "network height" of the pose estimator
    PoseEstimator CreateCompatibleEstimator(std::string const& poseModelDir,
                                            int deviceId,
                                            int desiredNetWidth,
                                            int desiredNetHeight);

    /// @brief Attempt to create a minimal PoseEstimator compatible which is compatible with
    ///         `*this` in a nothrow manner. If no pose estimator can be created, the returned
    ///         value is empty (ie, compares equal to `nullptr` under `operator==`), and something
    ///         other than `wrReturnCode_OK` is written to `outcode`.
    /// @param poseModelDir the name of the directory holding the wrnch pose models.
    /// @param deviceId the GPU device id on which the pose estimator should be created.
    /// @param desiredNetWidth the desired "network width" of the pose estimator
    /// @param desiredNetHeight the desired "network height" of the pose estimator
    /// @param outcode
    PoseEstimator CreateCompatibleEstimator(std::string const& poseModelDir,
                                            int deviceId,
                                            int desiredNetWidth,
                                            int desiredNetHeight,
                                            wrReturnCode& outcode);

    /// @brief Create minimal PoseEstimatorOptions which are compatible with requirements
    PoseEstimatorOptions CreateCompatibleOptions() const;

    /// @brief Return `true` if poseEstimator is compatible with `*this`, else return `false`.
    /// @param poseEstimator an instance of `PoseEstimator`, `PoseEstimatorConstView`, or
    /// `PoseEstimatorView`
    template<class PoseEstimator_t>
    bool IsCompatible(PoseEstimator_t const& poseEstimator) const;

    /// @brief Return `true` if `options` is compatible with `*this`, else return `false`.
    /// @param options an instance of `PoseEstimator`, `PoseEstimatorConstView`, or
    /// `PoseEstimatorView`
    bool IsCompatible(PoseEstimatorOptions const& options) const;

    wrPoseEstimatorRequirements const* GetPtr() const;
    wrPoseEstimatorRequirements const* Get() const;

  private:
    wrPoseEstimatorRequirements const* const m_ptr;
};

inline bool ActivityPoseEstimatorRequirementsView::RequiresHands() const
{
    return wrPoseEstimatorRequirements_RequiresHands(GetPtr()) != 0;
}

inline wrPoseEstimatorRequirements const* ActivityPoseEstimatorRequirementsView::GetPtr() const
{
    return m_ptr;
}

inline wrPoseEstimatorRequirements const* ActivityPoseEstimatorRequirementsView::Get() const
{
    return m_ptr;
}

inline JointDefinition ActivityPoseEstimatorRequirementsView::PreferredOutputFormat() const
{
    return JointDefinition(wrPoseEstimatorRequirements_PreferredOutputFormat(GetPtr()));
}

inline PoseEstimator ActivityPoseEstimatorRequirementsView::CreateCompatibleEstimator(
    std::string const& poseModelDir,
    int const deviceId,
    int const desiredNetWidth,
    int const desiredNetHeight)
{
    wrReturnCode retcode;

    PoseEstimator res = CreateCompatibleEstimator(
        poseModelDir, deviceId, desiredNetWidth, desiredNetHeight, retcode);

    if (retcode != wrReturnCode_OK)
    {
        throw utils::Exception(retcode);
    }

    return res;
}

inline PoseEstimator ActivityPoseEstimatorRequirementsView::CreateCompatibleEstimator(
    std::string const& poseModelDir,
    int const deviceId,
    int const desiredNetWidth,
    int const desiredNetHeight,
    wrReturnCode& outcode)
{
    wrPoseEstimator* cPoseEstimator{ nullptr };
    outcode = wrPoseEstimatorRequirements_CreateCompatibleEstimator(GetPtr(),
                                                                    &cPoseEstimator,
                                                                    poseModelDir.c_str(),
                                                                    deviceId,
                                                                    desiredNetWidth,
                                                                    desiredNetHeight);
    return PoseEstimator{ cPoseEstimator };
}

inline PoseEstimatorOptions ActivityPoseEstimatorRequirementsView::CreateCompatibleOptions() const
{
    return PoseEstimatorOptions{ wrPoseEstimatorRequirements_CreateCompatibleOptions(GetPtr()) };
}

template<class PoseEstimator_t>
bool ActivityPoseEstimatorRequirementsView::IsCompatible(PoseEstimator_t const& poseEstimator) const
{
    return wrPoseEstimatorRequirements_IsEstimatorCompatible(GetPtr(), poseEstimator.GetPtr()) != 0;
}

inline bool ActivityPoseEstimatorRequirementsView::IsCompatible(
    PoseEstimatorOptions const& options) const
{
    return wrPoseEstimatorRequirements_AreOptionsCompatible(GetPtr(), options.GetPtr());
}

}  // namespace wrnch

#endif /*WRNCH_ACTIVITY_POSE_ESTIMATOR_REQUIREMENTS_CXX_API*/
