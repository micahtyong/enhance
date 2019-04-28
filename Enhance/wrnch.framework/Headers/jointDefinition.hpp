/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/

#ifndef WRNCH_JOINT_DEFINITION_CXX_API
#define WRNCH_JOINT_DEFINITION_CXX_API

#include <wrnch/utils.hpp>
#include <wrnch/jointDefinition.h>

#include <new>
#include <stdexcept>


namespace wrnch
{
class JointDefinition
{
  public:
    JointDefinition()
    : m_impl(NULL)
    {
    }
    explicit JointDefinition(const wrJointDefinition* other)
    : m_impl(other)
    {
    }

    unsigned int GetNumJoints() const { return wrJointDefinition_GetNumJoints(CheckedGet()); }
    unsigned int GetNumJoints(wrReturnCode& code) const
    {
        CheckInitialized(code);
        if (code == wrReturnCode_OK)
        {
            return wrJointDefinition_GetNumJoints(m_impl);
        }

        return -1;
    }

    void GetJointNames(const char** outNames) const
    {
        wrJointDefinition_GetJointNames(CheckedGet(), outNames);
    }
    void GetJointNames(const char** outNames, wrReturnCode& code) const
    {
        CheckInitialized(code);
        if (code == wrReturnCode_OK)
        {
            wrJointDefinition_GetJointNames(m_impl, outNames);
        }
    }

    unsigned int GetNumBones() const { return wrJointDefinition_GetNumBones(CheckedGet()); }
    unsigned int GetNumBones(wrReturnCode& code) const
    {
        CheckInitialized(code);
        if (code == wrReturnCode_OK)
        {
            return wrJointDefinition_GetNumBones(CheckedGet());
        }
        return -1;
    }

    void GetBonePairs(unsigned int* pairs) const
    {
        wrJointDefinition_GetBonePairs(CheckedGet(), pairs);
    }
    void GetBonePairs(unsigned int* pairs, wrReturnCode& code) const
    {
        CheckInitialized(code);
        if (code == wrReturnCode_OK)
        {
            wrJointDefinition_GetBonePairs(Get(), pairs);
        }
    }

    int GetJointIndex(const char* jointName) const
    {
        int index = wrJointDefinition_GetJointIndex(CheckedGet(), jointName);
        utils::Check(index >= 0, "No known joint with name " + std::string(jointName));
        return index;
    }
    int GetJointIndex(const char* jointName, wrReturnCode& code) const
    {
        CheckInitialized(code);
        int index = -1;
        if (code == wrReturnCode_OK)
        {
            index = wrJointDefinition_GetJointIndex(CheckedGet(), jointName);
            if (index < 0)
            {
                code = wrReturnCode_JOINT_DEFINITION_ERROR;
            }
        }
        return index;
    }

    const char* GetName() const { return wrJointDefinition_GetName(CheckedGet()); }
    const char* GetName(wrReturnCode& code) const
    {
        CheckInitialized(code);
        if (code == wrReturnCode_OK)
        {
            return wrJointDefinition_GetName(Get());
        }
        return NULL;
    }

    void PrintJointDefinition() const { wrJointDefinition_PrintJointDefinition(CheckedGet()); }
    void PrintJointDefinition(wrReturnCode& code) const
    {
        CheckInitialized(code);
        if (code == wrReturnCode_OK)
        {
            wrJointDefinition_PrintJointDefinition(CheckedGet());
        }
    }

    const wrJointDefinition* Get() const { return m_impl; }

    const wrJointDefinition* CheckedGet() const
    {
        const wrJointDefinition* ptr = Get();
        utils::Check(ptr != NULL, "Attempting to access uninitialized JointDefinition");
        return ptr;
    }
    const wrJointDefinition* CheckedGet(wrReturnCode& code) const
    {
        const wrJointDefinition* ptr = Get();
        code = (ptr == NULL) ? wrReturnCode_JOINT_DEFINITION_ERROR : wrReturnCode_OK;
        return ptr;
    }

  private:
    const wrJointDefinition* m_impl;
    void CheckInitialized(wrReturnCode& code) const
    {
        code = (m_impl == NULL) ? wrReturnCode_JOINT_DEFINITION_ERROR : wrReturnCode_OK;
    }
};

struct JointDefinitionRegistry
{
    static JointDefinition Get(const char* name)
    {
        const wrJointDefinition* ptr = wrJointDefinition_Get(name);
        utils::Check(ptr != NULL, "No known joint definition with name " + std::string(name));
        return JointDefinition(ptr);
    }
    static JointDefinition Get(const char* name, wrReturnCode& code)
    {
        const wrJointDefinition* ptr = wrJointDefinition_Get(name);
        code = (ptr == NULL) ? wrReturnCode_JOINT_DEFINITION_ERROR : wrReturnCode_OK;
        return JointDefinition(ptr);
    }
    static unsigned int GetNumDefinitions() { return wrJointDefinition_GetNumDefinitions(); }
    static void GetAvailableDefinitions(const char** definitionsList)
    {
        wrJointDefinition_GetAvailableDefinitions(definitionsList);
    }
};
}

#endif /* WRNCH_JOINT_DEFINITION_CXX_API */
