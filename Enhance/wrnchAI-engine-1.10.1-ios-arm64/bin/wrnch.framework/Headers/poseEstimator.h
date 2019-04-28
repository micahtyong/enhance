/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/

#ifndef WRNCH_POSE_ESTIMATOR_C_API
#define WRNCH_POSE_ESTIMATOR_C_API

#include <wrnch/definitions.h>
#include <wrnch/jointDefinition.h>
#include <wrnch/poseParams.h>
#include <wrnch/poseEstimatorOptions.h>
#include <wrnch/poseTypes.h>
#include <wrnch/returnCodes.h>
#include <wrnch/poseIK.h>

#ifdef __cplusplus
extern "C" {
#endif

/// @file   poseEstimator.h
/// @brief  wrPoseEstimator
///	@note
///			-# Where required, the modelName2d must be the full 2D pose model file name, e.g.,
/// wrnch_pose2d_v3.4.enc
///         -# Where required, the licenseString must be the complete contents of the wrnchAI
///         engine license which has been issued to you
struct wrPoseEstimatorConfigParams_;
typedef struct wrPoseEstimatorConfigParams_* wrPoseEstimatorConfigParams;
typedef const struct wrPoseEstimatorConfigParams_* wrPoseEstimatorConfigParamsConst;

WRNCH_DLL_INTERFACE wrPoseEstimatorConfigParams
wrPoseEstimatorConfigParams_Create(const char* modelsDirectory);
WRNCH_DLL_INTERFACE void wrPoseEstimatorConfigParams_SetDeviceId(wrPoseEstimatorConfigParams params,
                                                                 int deviceId);
WRNCH_DLL_INTERFACE void wrPoseEstimatorConfigParams_SetModelName2D(
    wrPoseEstimatorConfigParams params, const char* modelName2d);
WRNCH_DLL_INTERFACE void wrPoseEstimatorConfigParams_SetLicenseString(
    wrPoseEstimatorConfigParams params, const char* licenseString);
WRNCH_DLL_INTERFACE void wrPoseEstimatorConfigParams_SetPoseParams(
    wrPoseEstimatorConfigParams params, wrPoseParamsHandleConst poseParams);
WRNCH_DLL_INTERFACE void wrPoseEstimatorConfigParams_SetOutputFormat(
    wrPoseEstimatorConfigParams params, wrJointDefinitionHandleConst outputFormat);
WRNCH_DLL_INTERFACE const char* wrPoseEstimatorConfigParams_GetModelsDirectory(
    wrPoseEstimatorConfigParamsConst params);
WRNCH_DLL_INTERFACE void wrPoseEstimatorConfigParams_Destroy(wrPoseEstimatorConfigParams params);

struct wrPoseEstimator;
typedef struct wrPoseEstimator* wrPoseEstimatorHandle;
typedef const struct wrPoseEstimator* wrPoseEstimatorHandleConst;

WRNCH_DLL_INTERFACE wrReturnCode wrPoseEstimator_CreateFromConfig(
    wrPoseEstimatorHandle* handle, wrPoseEstimatorConfigParamsConst configData);

WRNCH_DLL_INTERFACE wrReturnCode wrPoseEstimator_Create(wrPoseEstimatorHandle* handle,
                                                        const char* modelsDirectory,
                                                        int deviceId,
                                                        wrPoseParamsHandleConst params,
                                                        wrJointDefinitionHandleConst outputFormat);

WRNCH_DLL_INTERFACE wrReturnCode wrPoseEstimator_CreateDefault(wrPoseEstimatorHandle* handle,
                                                               const char* modelsDirectory);

WRNCH_DLL_INTERFACE wrReturnCode
wrPoseEstimator_CreateFromModel(wrPoseEstimatorHandle* handle,
                                const char* modelsDirectory,
                                const char* modelName2d,
                                int deviceId,
                                wrPoseParamsHandleConst params,
                                wrJointDefinitionHandleConst outputFormat);

WRNCH_DLL_INTERFACE wrReturnCode wrPoseEstimator_CreateDefaultFromModel(
    wrPoseEstimatorHandle* handle, const char* modelsDirectory, const char* modelName2d);

WRNCH_DLL_INTERFACE wrReturnCode
wrPoseEstimator_Reinitialize(wrPoseEstimatorHandle* handle,
                             const char* modelsDirectory,
                             int deviceId,
                             wrPoseParamsHandleConst params,
                             wrJointDefinitionHandleConst outputFormat);

WRNCH_DLL_INTERFACE wrReturnCode wrPoseEstimator_ReinitializeFromConfig(
    wrPoseEstimatorHandle* handle, wrPoseEstimatorConfigParamsConst configData);

WRNCH_DLL_INTERFACE wrReturnCode
wrPoseEstimator_ReinitializeFromModel(wrPoseEstimatorHandle* handle,
                                      const char* modelsDirectory,
                                      const char* modelName2d,
                                      int deviceId,
                                      wrPoseParamsHandleConst params,
                                      wrJointDefinitionHandleConst outputFormat);

WRNCH_DLL_INTERFACE wrReturnCode wrPoseEstimator_ReinitializeDefault(wrPoseEstimatorHandle* handle,
                                                                     const char* modelsDirectory);

WRNCH_DLL_INTERFACE wrReturnCode wrPoseEstimator_ReinitializeDefaultFromModel(
    wrPoseEstimatorHandle* handle, const char* modelName2d, const char* modelsDirectory);

/// @brief	Destroys the pose estimator and deallocates the associated memory
/// @param	handle the wrPoseEstimatorHandle to the pose estimator to be destroyed
/// @note	It is safe to call this function on a null pointer
WRNCH_DLL_INTERFACE void wrPoseEstimator_Destroy(wrPoseEstimatorHandle handle);

WRNCH_DLL_INTERFACE wrReturnCode wrPoseEstimator_ReinitializeDefaultFromModel(
    wrPoseEstimatorHandle* handle, const char* modelsDirectory, const char* modelsName2d);

/// @brief	Makes a deep copy of the pose estimator provided
/// @param	src the wrPoseEstimatorHandle to the pose estimator to be cloned
/// @param	dst handle which will point to the newly created pose estimator
/// @note   This feature is not supported on Apple platforms
WRNCH_DLL_INTERFACE wrReturnCode wrPoseEstimator_Clone(wrPoseEstimatorHandleConst src,
                                                       wrPoseEstimatorHandle* dst);

/// @brief	Makes a deep copy of the pose estimator provided
/// @param	src the wrPoseEstimatorHandle to the pose estimator to be cloned
/// @param	dst handle which will point to the newly created pose estimator
/// @param  deviceId Index of the GPU we wish to create the new pose estimator on
/// @note   This feature is not supported on Apple platforms
WRNCH_DLL_INTERFACE wrReturnCode wrPoseEstimator_CloneOnDevice(wrPoseEstimatorHandleConst src,
                                                               wrPoseEstimatorHandle* dst,
                                                               int deviceId);

/// @brief Serialize a pose estimator to memory. Such serialized data may be persisted to disk,
/// and (under appropriate circumstances) deserialized using `wrPoseEstimator_Deserialize`. The
/// returned wrSerializedEstimatorHandle should be freed with `wrSerializedEstimator_Destroy`.
/// @note Not supported on Apple platforms.
WRNCH_DLL_INTERFACE wrSerializedEstimatorHandle
    wrPoseEstimator_Serialize(wrPoseEstimatorHandleConst);

/// @brief Attempt to deserialize a serialized pose estimator. If the returned value is
///         `wrReturnCode_OK`, then a pointer to a fresh pose estimator is written to
///         `outPoseEstimator` (and it thus should be freed with wrPoseEstimator_Destroy). If
///         the returned value is not `wrReturnCode_OK`, then nothing is written to
///         `outPoseEstimator`. Note that the serializedData _must_ be from a pose estimator
///         serialized on an identical device (including driver versions) using
///         `wrPoseEstimator_Serialize`. The behavior of this function is undefined if this
///         fails to be the case. Any properties that were set on the serialized estimator will
///         hold to be true on a deserialized estimator (for example, if hand models were
///         initialized on the serialized estimator, a successful call to
///         `wrPoseEstimator_Deserialize` results in an estimator with hand models initialized.
/// @note Not supported on Apple platforms.
WRNCH_DLL_INTERFACE wrReturnCode
wrPoseEstimator_Deserialize(char const* serializedData,
                            int numBytes,
                            int deviceId,
                            wrPoseEstimatorHandle* outPoseEstimator);

/// @brief  Initializes 3D pose estimation, with or without inverse kinematics, using the
///         3D pose model found in the models directory supplied when the pose estimator
//          was created
/// @see    wrPoseEstimatorHandle
/// @see    wrIKParamsHandleConst
/// @see    wrReturnCode
/// @param  handle the wrPoseEstimatorHandle which will process the 3D pose estimation
/// @param  params the wrIKParamsHandleConst which sets up the inverse kinematics parameters
///         or NULL to processs 3D without inverse kinematics
/// @param  modelsDirectory
/// @return	The status code indicating success or error condition
WRNCH_DLL_INTERFACE wrReturnCode wrPoseEstimator_Initialize3D(wrPoseEstimatorHandle handle,
                                                              wrIKParamsHandleConst params,
                                                              const char* modelsDirectory);

/// @note   Hand and head poses are not supported on Apple platforms
WRNCH_DLL_INTERFACE wrReturnCode wrPoseEstimator_InitializeHands2D(wrPoseEstimatorHandle,
                                                                   const char* modelsDirectory);

WRNCH_DLL_INTERFACE void wrPoseEstimator_SetHandSegmenter(wrPoseEstimatorHandle,
                                                          wrHandSegmenterType);

WRNCH_DLL_INTERFACE wrHandSegmenterType
    wrPoseEstimator_GetHandSegmenterType(wrPoseEstimatorHandleConst);

WRNCH_DLL_INTERFACE wrReturnCode wrPoseEstimator_InitializeHeadDefault(wrPoseEstimatorHandle,
                                                                       const char* modelsDirectory);

WRNCH_DLL_INTERFACE wrReturnCode wrPoseEstimator_InitializeHead(wrPoseEstimatorHandle,
                                                                float betaX,
                                                                float betaY,
                                                                float minFreqCutoffPosition,
                                                                float freqCutoffVelocity,
                                                                const char* modelsDirectory);

/// @brief    return an unowned reference to a jointDefinition. In other words,
/// the referenced jointDefinition is owned by the poseEstimator handle and must not be
/// destroyed.
WRNCH_DLL_INTERFACE wrJointDefinitionHandleConst
    wrPoseEstimator_GetHuman2DOutputFormat(wrPoseEstimatorHandleConst);

WRNCH_DLL_INTERFACE wrJointDefinitionHandleConst
    wrPoseEstimator_GetHuman3DOutputFormat(wrPoseEstimatorHandleConst);

WRNCH_DLL_INTERFACE wrJointDefinitionHandleConst
    wrPoseEstimator_GetHuman3DRawOutputFormat(wrPoseEstimatorHandleConst);

WRNCH_DLL_INTERFACE wrJointDefinitionHandleConst
    wrPoseEstimator_GetHandOutputFormat(wrPoseEstimatorHandleConst);

WRNCH_DLL_INTERFACE wrJointDefinitionHandleConst
    wrPoseEstimator_GetFaceOutputFormat(wrPoseEstimatorHandleConst);

/// @brief	Process a frame to generate pose estimation data which is stored internally
///			in the wrPoseEstimatorHandle. The data can then be accessed via the
///			GetNum* and GetAll* functions defined in this header
/// @see	wrPoseEstimatorHandle
/// @see	wrPoseEstimatorOptionsHandleConst
/// @see	wrReturnCode
/// @param	handle the wrPoseEstimatorHandle which will process the frame
/// @param	bgrData a pointer to the frame colour data which must be in 3-channel
///			openCV format, i.e., row-major sequence of [b1,g1,r1,b2,g2,r2, ... ]
///			intensity values in the range [0,255]
/// @param	width frame width in pixels. The behavior is undefined unless width is (strictly)
/// greater than zero.
/// @param	height frame height in pixels. The behavior is undefined unless height is (strictly)
/// greater than zero.
/// @param	options the wrPoseEstimatorOptionsHandleConst struct specifying the required
/// options,
///			e.g. whether to estimate hands, heads, 3D, etc., which will be used by
///			PoseEstimatorHandle to process the frame
/// @return	The status code indicating success or error condition
WRNCH_DLL_INTERFACE wrReturnCode
wrPoseEstimator_ProcessFrame(wrPoseEstimatorHandle handle,
                             const unsigned char* bgrData,
                             int width,
                             int height,
                             wrPoseEstimatorOptionsHandleConst options);

WRNCH_DLL_INTERFACE unsigned int wrPoseEstimator_GetMaxHumans2D();

WRNCH_DLL_INTERFACE unsigned int wrPoseEstimator_GetNumHumans2D(wrPoseEstimatorHandleConst);

WRNCH_DLL_INTERFACE wrPose2dHandleConst
wrPoseEstimator_GetHumans2DBegin(wrPoseEstimatorHandleConst handle);

WRNCH_DLL_INTERFACE wrPose2dHandleConst wrPoseEstimator_GetPose2DNext(wrPose2dHandleConst pose);

WRNCH_DLL_INTERFACE wrPose2dHandleConst
wrPoseEstimator_GetHumans2DEnd(wrPoseEstimatorHandleConst handle);


/// @brief	Obtain estimated 2D poses
/// @see	wrPoseEstimatorHandleConst
/// @see	wrPose2dHandle
/// @see	wrPoseEstimator_GetNumHumans2D()
/// @param	handle the wrPoseEstimatorHandle which has been processed
/// @param	poses a pointer to sufficient memory to store wrPoseEstimator_GetNumHumans2D()
///			wrPose2dHandles.
WRNCH_DLL_INTERFACE void wrPoseEstimator_GetAllHumans2D(wrPoseEstimatorHandleConst handle,
                                                        const wrPose2dHandle* poses);

/// @brief	Obtain a limited number of estimated 2D poses
/// @see	wrPoseEstimatorHandleConst
/// @see	wrPose2dHandle
/// @see	wrPoseEstimator_GetNumHumans2D()
/// @param	handle the wrPoseEstimatorHandle which has been processed
/// @param	poses a pointer to sufficient memory to store maxPersons
///			wrPose2dHandles.
/// @param  maxPersons the maximum number of persons to be written in poses. If more than
///			this many persons have been detected in handle, the specific persons
///         returned is unspecified.
/// @return	The number of poses stored in poses after return
WRNCH_DLL_INTERFACE unsigned int wrPoseEstimator_GetHumans2DLimited(
    wrPoseEstimatorHandleConst handle, const wrPose2dHandle* poses, unsigned int maxPersons);

WRNCH_DLL_INTERFACE unsigned int wrPoseEstimator_GetMaxHands2D();

WRNCH_DLL_INTERFACE unsigned int wrPoseEstimator_GetNumHands(wrPoseEstimatorHandleConst);
WRNCH_DLL_INTERFACE unsigned int wrPoseEstimator_GetNumLeftHands(wrPoseEstimatorHandleConst);
WRNCH_DLL_INTERFACE unsigned int wrPoseEstimator_GetNumRightHands(wrPoseEstimatorHandleConst);

WRNCH_DLL_INTERFACE wrPose2dHandleConst
wrPoseEstimator_LeftHandsBegin(wrPoseEstimatorHandleConst handle);
WRNCH_DLL_INTERFACE wrPose2dHandleConst
wrPoseEstimator_LeftHandsEnd(wrPoseEstimatorHandleConst handle);
WRNCH_DLL_INTERFACE wrPose2dHandleConst
wrPoseEstimator_RightHandsBegin(wrPoseEstimatorHandleConst handle);
WRNCH_DLL_INTERFACE wrPose2dHandleConst
wrPoseEstimator_RightHandsEnd(wrPoseEstimatorHandleConst handle);

WRNCH_DLL_INTERFACE unsigned int wrPoseEstimator_GetMaxHeads();

WRNCH_DLL_INTERFACE unsigned int wrPoseEstimator_GetNumHeads(wrPoseEstimatorHandleConst);

WRNCH_DLL_INTERFACE wrPoseHeadHandleConst
wrPoseEstimator_GetHeadPosesBegin(wrPoseEstimatorHandleConst handle);

WRNCH_DLL_INTERFACE wrPoseHeadHandleConst
wrPoseEstimator_GetHeadPosesNext(wrPoseHeadHandleConst pose);

WRNCH_DLL_INTERFACE wrPoseHeadHandleConst
wrPoseEstimator_GetHeadPosesEnd(wrPoseEstimatorHandleConst handle);

/// @brief	Obtain estimated head poses
/// @see	wrPoseEstimatorHandleConst
/// @see	wrPoseHeadHandle
/// @see	wrPoseEstimator_GetNumHeads()
/// @param	handle the wrPoseEstimatorHandle which has been processed
/// @param	poses a pointer to sufficient memory to store wrPoseEstimator_GetNumHeads()
///			wrPoseHeadHandles.
WRNCH_DLL_INTERFACE void wrPoseEstimator_GetAllHeadPoses(wrPoseEstimatorHandleConst handle,
                                                         const wrPoseHeadHandle* poses);

/// @brief	Obtain estimated head poses
/// @see	wrPoseEstimatorHandleConst
/// @see	wrPoseHeadHandle
/// @see	wrPoseEstimator_GetNumHeads()
/// @param	handle the wrPoseEstimatorHandle which has been processed
/// @param	poses a pointer to sufficient memory to store maxHeads
///			wrPoseHeadHandles.
/// @param  maxHeads the maximum number of heads to be written in poses. If more than
///			this many heads have been detected in handle, the specific head poses
///         written is unspecified.
/// @return	The number of head poses stored in poses after return
WRNCH_DLL_INTERFACE unsigned int wrPoseEstimator_GetHeadPosesLimited(
    wrPoseEstimatorHandleConst handle, const wrPoseHeadHandle* poses, unsigned int maxHeads);

WRNCH_DLL_INTERFACE unsigned int wrPoseEstimator_GetNumPoseFace(wrPoseEstimatorHandleConst handle);

WRNCH_DLL_INTERFACE wrPoseFaceHandleConst
wrPoseEstimator_GetFacePosesBegin(wrPoseEstimatorHandleConst handle);

WRNCH_DLL_INTERFACE wrPoseFaceHandleConst
wrPoseEstimator_GetFacePosesNext(wrPoseFaceHandleConst pose);

WRNCH_DLL_INTERFACE wrPoseFaceHandleConst
wrPoseEstimator_GetFacePosesEnd(wrPoseEstimatorHandleConst handle);

WRNCH_DLL_INTERFACE void wrPoseEstimator_GetAllPoseFace(wrPoseEstimatorHandleConst handle,
                                                        const wrPoseFaceHandle* poseFaces);

WRNCH_DLL_INTERFACE unsigned int wrPoseEstimator_GetPoseFaceLimited(
    wrPoseEstimatorHandleConst handle, const wrPoseFaceHandle* poseFaces, unsigned int maxPoseFace);

WRNCH_DLL_INTERFACE void wrPoseEstimator_GetMaskDims(wrPoseEstimatorHandleConst,
                                                     int* outMaskWidth,
                                                     int* outMaskHeight,
                                                     int* outMaskDepth);

/// @deprecated This function is deprecated. Instead, use wrJointDefinition_GetMaskView
/// @see        wrPoseEstimator_GetMaskView
/// @brief	Obtain estimated masks
/// @see	wrPoseEstimatorHandleConst
/// @see	wrPoseEstimator_GetMaskDims
/// @param	handle the wrPoseEstimatorHandle which has been processed
/// @param  outMask a pointer to at least maskWidth * maskHeight * maskDepth bytes
///         to be filled out with segmentation mask data
///	@note
///			-# The dimensions of the mask may not be the same as the input image.
///         -# Mask data is stored as four 8-bit single channel images in row-major
///            order whose values represent the confidence that a human is present in
///            that pixel.  The four generated masks are stored contiguously, as follows:
///            (0) body; (1) right hand; (2) left hand; and (3) both hands.

WRNCH_DLL_INTERFACE void wrPoseEstimator_GetMask(wrPoseEstimatorHandleConst handle,
                                                 unsigned char* outMask);

/// @brief	Obtain estimated masks
/// @see	wrPoseEstimatorHandleConst
/// @see	wrPoseEstimator_GetMaskDims
/// @param	handle the wrPoseEstimatorHandle which has been processed
///	@note
///			-# The dimensions of the mask may not be the same as the input image.
///         -# Mask data is stored as four 8-bit single channel images in row-major
///            order whose values represent the confidence that a human is present in
///            that pixel.  The four generated masks are stored contiguously, as follows:
///            (0) body; (1) right hand; (2) left hand; and (3) both hands.
/// @return a pointer to the greenscreen mask, valid for maskWidth * maskHeight * maskDepth
///          bytes, as returned by wrPoseEstimator_GetMaskDims

WRNCH_DLL_INTERFACE const unsigned char* wrPoseEstimator_GetMaskView(
    wrPoseEstimatorHandleConst handle);


WRNCH_DLL_INTERFACE unsigned int wrPoseEstimator_GetNumRawHumans3D(wrPoseEstimatorHandleConst);

WRNCH_DLL_INTERFACE unsigned int wrPoseEstimator_GetNumHumans3D(wrPoseEstimatorHandleConst);

WRNCH_DLL_INTERFACE wrPose3dHandleConst
wrPoseEstimator_GetHumans3DBegin(wrPoseEstimatorHandleConst handle);

WRNCH_DLL_INTERFACE wrPose3dHandleConst wrPoseEstimator_GetPose3DNext(wrPose3dHandleConst pose);

WRNCH_DLL_INTERFACE wrPose3dHandleConst
wrPoseEstimator_GetHumans3DEnd(wrPoseEstimatorHandleConst handle);

/// @brief	Obtain estimated 3D poses
/// @see	wrPoseEstimatorHandleConst
/// @see	wrPose3dHandle
/// @see	wrPoseEstimator_GetNumHumans3D()
/// @param	handle the wrPoseEstimatorHandle which has been processed
/// @param	poses a pointer to sufficient memory to store wrPoseEstimator_GetNumHumans3D()
///			wrPose3dHandles.
WRNCH_DLL_INTERFACE void wrPoseEstimator_GetAllHumans3D(wrPoseEstimatorHandleConst handle,
                                                        const wrPose3dHandle* poses);

/// @brief	Obtain estimated 3D poses
/// @see	wrPoseEstimatorHandleConst
/// @see	wrPose3dHandle
/// @see	wrPoseEstimator_GetNumHumans3D()
/// @param	handle the wrPoseEstimatorHandle which has been processed
/// @param	poses a pointer to sufficient memory to store maxPersons
///			wrPose3dHandles.
/// @param  maxPersons the maximum number of persons to be stored in poses. If this number
///         is greater than the number of poses actually stored in handle, the specific
///         poses written to poses is unspecified
/// @return	The number of poses stored in poses after return
WRNCH_DLL_INTERFACE unsigned int wrPoseEstimator_GetHumans3DLimited(
    wrPoseEstimatorHandleConst handle, const wrPose3dHandle* poses, unsigned int maxPersons);

WRNCH_DLL_INTERFACE wrPose3dHandleConst
wrPoseEstimator_GetRawHumans3DBegin(wrPoseEstimatorHandleConst handle);

/* Uses: WRNCH_DLL_INTERFACE wrPose3dHandleConst
 * wrPoseEstimator_GetPose3DNext(wrPose3dHandleConst pose); */

WRNCH_DLL_INTERFACE wrPose3dHandleConst
wrPoseEstimator_GetRawHumans3DEnd(wrPoseEstimatorHandleConst handle);

/// @brief	Obtain estimated 3D poses in xyz coordinates
/// @see	wrPoseEstimatorHandleConst
/// @see	wrPose3dHandle
/// @see	wrPoseEstimator_GetNumHumans3D()
/// @param	handle the wrPoseEstimatorHandle which has been processed
/// @param	poses a pointer to sufficient memory to store wrPoseEstimator_GetNumHumans3D()
///			wrPose3dHandles.
WRNCH_DLL_INTERFACE void wrPoseEstimator_GetAllRawHumans3D(wrPoseEstimatorHandleConst handle,
                                                           const wrPose3dHandle* poses);

/// @brief	Obtain estimated 3D poses in xyz coordinates
/// @see	wrPoseEstimatorHandleConst
/// @see	wrPose3dHandle
/// @see	wrPoseEstimator_GetNumHumans3D()
/// @param	handle the wrPoseEstimatorHandle which has been processed
/// @param	poses a pointer to sufficient memory to store maxPersons
///			wrPose3dHandles.
/// @param  maxPersons the maximum number of persons to be stored in poses. If this number
///         is greater than the number of poses actually stored in handle, the specific
///         poses written to poses is unspecified
/// @return	The number of poses stored in poses after return
WRNCH_DLL_INTERFACE unsigned int wrPoseEstimator_GetRawHumans3DLimited(
    wrPoseEstimatorHandleConst handle, const wrPose3dHandle* poses, unsigned int maxPersons);

WRNCH_DLL_INTERFACE wrHandBoxPairHandleConst
wrPoseEstimator_GetHandBoxesBegin(wrPoseEstimatorHandleConst handle);

WRNCH_DLL_INTERFACE wrHandBoxPairHandleConst
wrPoseEstimator_GetHandBoxesNext(wrHandBoxPairHandleConst pose);

WRNCH_DLL_INTERFACE wrHandBoxPairHandleConst
wrPoseEstimator_GetHandBoxesEnd(wrPoseEstimatorHandleConst handle);

/// @brief	Obtain estimated handboxes
/// @see	wrHandBoxPairHandle
/// @see	wrPoseEstimator_GetNumHumans2D()
/// @param	handle the wrPoseEstimatorHandle which has been processed
/// @param	handBoxes a pointer to sufficient memory to store wrPoseEstimator_GetNumHumans2D()
///			wrHandBoxPairHandle bounding boxes.
///			hand box pairs
WRNCH_DLL_INTERFACE void wrPoseEstimator_GetAllHandBoxes(wrPoseEstimatorHandleConst handle,
                                                         const wrHandBoxPairHandle* handBoxes);

/// @brief	Obtain estimated handboxes
/// @see	wrHandBoxPairHandle
/// @see	wrPoseEstimator_GetNumHumans2D()
/// @param	handle the wrPoseEstimatorHandle which has been processed
/// @param	handBoxes a pointer to sufficient memory to store maxHandBoxPairs
///			wrHandBoxPairHandle bounding boxes.
/// @param  maxHandBoxPairs the maximum number of hand box pairs to be stored in handBoxes. If
/// this number
///         is greater than the number of hand box pairs actually stored in handle, the specific
///         boxes written to poses is unspecified
/// @return The number of hand boxes stored in handBoxes after return
WRNCH_DLL_INTERFACE unsigned int wrPoseEstimator_GetHandBoxesLimited(
    wrPoseEstimatorHandleConst handle,
    const wrHandBoxPairHandle* handBoxes,
    unsigned int maxHandBoxPairs);

WRNCH_DLL_INTERFACE unsigned int wrPoseEstimator_GetNumHandBoxes(wrPoseEstimatorHandleConst);

/*
    returns an unowned reference
*/
WRNCH_DLL_INTERFACE wrPose3dHandleConst wrPoseEstimator_GetTPose3D(wrPoseEstimatorHandleConst,
                                                                   int id);
WRNCH_DLL_INTERFACE void wrPoseEstimator_GetDefaultTPose3D(wrPoseEstimatorHandleConst,
                                                           wrPose3dHandle poseOut);
WRNCH_DLL_INTERFACE void wrPoseEstimator_ResetIKSolver(wrPoseEstimatorHandle handle,
                                                       wrPose3dHandleConst const initialPose,
                                                       int ikSolverId);
WRNCH_DLL_INTERFACE unsigned int wrPoseEstimator_GetInputWidth(wrPoseEstimatorHandleConst);
WRNCH_DLL_INTERFACE unsigned int wrPoseEstimator_GetInputHeight(wrPoseEstimatorHandleConst);
WRNCH_DLL_INTERFACE void wrPoseEstimator_SetParams(wrPoseEstimatorHandle, wrPoseParamsHandleConst);

/// @brief	Query if pose estimator supports inverse kinematics
/// @deprecated Inverse kinematics will always be supported. Function always returns 1.

WRNCH_DLL_INTERFACE int wrPoseEstimator_HasIK();

/// @brief	Query property of a inverse kinematic solver in 3d pose estimator
/// @see	wrPoseEstimator_GetNumIKSolvers
/// @param	handle the wrPoseEstimatorHandle which has been processed
/// @param	prop the identifier of the IK property to query
/// @param	id the identifier for the IK solver for which one wishes to get the property.
///     id must be between 0 and number returned by wrPoseEstimator_GetNumIKSolvers minus one.
WRNCH_DLL_INTERFACE float wrPoseEstimator_GetIKProperty(wrPoseEstimatorHandleConst handle,
                                                        int prop,
                                                        int id);

/// @brief	Set property of a inverse kinematic solver in 3d pose estimator
/// @see	wrPoseEstimator_GetNumIKSolvers
/// @param	handle the wrPoseEstimatorHandle which has been processed
/// @param	prop the identifier of the IK property to assign
/// @param	value the new value one wishes to assign to the property
/// @param	id the identifier for the IK solver for which one wishes to assign a new property
/// value.
///     id must be between 0 and number returned by wrPoseEstimator_GetNumIKSolvers minus one.
WRNCH_DLL_INTERFACE void wrPoseEstimator_SetIKProperty(wrPoseEstimatorHandle handle,
                                                       int prop,
                                                       float value,
                                                       int id);

WRNCH_DLL_INTERFACE unsigned int wrPoseEstimator_GetNumIKSolvers(wrPoseEstimatorHandleConst handle);

WRNCH_DLL_INTERFACE wrIKParamsHandleConst
wrPoseEstimator_GetIKParams(wrPoseEstimatorHandleConst handle);

WRNCH_DLL_INTERFACE wrPoseIKHandle wrPoseEstimator_GetIKSolver(wrPoseEstimatorHandle handle, int ikSolverId);
WRNCH_DLL_INTERFACE wrPoseIKHandleConst wrPoseEstimator_GetIKSolverConst(wrPoseEstimatorHandleConst handle, int ikSolverId);

WRNCH_DLL_INTERFACE wrPoseParamsHandleConst
wrPoseEstimator_GetParams(wrPoseEstimatorHandleConst handle);

WRNCH_DLL_INTERFACE int wrPoseEstimator_Is3dInitialized(wrPoseEstimatorHandleConst);
WRNCH_DLL_INTERFACE int wrPoseEstimator_IsHeadInitialized(wrPoseEstimatorHandleConst);
WRNCH_DLL_INTERFACE int wrPoseEstimator_AreHandsInitialized(wrPoseEstimatorHandleConst);
WRNCH_DLL_INTERFACE int wrPoseEstimator_SupportsMaskEstimation(wrPoseEstimatorHandleConst);

WRNCH_DLL_INTERFACE unsigned int wrGetNumberOfAvailableGPUs();

WRNCH_DLL_INTERFACE const char* wrReturnCode_Translate(wrReturnCode code);

WRNCH_DLL_INTERFACE wrReturnCode wrLicense_Check();

#ifdef __cplusplus
}
#endif

#endif /* WRNCH_POSE_ESTIMATOR_C_API */
