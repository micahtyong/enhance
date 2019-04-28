/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/

#ifndef WRNCH_wrPoseIK_CXX_API
#define WRNCH_wrPoseIK_CXX_API

#include <wrnch/poseIK.h>
#include <wrnch/poseTypes.hpp>
#include <wrnch/jointDefinition.hpp>
#include <wrnch/poseParams.hpp>
#include <wrnch/IKProperties.h>


namespace std
{
template<>
struct default_delete<wrPoseIK>
{
    void operator()(wrPoseIK* c_poseIK) const { wrPoseIK_Destroy(c_poseIK); }
};
}  // namespace std

namespace wrnch
{
////////////////// Experimental IK Solver //////////////////
////////////////// For advanced users only //////////////////

/// @brief PoseIK allows to control a rig using 3d joints as effectors.
///        The solver internally uses the following referential: Y up, Z forward, X left.
///        All input coordinates needs to be converted to the right referential before calling
///        the Solve function. The output format is always formated with the extended joint
///        definition, and contains position and rotation informations in the same referential
///        as the input data. Positions will be returned scaled to the initial T pose specified
///        at initialization. Rotations are returned as quaternions for each joint, in world
///        space.
class PoseIK
{
  public:
    PoseIK(PoseIK&& ikSolver) = default;

    explicit PoseIK(wrPoseIKHandle ikSolverHandle)
    : m_impl(ikSolverHandle)
    {
    }

    /// @brief Creates a PoseIK solver using default internal node positions.
    /// @param inputFormat The input format used when feeding positions to the solver.
    explicit PoseIK(const JointDefinition& inputFormat)
    {
        wrPoseIKHandle handle;
        wrReturnCode code = wrPoseIK_CreateDefault(&handle, inputFormat.Get());
        ExceptionHandler(code);
        m_impl = std::unique_ptr<wrPoseIK>(handle);
    }

    /// @brief Creates a PoseIK solver using provided node positions.
    /// @param inputFormat The input format used when feeding positions to the solver
    /// @param initialPose The initial pose used to initiallize the internal IK Solver in a pose3d
    ///        handle. This pose must follow the extended joints definition composed of 30 joints
    ///        and represent a T posed character in the IK solver referential (Y up, Z forward, X
    ///        left).
    PoseIK(const JointDefinition& inputFormat, Pose3dView initialPose)
    {
        wrPoseIKHandle handle;
        wrReturnCode code = wrPoseIK_CreateFromPose(&handle, inputFormat.Get(), initialPose.Get());
        ExceptionHandler(code);
        m_impl = std::unique_ptr<wrPoseIK>(handle);
    }

    /// @brief Creates a PoseIK solver using provided node positions.
    /// @param inputFormat The input format used when feeding positions to the solver
    /// @param initialPose The initial pose used to initiallize the internal IK Solver.
    ///        This pose must follow the extended joints definition composed of 30 joints
    ///        and represent a T posed character in the IK solver referential (Y up, Z forward, X
    ///        left).
    /// @param numJoints of joints contained in the provided initial pose. Should be the number of
    ///        joints present in the extended joint definition.
    PoseIK(const JointDefinition& inputFormat, const float* initialPose, unsigned int numJoints)
    {
        wrPoseIKHandle handle;
        wrReturnCode code = wrPoseIK_Create(&handle, inputFormat.Get(), initialPose, numJoints);
        ExceptionHandler(code);
        m_impl = std::unique_ptr<wrPoseIK>(handle);
    }

    /// @brief Performs a solving step using the provided 3d positions as effectors.
    ///        The result will be returned in a pose3d containing positions and rotations for each
    ///        joint in the extended joint definition. Rotations are represented here as normalized
    ///        quaternions in world space. Each rotation is independant of its parent node and is
    ///        expressed with respect to the initial TPose (eg. the final rotation of your object
    ///        should be Rotation = Q * Qtpose.conjugate()) Positions will be solved with respect to
    ///        the scale of the initial T posed character, and an average scaling factor can be
    ///        found in the ScaleHint field of the pose3d object. Values are returned in the
    ///        internal IK Solver referential (Y up, Z forward, X left).
    /// @param pose 3d positions of the input effectors. The input positions needs to match the
    ///        input format specified at initialization. The input positions must be expressed in
    ///        the internal solver referential (Y up, Z Forward, X left).
    /// @param visibilities Represents the visibility of each effector in the input pose. Those
    ///        joints will be ignored when performing the solving step. 0 represents a non visible
    ///        joint, 1 represents a visible joint.
    /// @param params Input parameters to perform the solving step.
    /// @see IKParams
    /// @see Pose3d
    Pose3dView Solve(const float* pose, const int* visibilities, const IKParams& params)
    {
        return Pose3dView(wrPoseIK_Solve(m_impl.get(), pose, visibilities, params.Get()));
    }
    Pose3dView Solve(const Pose3d& pose, const int* visibilities, const IKParams& params)
    {
        return Pose3dView(
            wrPoseIK_Solve(m_impl.get(), pose.GetPositions(), visibilities, params.Get()));
    }


    /// @brief Resets the internal state of the IK Solver.
    void Reset() { wrPoseIK_ResetDefault(m_impl.get()); }

    /// @param initialPose initialPose The initial pose used to initiallize the internal IK Solver.
    ///        This pose must follow the extended joints definition composed of 30 joints
    ///        and represent a T posed character in the IK solver referential (Y up, Z forward, X
    ///        left).
    /// @param numJoints number of joints present in initialPose
    void Reset(const float* initialPose, int numJoints)
    {
        wrPoseIK_Reset(m_impl.get(), initialPose, numJoints);
    }
    void Reset(wrPose3dHandleConst initialPose)
    {
        wrPoseIK_ResetFromPose(m_impl.get(), initialPose);
    }

    float GetIKProperty(wrIKProperty property) const
    {
        return wrPoseIK_GetIKProperty(m_impl.get(), property);
    }
    void SetIKProperty(wrIKProperty property, float value)
    {
        wrPoseIK_SetIKProperty(m_impl.get(), property, value);
    }

    JointDefinition GetOutputFormat() const
    {
        return JointDefinition(wrPoseIK_GetOutputFormat(m_impl.get()));
    }

    JointDefinition GetInputFormat() const
    {
        return JointDefinition(wrPoseIK_GetInputFormat(m_impl.get()));
    }

    /// @brief Get the initial TPose specified in the solver. The T pose will be returned as a
    ///        Pose3dView, containing positions only. We assume unit quaternions when in TPose.
    Pose3dView GetTPose() const { return Pose3dView(wrPoseIK_GetTPose(m_impl.get())); }

    wrPoseIKHandle Get() const { return m_impl.get(); }

  private:
    PoseIK();

    std::unique_ptr<wrPoseIK> m_impl;

    void ExceptionHandler(wrReturnCode code) const { ExceptionHandler(code, ""); }
    void ExceptionHandler(wrReturnCode code, const char* msg) const
    {
        ExceptionHandlerStatic(code, msg, Get());
    }
    static void ExceptionHandlerStatic(wrReturnCode code, wrPoseIK const* c_poseIK)
    {
        ExceptionHandlerStatic(code, "", c_poseIK);
    }
    static void ExceptionHandlerStatic(wrReturnCode code, const char* msg, wrPoseIK const* c_poseIK)
    {
        switch (code)
        {
            case wrReturnCode_OK:
                break;
            case wrReturnCode_BAD_ALLOC:
                utils::CheckBadAlloc(c_poseIK);
                break;
            default:
                throw utils::Exception(code, msg);
        }
    }
};
}

#endif /* WRNCH_wrPoseIK_CXX_API */
