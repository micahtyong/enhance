/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/

#ifndef WRNCH_POSE_PARAMS_CXX_API
#define WRNCH_POSE_PARAMS_CXX_API

#include <wrnch/utils.hpp>
#include <wrnch/poseTypes.hpp>
#include <wrnch/poseParams.h>

#include <new>

namespace wrnch
{
namespace detail
{
template<class PtrType>
class BasicPoseParams
{
  public:
    BasicPoseParams(PtrType ptr)
    : m_impl(ptr)
    {
        utils::CheckBadAlloc(m_impl);
    }

    wrSensitivity GetBoneSensitivity() const { return wrPoseParams_GetBoneSensitivity(m_impl); }
    wrSensitivity GetJointSensitivity() const { return wrPoseParams_GetJointSensitivity(m_impl); }
    wrNetPrecision GetNetPrecision2d() const { return wrPoseParams_GetNetPrecision2d(m_impl); }
    wrNetPrecision GetNetPrecision3d() const { return wrPoseParams_GetNetPrecision3d(m_impl); }
    bool GetEnableTracking() const { return wrPoseParams_GetEnableTracking(m_impl) != 0; }
    int GetPreferredNetWidth2d() const { return wrPoseParams_GetPreferredNetWidth2d(m_impl); }
    int GetPreferredNetHeight2d() const { return wrPoseParams_GetPreferredNetHeight2d(m_impl); }
    float GetSmoothingBetaX() const { return wrPoseParams_GetSmoothingBetaX(m_impl); }
    float GetSmoothingBetaY() const { return wrPoseParams_GetSmoothingBetaY(m_impl); }
    float GetSmoothingBetaZ() const { return wrPoseParams_GetSmoothingBetaZ(m_impl); }

    float GetSmoothingCutoffFreqVelocity() const
    {
        return wrPoseParams_GetSmoothingCutoffFreqVelocity(m_impl);
    }

    float GetSmoothingMinCutoffFreqPosition() const
    {
        return wrPoseParams_GetSmoothingMinCutoffFreqPosition(m_impl);
    }

    int GetMinValidJoints() const { return wrPoseParams_GetMinValidJoints(m_impl); }

    bool operator==(const BasicPoseParams& r) const
    {
        return wrPoseParams_CheckEquivalent(m_impl, r.Get());
    }

    typename utils::remove_pointer<PtrType>::type const* Get() const { return m_impl; }

  protected:
    PtrType m_impl;
};

template<class PtrType>
class BasicIKParams
{
  public:
    BasicIKParams(PtrType ptr)
    : m_impl(ptr)
    {
        utils::CheckBadAlloc(m_impl);
    }

    float GetTransReach() const { return wrIKParams_GetTransReach(m_impl); }
    float GetRotReach() const { return wrIKParams_GetRotReach(m_impl); }
    float GetPull() const { return wrIKParams_GetPull(m_impl); }
    float GetResist() const { return wrIKParams_GetResist(m_impl); }
    float GetMaxAngularVelocity() const { return wrIKParams_GetMaxAngularVelocity(m_impl); }
    float GetFPS() const { return wrIKParams_GetFPS(m_impl); }
    float GetJointVisibilityThresh() const { return wrIKParams_GetJointVisibilityThresh(m_impl); }

    bool operator==(const BasicIKParams& r) const
    {
        return wrIKParams_CheckEquivalent(m_impl, r.Get());
    }

    typename utils::remove_pointer<PtrType>::type const* Get() const { return m_impl; }

  protected:
    PtrType m_impl;
};
}

class MutablePoseParams : public detail::BasicPoseParams<wrPoseParams*>
{
  public:
    typedef detail::BasicPoseParams<wrPoseParams*> Base;

    MutablePoseParams()
    : Base(wrPoseParams_Create())
    {
        utils::CheckBadAlloc(m_impl);
    }
    MutablePoseParams(const MutablePoseParams& other)
    : Base(wrPoseParams_Clone(other.m_impl))
    {
        utils::CheckBadAlloc(m_impl);
    }

    MutablePoseParams& operator=(const MutablePoseParams& rhs)
    {
        wrPoseParams_Copy(rhs.m_impl, m_impl);
        return *this;
    }

    static MutablePoseParams TakeOwnershipOf(wrPoseParams* params)
    {
        MutablePoseParams result(params);
        return result;
    }

    ~MutablePoseParams() { wrPoseParams_Destroy(m_impl); }

    void SetBoneSensitivity(wrSensitivity sensitivity)
    {
        wrPoseParams_SetBoneSensitivity(m_impl, sensitivity);
    }
    void SetJointSensitivity(wrSensitivity sensitivity)
    {
        wrPoseParams_SetJointSensitivity(m_impl, sensitivity);
    }
    void SetNetPrecision2d(wrNetPrecision precision)
    {
        wrPoseParams_SetNetPrecision2d(m_impl, precision);
    }
    void SetNetPrecision3d(wrNetPrecision precision)
    {
        wrPoseParams_SetNetPrecision3d(m_impl, precision);
    }
    void SetEnableTracking(bool yesNo) { wrPoseParams_SetEnableTracking(m_impl, yesNo); }
    void SetPreferredNetWidth2d(int width) { wrPoseParams_SetPreferredNetWidth2d(m_impl, width); }
    void SetPreferredNetHeight2d(int height)
    {
        wrPoseParams_SetPreferredNetHeight2d(m_impl, height);
    }
    void SetSmoothingBetaX(float beta) { wrPoseParams_SetSmoothingBetaX(m_impl, beta); }
    void SetSmoothingBetaY(float beta) { wrPoseParams_SetSmoothingBetaY(m_impl, beta); }
    void SetSmoothingBetaZ(float beta) { wrPoseParams_SetSmoothingBetaZ(m_impl, beta); }

    void SetSmoothingCutoffFreqVelocity(float cutoffFreq)
    {
        wrPoseParams_SetSmoothingCutoffFreqVelocity(m_impl, cutoffFreq);
    }
    void SetSmoothingMinCutoffFreqPosition(float cutoffFreq)
    {
        wrPoseParams_SetSmoothingMinCutoffFreqPosition(m_impl, cutoffFreq);
    }

    void SetMinValidJoints(int minJoints) { wrPoseParams_SetMinValidJoints(m_impl, minJoints); }

    using Base::Get;
    wrPoseParams* Get() { return this->m_impl; }

  private:
    MutablePoseParams(wrPoseParams* params)
    : Base(params)
    {
    }
};

typedef MutablePoseParams PoseParams;
typedef detail::BasicPoseParams<const wrPoseParams*> PoseParamsView;

class MutableIKParams : public detail::BasicIKParams<wrIKParams*>
{
  public:
    typedef detail::BasicIKParams<wrIKParams*> Base;

    MutableIKParams()
    : Base(wrIKParams_Create())
    {
        utils::CheckBadAlloc(m_impl);
    }
    MutableIKParams(const MutableIKParams& other)
    : Base(wrIKParams_Clone(other.m_impl))
    {
        utils::CheckBadAlloc(m_impl);
    }

    MutableIKParams& operator=(const MutableIKParams& rhs)
    {
        wrIKParams_Copy(rhs.m_impl, m_impl);
        return *this;
    }

    static MutableIKParams TakeOwnershipOf(wrIKParams* params)
    {
        MutableIKParams result(params);
        return result;
    }

    ~MutableIKParams() { wrIKParams_Destroy(m_impl); }

    void SetTransReach(float reach) { wrIKParams_SetTransReach(m_impl, reach); }
    void SetRotReach(float reach) { wrIKParams_SetRotReach(m_impl, reach); }
    void SetPull(float pull) { wrIKParams_SetPull(m_impl, pull); }
    void SetResist(float resist) { wrIKParams_SetResist(m_impl, resist); }
    void SetMaxAngularVelocity(float velocity)
    {
        wrIKParams_SetMaxAngularVelocity(m_impl, velocity);
    }
    void SetFPS(float fps) { wrIKParams_SetFPS(m_impl, fps); }
    void SetJointVisibilityThresh(float thresh)
    {
        wrIKParams_SetJointVisibilityThresh(m_impl, thresh);
    }

    using Base::Get;
    wrIKParams* Get() { return this->m_impl; }

  private:
    MutableIKParams(wrIKParams* params)
    : Base(params)
    {
    }
};

typedef MutableIKParams IKParams;
typedef detail::BasicIKParams<const wrIKParams*> IKParamsView;
}  // namespace wrnch

#endif /* WRNCH_POSE_PARAMS_CXX_API */
