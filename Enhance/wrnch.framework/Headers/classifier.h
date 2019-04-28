/*
Copyright (c) 2018 Wrnch Inc.
All rights reserved
*/

#ifndef WRNCH_CLASSIFIER_C_API
#define WRNCH_CLASSIFIER_C_API

#include <wrnch/definitions.h>
#include <wrnch/poseTypes.h>
#include <wrnch/returnCodes.h>

#ifdef __cplusplus
extern "C" {
#endif

////////////////// Experimental Classifier //////////////////
////////////////// For advanced users only //////////////////
//       NOTE: Classifier is not supported for Apple platforms

struct wrClassifier;
typedef struct wrClassifier* wrClassifierHandle;
typedef const struct wrClassifier* wrClassifierHandleConst;

WRNCH_DLL_INTERFACE wrReturnCode wrClassifier_Create(wrClassifierHandle* handle,
                                                     const char* modelPath,
                                                     const int batchSize,
                                                     const int deviceId);

WRNCH_DLL_INTERFACE void wrClassifier_Destroy(wrClassifierHandle handle);

/// @brief	Makes a deep copy of the classifier provided
/// @param	src the wrClassifierHandle to the classifier to be cloned
/// @param	dst handle which will point to the newly created classifier
WRNCH_DLL_INTERFACE wrReturnCode wrClassifier_Clone(wrClassifierHandleConst src,
                                                    wrClassifierHandle* dst);

/// @brief	Makes a deep copy of the classifier provided
/// @param	src the wrClassifierHandle to the classifier to be cloned
/// @param	dst handle which will point to the newly created classifier
/// @param  deviceId Index of the GPU we wish to create the new classifier on
WRNCH_DLL_INTERFACE wrReturnCode wrClassifier_CloneOnDevice(wrClassifierHandleConst src,
                                                            wrClassifierHandle* dst,
                                                            int deviceId);

/// @brief Serialize a classifier to memory. Such serialized data may be persisted to disk, and
///         (under appropriate circumstances) deserialized using `wrClassifier_Deserialize`.
///         The returned wrSerializedEstimatorHandle should be freed with
///         `wrSerializedEstimator_Destroy`.
/// @note Not supported on Apple platforms.
WRNCH_DLL_INTERFACE wrSerializedEstimatorHandle wrClassifier_Serialize(wrClassifierHandleConst);

/// @brief Attempt to deserialize a serialized classifier. If the returned value is
///         `wrReturnCode_OK`, then a pointer to a fresh classifier is written to
///         `outClassifier` (and it thus should be freed with wrClassifier_Destroy). If the
///         returned value is not `wrReturnCode_OK`, then nothing is written to `outClassifier`.
///         Note that the serializedData _must_ be from a classifier serialized on an identical
///         device (including driver versions) using `wrClassifier_Serialize`. The behavior of
///         this function is undefined if this fails to be the case. Any properties that were
///         set on the serialized estimator will hold to be true on a deserialized estimator
/// @note Not supported on Apple platforms.
WRNCH_DLL_INTERFACE wrReturnCode wrClassifier_Deserialize(char const* serializedData,
                                                          int numBytes,
                                                          int deviceId,
                                                          wrClassifierHandle* outClassifier);

/// @brief  Process a frame to generate classification data which is stored in handle.
///         The scores can then be viewed by using the wrClassifier_GetScores function defined
///         in this  header.
/// @see    wrClassifier_GetScores
/// @see    wrClassifierHandle
/// @see    wrReturnCode
/// @param  handle The wrClassifierHandle which will process the frame
/// @param  imgData a pointer to the frame data which must be in 1 or 3 channel
///         openCV format, i.e., row-major sequence of [b1,g1,r1,b2,g2,r2, ... ]
///         intensity values in the range [0,255]
/// @param  bboxs an array of pointers to wrBox2d's specificying the regions of each
///         input image to extract and perform classification on.
/// @param  width frame width in pixels
/// @param  height frame height in pixels
/// @param  channels the number of channels in the image (1 and 3 supported)
/// @param  numBboxs the number of bounding boxes supplied for the frame
/// @return The status code indicating success or error condition
WRNCH_DLL_INTERFACE wrReturnCode wrClassifier_ProcessFrame(wrClassifierHandle handle,
                                                           const unsigned char* imgData,
                                                           const wrBox2dHandleConst* bboxs,
                                                           int width,
                                                           int height,
                                                           int channels,
                                                           int numBboxs);

/// @brief  Process a batch of bounding boxes within a single frame to generate classification
///         data which is stored in handle. The scores can then be viewed by using the
///         wrClassifier_GetBatchScores function defined in this header.
/// @see    wrClassifier_GetBatchScores
/// @see    wrClassifierHandle
/// @see    wrReturnCode
/// @param  handle The wrClassifierHandle which will process the frame
/// @param  batchData a buffer of pointers to the frames which must be in 3 channel
///         bgr format, i.e., row-major sequence of [b1,g1,r1,b2,g2,r2, ... ]
///         intensity values in the range [0,255]
/// @param  bboxs a flattened 2D array of pointers to wrBox2d's specificying the regions of each
///         input image to extract and perform classification on. We use bboxBatchSize wrBox2d's
///         for each image. E.g. image n, box m is at index n * bboxBatchSize + m
/// @param  widths frame width in pixels (one per frame in the batch)
/// @param  heights frame height in pixels (one per frame in the batch)
/// @param  depth number of channels (1 or 3) for each and every image in the batch
/// @param  imgBatchSize the number of frames pointed to by batchData
/// @param  bboxBatchSize the number of bounding boxes supplied for each frame
/// @return The status code indicating success or error condition
WRNCH_DLL_INTERFACE wrReturnCode wrClassifier_ProcessBatch(wrClassifierHandle handle,
                                                           const unsigned char* const* batchData,
                                                           const wrBox2dHandleConst* bboxs,
                                                           const int* widths,
                                                           const int* heights,
                                                           int depth,
                                                           int imgBatchSize,
                                                           int bboxBatchSize);

/// @brief  Retrieve the class scores after having procesed a frame.
/// @see    wrClassifier_ProcessFrame
/// @see    wrClassifierHandle
/// @param  handle The wrClassifierHandle which was previously used to process a frame
/// @param  scoresOut output argument which will be filled with results.
/// @param  maxScores The maximum number of scores (different classes) which can be written out.
///         i.e. the allocated space available to scoresOut.
/// @return The number of scores written to scoresOut
WRNCH_DLL_INTERFACE int wrClassifier_GetScores(const wrClassifierHandle handle,
                                               float* scoresOut,
                                               int maxScores);

/// @brief  Retrieve the class scores after having procesed a batch.
/// @see    wrClassifier_ProcessBatch
/// @see    wrClassifierHandle
/// @param  handle The wrClassifierHandle which was previously used to process a batch
/// @param  scoresOut output argument which will be filled with results.
///         The buffer will be filled to a maximum of maxScores, and the other output arguments
///         indicate how to traverse the data. Score for class m in batch n can be found at
///         scoresOut[n * batchSizeOut + m].
/// @param  maxScores The maximum number of scores (different classes) which can be written out.
///         i.e. the allocated space available to scoresOut. To get all results, this should be
///         batchSize*numClasses
/// @param  batchSizeOut output argument which will indicate the batchsize.
/// @param  numClasses output argument which will indicate how many classes have valid scores.
/// @return The number of scores written to scoresOut
WRNCH_DLL_INTERFACE void wrClassifier_GetBatchScores(const wrClassifierHandle handle,
                                                     float* scoresOut,
                                                     int maxScores,
                                                     int* batchSizeOut,
                                                     int* numClasses);

/// @brief  Get information about a classifier.
/// @param  handle The wrClassifierHandle you want information about.
/// @param  infoOut output argument which will be filled with results.
///         The buffer will be filled with 5 unsigned ints representing, in order:
///         inputWidth, inputHeight, inputChannels, batchSize, numClasses
WRNCH_DLL_INTERFACE void wrClassifier_GetInfo(const wrClassifierHandle handle,
                                              unsigned int* infoOut);

#ifdef __cplusplus
}
#endif

#endif /* WRNCH_CLASSIFIER_C_API */