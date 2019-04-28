/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/

#ifndef WRNCH_POSE_TYPES_CXX_API
#define WRNCH_POSE_TYPES_CXX_API

#include <wrnch/utils.hpp>
#include <wrnch/poseTypes.h>

#include <cassert>
#include <memory>
#include <new>

namespace std
{
template<>
struct default_delete<wrSerializedEstimator>
{
    void operator()(wrSerializedEstimator* serializedEstimator) const
    {
        wrSerializedEstimator_Destroy(serializedEstimator);
    }
};
}  // namespace std

namespace wrnch
{
class SerializedEstimator
{
  public:
    explicit SerializedEstimator(wrSerializedEstimator* serializedEstimator)
    : m_impl(serializedEstimator)
    {
        assert(m_impl.get());
    }

    char const* Data() const { return wrSerializedEstimator_Data(m_impl.get()); }

    int NumBytes() const { return wrSerializedEstimator_NumBytes(m_impl.get()); }

  private:
    std::unique_ptr<wrSerializedEstimator> m_impl;
};

template<class PtrType>
class BasicBox2d
{
  public:
    explicit BasicBox2d(PtrType ptr)
    : m_impl(ptr)
    {
        utils::CheckBadAlloc(m_impl);
    }

    float GetMinX() const { return wrBox2d_GetMinX(Get()); }
    float GetMinY() const { return wrBox2d_GetMinY(Get()); }
    float GetWidth() const { return wrBox2d_GetWidth(Get()); }
    float GetHeight() const { return wrBox2d_GetHeight(Get()); }
    typename utils::remove_pointer<PtrType>::type const* Get() const { return m_impl; }

    bool operator==(const BasicBox2d& other) const
    {
        return wrBox2d_Equals(m_impl, other.m_impl) == 1;
    }
    bool operator!=(const BasicBox2d& other) const { return !(*this == other); }

  protected:
    PtrType m_impl;
};

class MutableBox2d : public BasicBox2d<wrBox2d*>
{
  public:
    typedef BasicBox2d<wrBox2d*> Base;

    explicit MutableBox2d(float x = 0.f, float y = 0.f, float width = 1.f, float height = 1.f)
    : Base(wrBox2d_Create(x, y, width, height))
    {
        utils::CheckBadAlloc(Base::Get());
    }

    MutableBox2d(const MutableBox2d& other)
    : Base(wrBox2d_Clone(other.m_impl))
    {
        utils::CheckBadAlloc(this->m_impl);
    }

    MutableBox2d& operator=(const MutableBox2d& rhs)
    {
        wrBox2d_Copy(rhs.m_impl, this->m_impl);
        return *this;
    }
    ~MutableBox2d() { wrBox2d_Destroy(this->m_impl); }

    void Copy(const wrBox2d* other) { wrBox2d_Copy(other, this->m_impl); }

    using Base::Get;
    wrBox2d* Get() { return this->m_impl; }

    bool operator==(const MutableBox2d& other) const { return Base::operator==(other); }
    bool operator!=(const MutableBox2d& other) const { return Base::operator!=(other); }
};

typedef MutableBox2d Box2d;
typedef BasicBox2d<const wrBox2d*> Box2dView;

template<class PtrType>
class BasicHandBoxPair
{
  public:
    BasicHandBoxPair();
    explicit BasicHandBoxPair(PtrType ptr)
    : m_impl(ptr)
    {
        utils::CheckBadAlloc(m_impl);
    }

    int GetId() const { return wrHandBoxPair_GetId(m_impl); }
    Box2dView GetLeft() const { return Box2dView(wrHandBoxPair_GetLeft(m_impl)); }

    Box2dView GetRight() const { return Box2dView(wrHandBoxPair_GetRight(m_impl)); }

    typename utils::remove_pointer<PtrType>::type const* Get() const { return m_impl; }

    bool operator==(const BasicHandBoxPair& other) const
    {
        return wrHandBoxPair_Equals(m_impl, other.m_impl) == 1;
    }
    bool operator!=(const BasicHandBoxPair& other) const { return !(*this == other); }

  protected:
    PtrType m_impl;
};


class MutableHandBoxPair : public BasicHandBoxPair<wrHandBoxPair*>
{
  public:
    typedef BasicHandBoxPair<wrHandBoxPair*> Base;

    MutableHandBoxPair()
    : Base(wrHandBoxPair_Create())
    {
        utils::CheckBadAlloc(Base::Get());
    }

    MutableHandBoxPair(const MutableHandBoxPair& other)
    : Base(wrHandBoxPair_Clone(other.m_impl))
    {
        utils::CheckBadAlloc(this->m_impl);
    }

    MutableHandBoxPair& operator=(const MutableHandBoxPair& rhs)
    {
        wrHandBoxPair_Copy(rhs.m_impl, this->m_impl);
        return *this;
    }
    ~MutableHandBoxPair() { wrHandBoxPair_Destroy(this->m_impl); }

    void Copy(const wrHandBoxPair* other) { wrHandBoxPair_Copy(other, this->m_impl); }

    using Base::Get;
    wrHandBoxPair* Get() { return this->m_impl; }

    bool operator==(const BasicHandBoxPair& other) const { return Base::operator==(other); }
    bool operator!=(const BasicHandBoxPair& other) const { return Base::operator!=(other); }
};

typedef MutableHandBoxPair HandBoxPair;
typedef BasicHandBoxPair<const wrHandBoxPair*> HandBoxPairView;

template<class PtrType>
class BasicPose2d
{
  public:
    BasicPose2d();
    explicit BasicPose2d(PtrType ptr)
    : m_impl(ptr)
    {
        utils::CheckBadAlloc(m_impl);
    }

    int GetId() const { return wrPose2d_GetId(this->m_impl); }
    bool GetIsMain() const { return wrPose2d_GetIsMain(m_impl) != 0; }

    /// @deprecated This function is deprecated. Instead, use JointDefinition::GetNumJoints
    /// @see        JointDefinition::GetNumJoints
    static unsigned int GetNumOutputJoints() { return wrPose2d_GetNumOutputJoints(); }
    const float* GetJoints() const { return wrPose2d_GetJoints(m_impl); }
    const float* GetScores() const { return wrPose2d_GetScores(m_impl); }
    float GetScore() const { return wrPose2d_GetScore(m_impl); }
    Box2dView GetBoundingBox() const { return Box2dView(wrPose2d_GetBoundingBox(m_impl)); }

    typename utils::remove_pointer<PtrType>::type const* Get() const { return m_impl; }

    bool operator==(const BasicPose2d& other) const
    {
        return wrPose2d_Equals(m_impl, other.m_impl) == 1;
    }
    bool operator!=(const BasicPose2d& other) const { return !(*this == other); }

  protected:
    PtrType m_impl;
};

class MutablePose2d : public BasicPose2d<wrPose2d*>
{
  public:
    typedef BasicPose2d<wrPose2d*> Base;

    MutablePose2d()
    : Base(wrPose2d_Create())
    {
        utils::CheckBadAlloc(Base::Get());
    }

    MutablePose2d(const MutablePose2d& other)
    : Base(wrPose2d_Clone(other.m_impl))
    {
        utils::CheckBadAlloc(this->m_impl);
    }

    MutablePose2d& operator=(const MutablePose2d& rhs)
    {
        wrPose2d_Copy(rhs.m_impl, this->m_impl);
        return *this;
    }

    ~MutablePose2d() { wrPose2d_Destroy(this->m_impl); }

    void SetId(int id) { wrPose2d_SetId(this->m_impl, id); }
    void Copy(const wrPose2d* other) { wrPose2d_Copy(other, this->m_impl); }

    using Base::GetScores;

    using Base::GetJoints;
    float* GetJoints() { return wrPose2d_GetJointsMutable(this->m_impl); }

    using Base::Get;
    wrPose2d* Get() { return this->m_impl; }

    bool operator==(const MutablePose2d& other) const { return Base::operator==(other); }
    bool operator!=(const MutablePose2d& other) const { return Base::operator!=(other); }
};

typedef MutablePose2d Pose2d;
typedef BasicPose2d<const wrPose2d*> Pose2dView;

class Box3dView
{
  public:
    Box3dView(const wrBox3d* ptr)
    : m_impl(ptr)
    {
        utils::Check(ptr != NULL, "Cannot initialize a Box3d with a null pointer");
    }

    float GetMinX() const { return wrBox3d_GetMinX(Get()); }
    float GetMinY() const { return wrBox3d_GetMinY(Get()); }
    float GetMinZ() const { return wrBox3d_GetMinZ(Get()); }
    float GetWidth() const { return wrBox3d_GetWidth(Get()); }
    float GetHeight() const { return wrBox3d_GetHeight(Get()); }
    float GetDepth() const { return wrBox3d_GetDepth(Get()); }
    const wrBox3d* Get() const { return m_impl; }

    bool operator==(const Box3dView& other) const { return wrBox3d_Equals(m_impl, other.m_impl) != 0; }
    bool operator!=(const Box3dView& other) const { return !(*this == other); }

  private:
    const wrBox3d* m_impl;
};

template<class PtrType>
class BasicPose3d
{
  public:
    BasicPose3d();
    explicit BasicPose3d(PtrType ptr)
    : m_impl(ptr)
    {
        utils::CheckBadAlloc(m_impl);
    }

    int GetId() const { return wrPose3d_GetId(m_impl); }

    /// @deprecated This function is deprecated. Instead, use JointDefinition::GetNumJoints
    /// @see        JointDefinition::GetNumJoints
    static unsigned int GetNumOutputJoints() { return wrPose3d_GetNumOutputJoints(); }

    const float* GetPositions() const { return wrPose3d_GetPositions(m_impl); }
    const float* GetRotations() const { return wrPose3d_GetRotations(m_impl); }

    static unsigned int GetScaleHintLength() { return wrPose3d_GetScaleHintLength(); }
    const float* GetScaleHint() const { return wrPose3d_GetScaleHint(m_impl); }

    typename utils::remove_pointer<PtrType>::type const* Get() const { return m_impl; }

    bool operator==(const BasicPose3d& other) const
    {
        return wrPose3d_Equals(m_impl, other.m_impl) == 1;
    }
    bool operator!=(const BasicPose3d& other) const { return !(*this == other); }

  protected:
    PtrType m_impl;
};

class MutablePose3d : public BasicPose3d<wrPose3d*>
{
  public:
    typedef BasicPose3d<wrPose3d*> Base;

    MutablePose3d()
    : Base(wrPose3d_Create())
    {
        utils::CheckBadAlloc(Base::Get());
    }

    MutablePose3d(const MutablePose3d& other)
    : Base(wrPose3d_Clone(other.m_impl))
    {
        utils::CheckBadAlloc(this->m_impl);
    }

    //Clone from Pose3dView
    MutablePose3d(const BasicPose3d<const wrPose3d*>& other)
    : Base(wrPose3d_Clone(other.Get()))
    {
        utils::CheckBadAlloc(this->m_impl);
    }

    MutablePose3d& operator=(const MutablePose3d& rhs)
    {
        wrPose3d_Copy(rhs.m_impl, this->m_impl);
        return *this;
    }
    ~MutablePose3d() { wrPose3d_Destroy(this->m_impl); }

    void SetId(int id) { wrPose3d_SetId(this->m_impl, id); }
    void Copy(const wrPose3d* other) { wrPose3d_Copy(other, this->m_impl); }

    using Base::GetPositions;
    float* GetPositions() { return wrPose3d_GetPositionsMutable(this->m_impl); }

    using Base::GetRotations;
    float* GetRotations() { return wrPose3d_GetRotationsMutable(this->m_impl); }

    using Base::GetScaleHint;
    float* GetScaleHint() { return wrPose3d_GetScaleHintMutable(this->m_impl); }

    using Base::Get;
    wrPose3d* Get() { return this->m_impl; }

    bool operator==(const MutablePose3d& other) const { return Base::operator==(other); }
    bool operator!=(const MutablePose3d& other) const { return Base::operator!=(other); }
};

typedef MutablePose3d Pose3d;
typedef BasicPose3d<const wrPose3d*> Pose3dView;

class ArrowView
{
  public:
    ArrowView(const wrArrow* ptr)
    : m_impl(ptr)
    {
        utils::Check(m_impl != NULL, "Cannot initialize a Arrow with a null pointer");
    }

    float GetTipX() const { return wrArrow_GetTipX(Get()); }
    float GetTipY() const { return wrArrow_GetTipY(Get()); }
    float GetBaseX() const { return wrArrow_GetBaseX(Get()); }
    float GetBaseY() const { return wrArrow_GetBaseY(Get()); }
    const wrArrow* Get() const { return m_impl; }

  private:
    const wrArrow* m_impl;
};


template<class PtrType>
class BasicPoseHead
{
  public:
    BasicPoseHead();
    explicit BasicPoseHead(PtrType ptr)
    : m_impl(ptr)
    {
        utils::CheckBadAlloc(m_impl);
    }

    int GetId() const { return wrPoseHead_GetId(m_impl); }
    bool GetEstimationSuccess() const { return wrPoseHead_GetEstimationSuccess(m_impl) != 0; }
    static unsigned int GetHeadRotationLength() { return wrPoseHead_GetHeadRotationLength(); }
    const float* GetHeadRotation() const { return wrPoseHead_GetHeadRotation(m_impl); }
    Box3dView GetFaceBoundingBox() const
    {
        return Box3dView(wrPoseHead_GetFaceBoundingBox(m_impl));
    }

    typename utils::remove_pointer<PtrType>::type const* Get() const { return m_impl; }

    bool operator==(const BasicPoseHead& other) const
    {
        return wrPoseHead_Equals(m_impl, other.m_impl) == 1;
    }
    bool operator!=(const BasicPoseHead& other) const { return !(*this == other); }

  protected:
    PtrType m_impl;
};

class MutablePoseHead : public BasicPoseHead<wrPoseHead*>
{
  public:
    typedef BasicPoseHead<wrPoseHead*> Base;

    MutablePoseHead()
    : Base(wrPoseHead_Create())
    {
        utils::CheckBadAlloc(Base::Get());
    }

    MutablePoseHead(const MutablePoseHead& other)
    : Base(wrPoseHead_Clone(other.Get()))
    {
        utils::CheckBadAlloc(this->m_impl);
    }

    MutablePoseHead& operator=(const MutablePoseHead& rhs)
    {
        wrPoseHead_Copy(rhs.Get(), this->m_impl);
        return *this;
    }
    ~MutablePoseHead() { wrPoseHead_Destroy(this->m_impl); }

    void Copy(const wrPoseHead* other) { wrPoseHead_Copy(other, this->m_impl); }

    using Base::Get;
    wrPoseHead* Get() { return this->m_impl; }

    bool operator==(const MutablePoseHead& other) const { return Base::operator==(other); }
    bool operator!=(const MutablePoseHead& other) const { return Base::operator!=(other); }
};

typedef MutablePoseHead PoseHead;
typedef BasicPoseHead<const wrPoseHead*> PoseHeadView;

template<class PtrType>
class BasicPoseFace
{
  public:
    BasicPoseFace();
    BasicPoseFace(PtrType other)
    : m_impl(other)
    {
        utils::CheckBadAlloc(m_impl);
    }

    int GetId() const { return wrPoseFace_GetId(m_impl); }

    unsigned int GetNumLandmarks() const { return wrPoseFace_GetNumLandmarks(m_impl); }
    const float* GetLandmarks() const { return wrPoseFace_GetLandmarks(m_impl); }
    ArrowView GetFaceArrow() const { return ArrowView(wrPoseFace_GetFaceArrow(m_impl)); }

    typename utils::remove_pointer<PtrType>::type const* Get() const { return this->m_impl; }

    bool operator==(const BasicPoseFace& other) const
    {
        return wrPoseFace_Equals(m_impl, other.m_impl) == 1;
    }
    bool operator!=(const BasicPoseFace& other) const { return !(*this == other); }

    Box2dView GetBoundingBox() const { return Box2dView(wrPoseFace_GetBoundingBox(m_impl)); }

  protected:
    PtrType m_impl;
};

class MutablePoseFace : public BasicPoseFace<wrPoseFace*>
{
  public:
    typedef BasicPoseFace<wrPoseFace*> Base;

    MutablePoseFace()
    : Base(wrPoseFace_Create())
    {
        utils::CheckBadAlloc(Base::Get());
    }

    MutablePoseFace(const MutablePoseFace& other)
    : Base(wrPoseFace_Clone(other.Get()))
    {
        utils::CheckBadAlloc(this->m_impl);
    }

    MutablePoseFace& operator=(const MutablePoseFace& rhs)
    {
        wrPoseFace_Copy(rhs.Get(), this->m_impl);
        return *this;
    }
    ~MutablePoseFace() { wrPoseFace_Destroy(this->m_impl); }

    void Copy(const wrPoseFace* other) { wrPoseFace_Copy(other, this->m_impl); }

    using Base::GetLandmarks;
    float* GetLandmarks() { return wrPoseFace_GetLandmarksMutable(this->m_impl); }

    using Base::Get;
    wrPoseFace* Get() { return this->m_impl; }

    bool operator==(const MutablePoseFace& other) const { return Base::operator==(other); }
    bool operator!=(const MutablePoseFace& other) const { return Base::operator!=(other); }
};

typedef MutablePoseFace PoseFace;
typedef BasicPoseFace<const wrPoseFace*> PoseFaceView;
}
#endif /* WRNCH_POSE_TYPES_CXX_API */
