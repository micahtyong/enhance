/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/

#ifndef WRNCH_WRPOSEIK_C_API
#define WRNCH_WRPOSEIK_C_API

#include <wrnch/poseTypes.h>
#include <wrnch/poseParams.h>
#include <wrnch/jointDefinition.h>
#include <wrnch/returnCodes.h>
#include <wrnch/definitions.h>
#include <wrnch/IKProperties.h>

#ifdef __cplusplus
extern "C" {
#endif

////////////////// Experimental IK Solver //////////////////
////////////////// For advanced users only //////////////////

struct wrPoseIK;
typedef struct wrPoseIK* wrPoseIKHandle;
typedef const struct wrPoseIK* wrPoseIKHandleConst;


/// @brief Creates a PoseIK solver using default internal node positions.
/// @param handle Handle to the PoseIK object
/// @param inputFormat The input format used when feeding positions to the solver.
WRNCH_DLL_INTERFACE wrReturnCode wrPoseIK_CreateDefault(wrPoseIKHandle* handle,
                                                        wrJointDefinitionHandleConst inputFormat);

/// @brief Creates a PoseIK solver using provided node positions.
/// @param handle Handle to the PoseIK object
/// @param inputFormat The input format used when feeding positions to the solver
/// @param initialPose The initial pose used to initiallize the internal IK Solver.
///        This pose must follow the extended joints definition composed of 30 joints
///        and represent a T posed character in the IK solver referential (Y up, Z forward, X
///        left).
/// @param numJoints of joints contained in the provided initial pose. Should be the number of
/// joints present in the extended joint definition.
WRNCH_DLL_INTERFACE wrReturnCode wrPoseIK_Create(wrPoseIKHandle* handle,
                                                 wrJointDefinitionHandleConst inputFormat,
                                                 const float* initialPose,
                                                 unsigned int numJoints);


/// @brief Creates a PoseIK solver using provided node positions.
/// @param handle Handle to the PoseIK object
/// @param inputFormat The input format used when feeding positions to the solver
/// @param initialPose The initial pose used to initiallize the internal IK Solver in a pose3d
///        handle. This pose must follow the extended joints definition composed of 30 joints
///        and represent a T posed character in the IK solver referential (Y up, Z forward, X
///        left).
WRNCH_DLL_INTERFACE wrReturnCode wrPoseIK_CreateFromPose(wrPoseIKHandle* handle,
                                                         wrJointDefinitionHandleConst inputFormat,
                                                         wrPose3dHandleConst initialPose);

/// @brief Resets the internal state of the IK Solver.
/// @param handle Handle to the solver you want to reset.
WRNCH_DLL_INTERFACE void wrPoseIK_ResetDefault(wrPoseIKHandle handle);

/// @brief Resets the internal state of the IK Solver with a new initial T pose.
/// @param handle the handle to the IK solver you want to reset.
/// @param initialPose initialPose The initial pose used to initiallize the internal IK Solver.
///        This pose must follow the extended joints definition composed of 30 joints
///        and represent a T posed character in the IK solver referential (Y up, Z forward, X
///        left).
/// @param numJoints number of joints present in initialPose
WRNCH_DLL_INTERFACE void wrPoseIK_Reset(wrPoseIKHandle handle,
                                        const float* initialPose,
                                        int numJoints);


/// @brief Resets the internal state of the IK Solver with a new initial T pose.
/// @param handle the handle to the IK solver you want to reset.
/// @param initialPose The initial pose used to initiallize the internal IK Solver in a pose3d
///        handle.This pose must follow the extended joints definition composed of 30 joints
///        and represent a T posed character in the IK solver referential (Y up, Z forward, X
///        left).
WRNCH_DLL_INTERFACE void wrPoseIK_ResetFromPose(wrPoseIKHandle handle,
                                                wrPose3dHandleConst initialPose);
WRNCH_DLL_INTERFACE void wrPoseIK_Destroy(wrPoseIKHandle handle);

/// @brief Performs a solving step using the provided 3d positions as effectors.
///        The result will be returned in a pose3d containing positions and rotations for each
///        joint in the extended joint definition. Rotations are represented here as normalized
///        quaternions in world space. Each rotation is independant of its parent node and is
///        expressed with respect to the initial TPose (eg. the final rotation of your object
///        should be Rotation = Q * Qtpose.conjugate()) Positions will be solved with respect to
///        the scale of the initial T posed character, and an average scaling factor can be
///        found in the ScaleHint field of the pose3d object. Values are returned in the
///        internal IK Solver referential (Y up, Z forward, X left).
/// @param handle Handle to the solver performing the solving
/// @param pose 3d positions of the input effectors. The input positions needs to match the
///        input format specified at initialization. The input positions must be expressed in
///        the internal solver referential (Y up, Z Forward, X left).
/// @param visibilities Represents the visibility of each effector in the input pose. Those
/// joints
///        will be ignored when performing the solving step. 0 represents a non visible joint, 1
///        represents a visible joint.
/// @param params Input parameters to perform the solving step.
/// @see wrIKParams
/// @see wrPose3d
WRNCH_DLL_INTERFACE wrPose3dHandleConst wrPoseIK_Solve(wrPoseIKHandle handle,
                                                       const float* pose,
                                                       const int* visibilities,
                                                       wrIKParamsHandleConst params);

/// @brief Returns a handle to the joint definition representing the data returned by the call
///        to wrPoseIK_Solve.
/// @param handle handle to the solver
/// @see wrPoseIK_Solver
/// @see wrJointDefinition
WRNCH_DLL_INTERFACE wrJointDefinitionHandleConst
wrPoseIK_GetOutputFormat(wrPoseIKHandleConst handle);

/// @brief Returns a handle to the input joint definition expected by the IK Solver.
/// @param handle handle to the solver
WRNCH_DLL_INTERFACE wrJointDefinitionHandleConst
wrPoseIK_GetInputFormat(wrPoseIKHandleConst handle);

/// @brief Change the input format used when sending effectors to Solve.
/// @param handle handle to the solver
/// @param inputFormat handle to the desired inputformat.
/// @see wrPoseIK_Solve
WRNCH_DLL_INTERFACE void wrPoseIK_SetInputFormat(wrPoseIKHandle handle,
                                                 wrJointDefinitionHandleConst inputFormat);

/// @brief Get the value of an internal IK Property.
/// @param handle handle to the solver
/// @param property Name of the property to get
WRNCH_DLL_INTERFACE float wrPoseIK_GetIKProperty(wrPoseIKHandleConst handle, wrIKProperty property);

/// @brief Set the value of an internal IK Property
/// @param handle handle to the solver
/// @param property Name of the property to modify
/// @param value value of the property
WRNCH_DLL_INTERFACE void wrPoseIK_SetIKProperty(wrPoseIKHandle handle,
                                                wrIKProperty property,
                                                float value);

/// @brief Get the initial TPose specified in the solver. The T pose will be returned as a
///        wrPose3d, containing positions only. We assume unit quaternions when in TPose.
/// @param handle to the solver.
WRNCH_DLL_INTERFACE wrPose3dHandleConst wrPoseIK_GetTPose(wrPoseIKHandleConst handle);

#ifdef __cplusplus
}
#endif

#endif /* WRNCH_WRPOSEIK_C_API */
