/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/
#ifndef WRNCH_ACTIVITY_MODEL_GROUP_CXX_API
#define WRNCH_ACTIVITY_MODEL_GROUP_CXX_API

#include <wrnch/activityModelGroup.h>
#include <wrnch/activityModel.hpp>
#include <wrnch/poseEstimator.hpp>
#include <wrnch/activityPoseEstimatorRequirements.hpp>
#include <wrnch/utils.hpp>

#include <memory>
#include <type_traits>


/// @file activityModelGroup.hpp

namespace std
{
template<>
struct default_delete<wrActivityModelGroup>
{
    void operator()(wrActivityModelGroup* c_activityModelGroup) const
    {
        wrActivityModelGroup_Destroy(c_activityModelGroup);
    }
};

template<>
struct default_delete<wrActivityModelGroupBuilder>
{
    void operator()(wrActivityModelGroupBuilder* c_activityModelGroupBuilder) const
    {
        wrActivityModelGroupBuilder_Destroy(c_activityModelGroupBuilder);
    }
};
}  // namespace std


namespace wrnch
{
/// @brief ActivityModelGroup
///         Provides a RAII wrapper to the C-struct `wrActivityModelGroup` (of incomplete type) and
///         the free functions acting on it. Represents an optional pose estimator along with a
///         collection of activity model. "submodels". Destructor automaticaly calls
///         `wrActivityModelGroup_Destroy` on the underlying C pointer when the C++ object goes out
///         of scope.
/// @see `wrActivityModelGroup`
/// @see `ActivityModelView`
/// @see activityModel.hpp
/// @see activityModelGroup.h
class ActivityModelGroup
{
  public:
    ActivityModelGroup(ActivityModelGroup&&) = default;
    ActivityModelGroup& operator=(ActivityModelGroup&&) = default;

    /// @brief Attempt to process an image: first pass to (internal) pose estimator (which must not
    ///         be null) to process into joint data, then pass joint data to the `ActivityModel`
    ///         submodels. Modifies the internal state of the pose estimator and the `ActivityModel`
    ///         submodels to hold results based on the image. Throws an exception if an error
    ///         occurred during processing (there is a nothrow overload available as well).
    ///         @note The behavior is undefined unless the optional (internal) pose estimator member
    ///         is not null. In other words, the behavior is undefined if either overload of
    ///         `PoseestimatorOrNull()` returns `nullptr`. Only `wrActivityModelGroup` created by
    ///         `ActivityModelGroup::Builder::BuildWithPoseEstimator` have a non-null (internal)
    ///         pose estimator member.
    void ProcessFrame(unsigned char const* rowMajorBgrData, int imageWidth, int imageHeight);

    /// @brief Attempt to process an image in a nothrow manner: first pass to (internal) pose
    ///         estimator (which must not be null) to process into joint data, then pass joint data
    ///         to the `ActivityModel` submodels. Modifies the internal state of the pose estimator
    ///         and the `ActivityModel` submodels to hold results based on the image. An error
    ///         occurred if and only if `outcode == wrReturnCode_OK` after the call.
    /// @note The behavior is undefined unless the optional (internal) pose estimator member is
    ///         not null. In other words, the behavior is undefined if either overload of
    ///         `PoseestimatorOrNull()` returns `nullptr`. Only ActivityModelGroup created by
    ///         `ActivityModelGroup::Builder::BuildWithPoseEstimator` have a non-null (internal)
    ///         pose estimator member.
    void ProcessFrame(unsigned char const* rowMajorBgrData,
                      int imageWidth,
                      int imageHeight,
                      wrReturnCode& outcode);

    /// @brief Attempt to process an image: first pass image to the `PoseEstimator_t` estimator
    ///         argument, which produces joint data, then pass computed joints to the
    ///         `ActivityModel` submodels. Modifies the internal state of estimator and of the
    ///         submodels. An exception is thrown in the event of an error.
    /// @note For best results, the estimator argument should be compatible with
    ///         `PoseEstimatorRequirements()`. However, it is not undefined behavior to
    ///         pass an incompatible pose estimator.
    /// @param rowMajorBgrData a pointer to the frame colour data which must be in 3-channel
    ///         openCV format, i.e., row-major sequence of [b1,g1,r1,b2,g2,r2, ... ]
    ///         intensity values in the range [0,255]
    /// @param imageWidth the width of the image in pixels
    /// @param imageHeight the height of the image in pixels
    /// @param poseEstimator an instance of `PoseEstimatorView` or `PoseEstimator`
    /// @see `PoseEstimatorRequirements`
    template<class PoseEstimator_t,
             typename sfinae
             = std::enable_if<std::is_same<PoseEstimator_t, PoseEstimator>::value
                              || std::is_same<PoseEstimator_t, PoseEstimatorView>::value>>
    void ProcessFrame(unsigned char const* rowMajorBgrData,
                      int imageWidth,
                      int imageHeight,
                      PoseEstimator_t& poseEstimator);

    /// @brief Attempt to process an image in a nothrow manner: first pass image to the
    ///         `PoseEstimator_t estimator` argument, which produces joint data, then pass computed
    ///         joints to the `ActivityModel` submodels. Modifies the internal state of estimator
    ///         and of the submodels. An error occurred if and only if `outcode == wrReturnCode_OK`
    ///         after the call.
    /// @note For best results, the estimator argument should be compatible with
    ///         `PoseEstimatorRequirements()`. However, it is not undefined behavior to
    /// pass an incompatible pose estimator.
    /// @param rowMajorBgrData a pointer to the frame colour data which must be in 3-channel
    ///         openCV format, i.e., row-major sequence of [b1,g1,r1,b2,g2,r2, ... ]
    ///         intensity values in the range [0,255]
    /// @param imageWidth the width of the image in pixels
    /// @param imageHeight the height of the image in pixels
    /// @param poseEstimator an instance of `PoseEstimatorView` or `PoseEstimator`
    /// @param outcode
    /// @see `PoseEstimatorRequirements`
    template<class PoseEstimator_t,
             typename sfinae
             = std::enable_if<std::is_same<PoseEstimator_t, PoseEstimator>::value
                              || std::is_same<PoseEstimator_t, PoseEstimatorView>::value>>
    void ProcessFrame(unsigned char const* rowMajorBgrData,
                      int imageWidth,
                      int imageHeight,
                      PoseEstimator_t& poseEstimator,
                      wrReturnCode& outcode);

    /// @brief Process joint data held in a pose estimator. Pass the joint data to the
    ///         `ActivityModel` submodels.
    /// @param poseEstimator an instance of `PoseEstimator`, `PoseEstimatorView`, or
    ///         `PoseEstimatorConstView`. Should be compatible with the requirements of the
    ///         `activityModelGroup`, as returned by `PoseEstimatorRequirements`. In addition, the
    ///         frame processed by this pose estimator should have used `PoseEstimatorOptions`
    ///         compatible with the requirements as well.
    /// @param imageWidth The width of the image used in the last call to
    ///         `wrPoseEstimator_ProcessFrame` on estimator.
    /// @param imageHeight The height of the image used in the last call to
    ///         `wrPoseEstimator_ProcessFrame` on estimator.
    /// @see `PoseEstimatorRequirements`
    template<class PoseEstimator_t,
             typename sfinae
             = std::enable_if<std::is_same<PoseEstimator_t, PoseEstimator>::value
                              || std::is_same<PoseEstimator_t, PoseEstimatorView>::value
                              || std::is_same<PoseEstimator_t, PoseEstimatorConstView>::value>>
    void ProcessPoses(PoseEstimator_t const& poseEstimator, int imageWidth, int imageHeight);

    /// @brief Return the number of `ActivityModel` submodels contained in this model group.
    ///         This number corresponds to the number of times the `ActivityModelGroup::Builder`
    ///         which built this model group called `AddSubmodel` or `AddReflectedSubmodel`
    int NumSubmodels() const;

    /// @brief Return a submodel at a given index.
    /// @note The behavior is undefined unless `0 <= index` and `index < NumSubmodels()`
    ActivityModelView Submodel(int index) const;

    /// @brief Return a const view to the internal pose estimator if it exists, or an empty view
    ///         (which compares equal to `nullptr` under `operator==`). Only `wrActivityModelGroup`
    ///         created by `ActivityModelGroup::Builder::BuildWithPoseEstimator` will return a non
    ///         empty view here.
    PoseEstimatorConstView PoseEstimatorOrNull() const;

    /// @brief Return a view to the internal pose estimator if it exists, or an empty view (which
    ///         compares equal to `nullptr`). Only `wrActivityModelGroup` created by
    ///         `ActivityModelGroup::Builder::BuildWithPoseEstimator` will return a non empty view
    ///         here.
    PoseEstimatorView PoseEstimatorOrNull();

    /// @brief Return the requirements a pose estimator should satisfy in order to be used in
    ///         `wrActivityModelGroup_ProcessFrameWithPoseEstimator`. The returned view is not empty
    ///         (ie, its pointer to the underlying (incomplete) C type is not `nullptr`).
    /// @see wrActivityModelGroup_ProcessFrameWithPoseEstimator
    ActivityPoseEstimatorRequirementsView PoseEstimatorRequirements() const;

    friend class Builder;

    /// @brief Builder
    ///         Provides a RAII wrapper to the (incomplete) C type `wrActivityModelGroupBuilder`.
    ///         The purpose of this class is to build instances of `ActivityModelGroup`.
    class Builder
    {
      public:
        Builder()
        : m_impl(wrActivityModelGroupBuilder_Create())
        {
        }

        Builder(Builder&&) = default;
        Builder& operator=(Builder&&) = default;

        /// @brief Set the GPU device id to be used for activity models if this builder calls
        ///         `BuildWithPoseEstimator`, then the built poseEstimator is set to use the same
        ///         device id.
        Builder& SetDeviceId(int deviceId);

        /// @brief Add an additional ActivityModel submodel.
        /// @param modelPath the full path to the on-disk activity model file.
        Builder& AddSubmodel(std::string const& modelPath);

        /// @brief Add a "reflected" `ActivityModel` submodel. For the resulting
        ///         `ActivityModelGroup`, this means that in the various `ProcessFrameXXX`
        ///         functions, human poses are reflected about a vertical axis (as if by a mirror)
        ///         before passing to the `ActivityModel` submodels. The reason this exists is
        ///         because certain activity models classes are "handed", and only predict (for
        ///         example) gestures for one side of the body (eg the left). To infer gestures for
        ///         the other (eg the right) hand, the body pose is reflected and then passed to the
        ///         left-handed model.
        Builder& AddReflectedSubmodel(std::string const& modelPath);

        /// @brief Attempt to create a `wrActivityModelGroup`. Throws an exception if an error
        ///         occurs. In the nothrow case, an `ActivityModelGroup` is created which holds a
        ///         `wrPoseEstimator` internally (and hence it is safe to call the
        ///         `ActivityModelGroup::ProcessFrame` overload which does not require a
        ///         `poseEstimator` argument on the activity model group). The created (internal)
        ///         pose estimator is compatible with the requirements of the activity model group
        ///         (as returned by PoseEstimatorRequirements).
        ActivityModelGroup BuildWithPoseEstimator(std::string const& poseModelDir,
                                                  int desiredWidth,
                                                  int desiredHeight) const;

        /// @brief Attempt to create a `ActivityModelGroup`. Throws an exception if an error occurs.
        ///         If the return code is `wrReturnCode_OK`, then a `wrActivityModelGroup` is
        ///         created which *does not* hold a wrPoseEstimator internally (and hence it is
        ///         *not* safe to call the overload of `ProcessFrame` which does not take a pose
        ///         estimator on the activity model group).
        ActivityModelGroup BuildWithoutPoseEstimator() const;

        /// @brief Attempt to create a create a `PoseEstimator`. Throws an exception if an error
        ///         occurs.
        PoseEstimator BuildCompatiblePoseEstimator(std::string const& poseModelDir,
                                                   int deviceId,
                                                   int desiredWidth,
                                                   int desiredHeight) const;

        /// @brief Attempt to create compatible PoseEstimatorOptions. Throws an exception if an
        /// error occurs.
        PoseEstimatorOptions BuildCompatiblePoseEstimatorOptions() const;

        wrActivityModelGroupBuilder* Get() { return GetPtr(); }
        wrActivityModelGroupBuilder const* Get() const { return GetPtr(); }
        wrActivityModelGroupBuilder* GetPtr() { return m_impl.get(); }
        wrActivityModelGroupBuilder const* GetPtr() const { return m_impl.get(); }

      private:
        std::unique_ptr<wrActivityModelGroupBuilder> m_impl;
    };

    wrActivityModelGroup* Get() { return GetPtr(); }
    wrActivityModelGroup const* Get() const { return GetPtr(); }
    wrActivityModelGroup* GetPtr() { return m_impl.get(); }
    wrActivityModelGroup const* GetPtr() const { return m_impl.get(); }

  private:
    static void ThrowIfNotReturnCodeOK(wrReturnCode);

  private:
    explicit ActivityModelGroup(wrActivityModelGroup* ptr)
    : m_impl(ptr)
    {
    }

  private:
    std::unique_ptr<wrActivityModelGroup> m_impl;
};

inline void ActivityModelGroup::ThrowIfNotReturnCodeOK(wrReturnCode const retcode)
{
    if (retcode != wrReturnCode_OK)
    {
        throw utils::Exception(retcode);
    }
}


inline void ActivityModelGroup::ProcessFrame(unsigned char const* rowMajorBgrData,
                                             int imageWidth,
                                             int imageHeight)
{
    wrReturnCode retcode;
    ProcessFrame(rowMajorBgrData, imageWidth, imageHeight, retcode);

    ThrowIfNotReturnCodeOK(retcode);
}

inline void ActivityModelGroup::ProcessFrame(unsigned char const* rowMajorBgrData,
                                             int imageWidth,
                                             int imageHeight,
                                             wrReturnCode& outcode)
{
    outcode = wrActivityModelGroup_ProcessFrame(GetPtr(), rowMajorBgrData, imageWidth, imageHeight);
}

template<class PoseEstimator_t, typename sfinae>
void ActivityModelGroup::ProcessFrame(unsigned char const* rowMajorBgrData,
                                      int imageWidth,
                                      int imageHeight,
                                      PoseEstimator_t& poseEstimator)
{
    wrReturnCode retcode;
    ProcessFrame<PoseEstimator_t, sfinae>(
        rowMajorBgrData, imageWidth, imageHeight, poseEstimator, retcode);
    ThrowIfNotReturnCodeOK(retcode);
}

template<class PoseEstimator_t, typename sfinae>
void ActivityModelGroup::ProcessFrame(unsigned char const* rowMajorBgrData,
                                      int imageWidth,
                                      int imageHeight,
                                      PoseEstimator_t& poseEstimator,
                                      wrReturnCode& outcode)
{
    outcode = wrActivityModelGroup_ProcessFrameWithPoseEstimator(
        GetPtr(), rowMajorBgrData, imageWidth, imageHeight, poseEstimator.GetPtr());
}

template<class PoseEstimator_t, typename sfinae>
void ActivityModelGroup::ProcessPoses(PoseEstimator_t const& poseEstimator,
                                      int imageWidth,
                                      int imageHeight)
{
    wrActivityModelGroup_ProcessPoses(GetPtr(), poseEstimator.GetPtr(), imageWidth, imageHeight);
}

inline int ActivityModelGroup::NumSubmodels() const
{
    return wrActivityModelGroup_NumSubmodels(GetPtr());
}

inline ActivityModelView ActivityModelGroup::Submodel(int index) const
{
    return ActivityModelView(wrActivityModelGroup_Submodel(GetPtr(), index));
}

inline PoseEstimatorConstView ActivityModelGroup::PoseEstimatorOrNull() const
{
    return PoseEstimatorConstView{ wrActivityModelGroup_PoseEstimator(GetPtr()) };
}

inline PoseEstimatorView ActivityModelGroup::PoseEstimatorOrNull()
{
    return PoseEstimatorView{ wrActivityModelGroup_PoseEstimatorNonConst(GetPtr()) };
}

inline ActivityModelGroup::Builder& ActivityModelGroup::Builder::SetDeviceId(int deviceId)
{
    wrActivityModelGroupBuilder_SetDeviceId(GetPtr(), deviceId);
    return *this;
}

inline ActivityModelGroup::Builder& ActivityModelGroup::Builder::AddSubmodel(
    std::string const& modelPath)
{
    wrActivityModelGroupBuilder_AddSubmodel(GetPtr(), modelPath.c_str());
    return *this;
}

inline ActivityModelGroup::Builder& ActivityModelGroup::Builder::AddReflectedSubmodel(
    std::string const& modelPath)
{
    wrActivityModelGroupBuilder_AddReflectedSubmodel(GetPtr(), modelPath.c_str());
    return *this;
}

inline ActivityModelGroup ActivityModelGroup::Builder::BuildWithPoseEstimator(
    std::string const& poseModelDir, int desiredWidth, int desiredHeight) const
{
    wrActivityModelGroup* c_activityModelGroup{ nullptr };

    wrReturnCode const retcode = wrActivityModelGroupBuilder_BuildWithPoseEstimator(
        GetPtr(), &c_activityModelGroup, poseModelDir.c_str(), desiredWidth, desiredHeight);

    ThrowIfNotReturnCodeOK(retcode);

    return ActivityModelGroup{ c_activityModelGroup };
}

inline ActivityModelGroup ActivityModelGroup::Builder::BuildWithoutPoseEstimator() const
{
    wrActivityModelGroup* c_activityModelGroup{ nullptr };

    wrReturnCode const retcode
        = wrActivityModelGroupBuilder_BuildWithoutPoseEstimator(GetPtr(), &c_activityModelGroup);

    ThrowIfNotReturnCodeOK(retcode);

    return ActivityModelGroup{ c_activityModelGroup };
}

inline PoseEstimator ActivityModelGroup::Builder::BuildCompatiblePoseEstimator(
    std::string const& poseModelDir, int deviceId, int desiredWidth, int desiredHeight) const
{
    wrPoseEstimator* c_poseEstimator{ nullptr };

    wrReturnCode const retcode = wrActivityModelGroupBuilder_BuildCompatiblePoseEstimator(
        GetPtr(), &c_poseEstimator, poseModelDir.c_str(), deviceId, desiredWidth, desiredHeight);

    ThrowIfNotReturnCodeOK(retcode);

    return PoseEstimator{ c_poseEstimator };
}

inline PoseEstimatorOptions ActivityModelGroup::Builder::BuildCompatiblePoseEstimatorOptions() const
{
    wrPoseEstimatorOptions* c_poseEstimatorOptions{ nullptr };

    wrReturnCode const retcode = wrActivityModelGroupBuilder_BuildCompatiblePoseEstimatorOptions(
        GetPtr(), &c_poseEstimatorOptions);

    ThrowIfNotReturnCodeOK(retcode);

    return PoseEstimatorOptions{ c_poseEstimatorOptions };
}

inline ActivityPoseEstimatorRequirementsView ActivityModelGroup::PoseEstimatorRequirements() const
{
    return ActivityPoseEstimatorRequirementsView{ wrActivityModelGroup_Requirements(GetPtr()) };
}


}  // namespace wrnch

#endif /*WRNCH_ACTIVITY_MODEL_GROUP_CXX_API*/
