/*
  Copyright (c) 2018 Wrnch Inc.
  All rights reserved
 */

#ifndef WRNCH_POSE_ESTIMATOR_OPTIONS_CXX_API
#define WRNCH_POSE_ESTIMATOR_OPTIONS_CXX_API

#include <wrnch/utils.hpp>
#include <wrnch/poseEstimatorOptions.h>

#include <new>
#include <memory>


namespace std
{
template<>
struct default_delete<wrPoseEstimatorOptions>
{
    void operator()(wrPoseEstimatorOptions* c_options) const
    {
        wrPoseEstimatorOptions_Destroy(c_options);
    }
};
}  // namespace std

namespace wrnch
{
class PoseEstimatorOptions
{
  public:
    explicit PoseEstimatorOptions(wrPoseEstimatorOptions* opt)
    : m_impl(opt)
    {
    }

    PoseEstimatorOptions()
    : m_impl(wrPoseEstimatorOptions_Create())
    {
        utils::CheckBadAlloc(m_impl.get());
    }

    PoseEstimatorOptions(PoseEstimatorOptions&&) = default;
    PoseEstimatorOptions& operator=(PoseEstimatorOptions&&) = default;

    PoseEstimatorOptions& SetEstimateMask(bool yesNo)
    {
        wrPoseEstimatorOptions_SetEstimateMask(GetPtr(), yesNo);
        return *this;
    }
    PoseEstimatorOptions& SetEstimate3D(bool yesNo)
    {
        wrPoseEstimatorOptions_SetEstimate3d(GetPtr(), yesNo);
        return *this;
    }
    PoseEstimatorOptions& SetEstimateHands(bool yesNo)
    {
        wrPoseEstimatorOptions_SetEstimateHands(GetPtr(), yesNo);
        return *this;
    }
    PoseEstimatorOptions& SetEstimateAllHandBoxes(bool yesNo)
    {
        wrPoseEstimatorOptions_SetEstimateAllHandBoxes(GetPtr(), yesNo);
        return *this;
    }
    PoseEstimatorOptions& SetUseIK(bool yesNo)
    {
        wrPoseEstimatorOptions_SetUseIK(GetPtr(), yesNo);
        return *this;
    }
    PoseEstimatorOptions& SetMainPersonId(wrMainPersonId mainPersonId)
    {
        wrPoseEstimatorOptions_SetMainPersonId(GetPtr(), mainPersonId);
        return *this;
    }
    PoseEstimatorOptions& SetEnableJointSmoothing(bool yesNo)
    {
        wrPoseEstimatorOptions_SetEnableJointSmoothing(GetPtr(), yesNo);
        return *this;
    }
    PoseEstimatorOptions& SetEnableHeadSmoothing(bool yesNo)
    {
        wrPoseEstimatorOptions_SetEnableHeadSmoothing(GetPtr(), yesNo);
        return *this;
    }
    PoseEstimatorOptions& SetEstimateHead(bool yesNo)
    {
        wrPoseEstimatorOptions_SetEstimateHead(GetPtr(), yesNo);
        return *this;
    }
    PoseEstimatorOptions& SetEstimatePoseFace(bool yesNo)
    {
        wrPoseEstimatorOptions_SetEstimatePoseFace(GetPtr(), yesNo);
        return *this;
    }
    PoseEstimatorOptions& SetEstimateSingle(bool yesNo)
    {
        wrPoseEstimatorOptions_SetEstimateSingle(GetPtr(), yesNo);
        return *this;
    }
    PoseEstimatorOptions& SetRotationMultipleOf90(int rotationMultipleOf90)
    {
        wrPoseEstimatorOptions_SetRotationMultipleOf90(GetPtr(), rotationMultipleOf90);
        return *this;
    }

    bool GetEstimateMask() const { return wrPoseEstimatorOptions_GetEstimateMask(GetPtr()) != 0; }
    bool GetEstimate3D() const { return wrPoseEstimatorOptions_GetEstimate3D(GetPtr()) != 0; }
    bool GetEstimateHands() const { return wrPoseEstimatorOptions_GetEstimateHands(GetPtr()) != 0; }
    bool GetEstimateAllHandBoxes() const
    {
        return wrPoseEstimatorOptions_GetEstimateAllHandBoxes(GetPtr()) != 0;
    }
    bool GetUseIK() const { return wrPoseEstimatorOptions_GetUseIK(GetPtr()) != 0; }
    wrMainPersonId GetMainPersonId() const
    {
        return wrPoseEstimatorOptions_GetMainPersonId(GetPtr());
    }
    bool GetEnableJointSmoothing() const
    {
        return wrPoseEstimatorOptions_GetEnableJointSmoothing(GetPtr()) != 0;
    }
    bool GetEnableHeadSmoothing() const
    {
        return wrPoseEstimatorOptions_GetEnableHeadSmoothing(GetPtr()) != 0;
    }
    bool GetEstimateHead() const { return wrPoseEstimatorOptions_GetEstimateHead(GetPtr()) != 0; }
    bool GetEstimatePoseFace() const
    {
        return wrPoseEstimatorOptions_GetEstimatePoseFace(GetPtr()) != 0;
    }
    bool GetEstimateSingle() const
    {
        return wrPoseEstimatorOptions_GetEstimateSingle(GetPtr()) != 0;
    }
    int GetRotationMultipleOf90() const
    {
        return wrPoseEstimatorOptions_GetRotationMultipleOf90(GetPtr());
    }

    wrPoseEstimatorOptions* Get() { return GetPtr(); }
    wrPoseEstimatorOptions const* Get() const { return GetPtr(); }
    wrPoseEstimatorOptions* GetPtr() { return m_impl.get(); }
    wrPoseEstimatorOptions const* GetPtr() const { return m_impl.get(); }

  private:
    std::unique_ptr<wrPoseEstimatorOptions> m_impl;
};
}

#endif /* WRNCH_POSE_ESTIMATOR_OPTIONS_CXX_API */
