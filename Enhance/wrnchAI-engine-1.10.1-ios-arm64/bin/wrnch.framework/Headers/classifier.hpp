/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/

#ifndef WRNCH_CLASSIFIER_CXX_API
#define WRNCH_CLASSIFIER_CXX_API

#include <wrnch/utils.hpp>
#include <wrnch/classifier.h>
#include <wrnch/poseTypes.hpp>
#include <new>

namespace wrnch
{
////////////////// Experimental Classifier //////////////////
////////////////// For advanced users only //////////////////
//       NOTE: Classifier is not supported for Apple platforms

class Classifier
{
  public:
    Classifier()
    : m_impl(NULL)
    {
    }

    Classifier(Classifier&& classifier)
    : m_impl(classifier.m_impl)
    {
        classifier.m_impl = NULL;
    }

    Classifier(const char* modelPath, const int batchSize, const int deviceId)
    {
        wrReturnCode code = wrClassifier_Create(&m_impl, modelPath, batchSize, deviceId);
        ExceptionHandler(code);
    }

    Classifier(wrClassifierHandle classifier)
    : m_impl(classifier)
    {
    }

    ~Classifier() { wrClassifier_Destroy(m_impl); }

    Classifier Clone() const
    {
        wrReturnCode code;
        auto clone = Clone(code);
        ExceptionHandler(code);
        return clone;
    }

    Classifier Clone(wrReturnCode& code) const
    {
        wrClassifierHandle cloneHandle;
        code = wrClassifier_Clone(m_impl, &cloneHandle);
        return Classifier(cloneHandle);
    }

    Classifier Clone(int deviceId) const
    {
        wrReturnCode code;
        auto clone = Clone(deviceId, code);
        ExceptionHandler(code);
        return clone;
    }

    Classifier Clone(int deviceId, wrReturnCode& code) const
    {
        wrClassifierHandle cloneHandle;
        code = wrClassifier_CloneOnDevice(m_impl, &cloneHandle, deviceId);
        return Classifier(cloneHandle);
    }

    /// @brief Serialize a classifier to memory. Such serialized data may be persisted to disk,
    ///        and (under appropriate circumstances) deserialized using
    ///        `Classifier::Deserialize`.
    /// @note Not supported on Apple platforms.
    SerializedEstimator Serialize() const
    {
        return SerializedEstimator{ wrClassifier_Serialize(Get()) };
    }

    /// @brief Attempt to deserialize a serialized classifier. Failures to deserialize result in
    ///         an exception being thrown. Note that the serializedData _must_ be from a classifier
    ///         serialized on an identical device (including driver versions) using
    ///         `Classifier::Serialize`. The behavior of this function is undefined if this
    ///         fails to be the case. Any properties that were set on
    ///         the serialized estimator will hold to be true on a deserialized estimator (for
    ///         example, if hand models were initialized on the serialized estimator, a successful
    ///         call to `Deserialize` results in an estimator with hand models
    ///         initialized.
    /// @note Not supported on Apple platforms.
    static Classifier Deserialize(char const* data, int numBytes, int deviceId = 0)
    {
        wrClassifierHandle c_classifier = nullptr;
        wrReturnCode const code = wrClassifier_Deserialize(data, numBytes, deviceId, &c_classifier);
        ExceptionHandlerStatic(code, c_classifier);
        assert(c_classifier != nullptr);
        return Classifier(c_classifier);
    }

    void Initialize(const char* modelPath, const int batchSize, const int deviceId)
    {
        wrReturnCode code;
        Initialize(modelPath, batchSize, deviceId, code);
        ExceptionHandler(code);
    }

    void Initialize(const char* modelPath,
                    const int batchSize,
                    const int deviceId,
                    wrReturnCode& code)
    {
        wrClassifier_Destroy(m_impl);
        code = wrClassifier_Create(&m_impl, modelPath, batchSize, deviceId);
    }

    template<class PtrType>
    void ProcessFrame(const unsigned char* imgData,
                      const BasicBox2d<PtrType>* bboxs,
                      int width,
                      int height,
                      int channels,
                      int numBboxs)
    {
        wrReturnCode code;
        ProcessFrame(imgData, bboxs, width, height, channels, numBboxs, code);
        ExceptionHandler(code);
    }

    template<class PtrType>
    void ProcessFrame(const unsigned char* imgData,
                      const BasicBox2d<PtrType>* bboxs,
                      int width,
                      int height,
                      int channels,
                      int numBboxs,
                      wrReturnCode& code)
    {
        std::vector<wrBox2dHandleConst> cBoxes(numBboxs);
        for (int i = 0; i < numBboxs; i++)
        {
            cBoxes[i] = bboxs[i].Get();
        }

        code = wrClassifier_ProcessFrame(
            m_impl, imgData, cBoxes.data(), width, height, channels, numBboxs);
    }

    // takes a full image and builds the batch from supplied bboxs
    template<class PtrType>
    void ProcessBatch(const unsigned char* const* imgData,
                      const BasicBox2d<PtrType>* bboxs,
                      const int* widths,
                      const int* heights,
                      int depth,
                      int imgBatchSize,
                      int bboxBatchSize)
    {
        wrReturnCode code;
        ProcessBatch(imgData, bboxs, widths, heights, depth, imgBatchSize, bboxBatchSize, code);
        ExceptionHandler(code);
    }

    // takes a full image and builds the batch from supplied bboxs
    template<class PtrType>
    void ProcessBatch(const unsigned char* const* imgData,
                      const BasicBox2d<PtrType>* bboxs,
                      const int* widths,
                      const int* heights,
                      int depth,
                      int imgBatchSize,
                      int bboxBatchSize,
                      wrReturnCode& code)
    {
        std::vector<wrBox2dHandleConst> cBoxes(imgBatchSize * bboxBatchSize);
        for (int i = 0; i < imgBatchSize * bboxBatchSize; i++)
        {
            cBoxes[i] = bboxs[i].Get();
        }
        code = wrClassifier_ProcessBatch(
            m_impl, imgData, cBoxes.data(), widths, heights, depth, imgBatchSize, bboxBatchSize);
    }

    int GetScores(float* scoresOut, int maxScores) const
    {
        return wrClassifier_GetScores(m_impl, scoresOut, maxScores);
    }
    void GetBatchScores(float* scoresOut, int maxScores, int& batchSizeOut, int& numClasses) const
    {
        wrClassifier_GetBatchScores(m_impl, scoresOut, maxScores, &batchSizeOut, &numClasses);
    }
    void GetInfo(unsigned int* infoOut) const { wrClassifier_GetInfo(m_impl, infoOut); }

    const wrClassifier* Get() const { return m_impl; }

  private:
    Classifier(Classifier&);             // unimplemented ("= delete")
    Classifier& operator=(Classifier&);  // unimplemented ("= delete")

    void ExceptionHandler(wrReturnCode code) const { ExceptionHandler(code, ""); }
    void ExceptionHandler(wrReturnCode code, const char* msg) const
    {
        ExceptionHandlerStatic(code, msg, Get());
    }
    static void ExceptionHandlerStatic(wrReturnCode code, wrClassifier const* c_classifier)
    {
        ExceptionHandlerStatic(code, "", c_classifier);
    }
    static void ExceptionHandlerStatic(wrReturnCode code,
                                       const char* msg,
                                       wrClassifier const* c_classifier)
    {
        switch (code)
        {
            case wrReturnCode_OK:
                break;
            case wrReturnCode_BAD_ALLOC:
                utils::CheckBadAlloc(c_classifier);
                break;
            default:
                throw utils::Exception(code, msg);
        }
    }

    wrClassifier* m_impl;
};
}

#endif /* WRNCH_CLASSIFIER_CXX_API */
