/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/

#ifndef WRNCH_POSE_TYPE_TRAITS_CXX_API
#define WRNCH_POSE_TYPE_TRAITS_CXX_API

#include <wrnch/poseTypes.hpp>

namespace wrnch
{
template<class PoseType>
struct PoseTypeTraits;


template<>
struct PoseTypeTraits<Box2dView>
{
    typedef MutableBox2d MutableType;
    typedef Box2dView ViewType;
};

template<>
struct PoseTypeTraits<MutableBox2d>
{
    typedef MutableBox2d MutableType;
    typedef Box2dView ViewType;
};

template<>
struct PoseTypeTraits<HandBoxPair>
{
    typedef HandBoxPair MutableType;
    typedef HandBoxPairView ViewType;
};

template<>
struct PoseTypeTraits<HandBoxPairView>
{
    typedef HandBoxPair MutableType;
    typedef HandBoxPairView ViewType;
};

template<>
struct PoseTypeTraits<Pose2d>
{
    typedef Pose2d MutableType;
    typedef Pose2dView ViewType;
};

template<>
struct PoseTypeTraits<Pose2dView>
{
    typedef Pose2d MutableType;
    typedef Pose2dView ViewType;
};

template<>
struct PoseTypeTraits<Box3dView>
{
    typedef Box3dView ViewType;
};

template<>
struct PoseTypeTraits<Pose3d>
{
    typedef Pose3d MutableType;
    typedef Pose3dView ViewType;
};

template<>
struct PoseTypeTraits<Pose3dView>
{
    typedef Pose3d MutableType;
    typedef Pose3dView ViewType;
};

template<>
struct PoseTypeTraits<PoseHead>
{
    typedef PoseHead MutableType;
    typedef PoseHeadView ViewType;
};

template<>
struct PoseTypeTraits<PoseHeadView>
{
    typedef PoseHead MutableType;
    typedef PoseHeadView ViewType;
};

template<>
struct PoseTypeTraits<PoseFace>
{
    typedef PoseFace MutableType;
    typedef PoseFaceView ViewType;
};

template<>
struct PoseTypeTraits<PoseFaceView>
{
    typedef PoseFace MutableType;
    typedef PoseFaceView ViewType;
};
}

#endif /* WRNCH_POSE_TYPE_TRAITS_CXX_API */
