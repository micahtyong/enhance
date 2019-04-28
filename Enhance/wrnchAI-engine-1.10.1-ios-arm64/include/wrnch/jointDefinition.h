/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/

#ifndef WRNCH_JOINT_DEFINITON_C_API
#define WRNCH_JOINT_DEFINITON_C_API

#include <wrnch/definitions.h>

#ifdef __cplusplus
extern "C" {
#endif

struct wrJointDefinition;
typedef const struct wrJointDefinition* wrJointDefinitionHandleConst;

WRNCH_DLL_INTERFACE wrJointDefinitionHandleConst wrJointDefinition_Get(const char* name);
WRNCH_DLL_INTERFACE unsigned int wrJointDefinition_GetNumDefinitions();
WRNCH_DLL_INTERFACE void wrJointDefinition_GetAvailableDefinitions(const char** namesList);

WRNCH_DLL_INTERFACE unsigned int wrJointDefinition_GetNumJoints(wrJointDefinitionHandleConst);
WRNCH_DLL_INTERFACE void wrJointDefinition_GetJointNames(wrJointDefinitionHandleConst,
                                                         char const** names);
WRNCH_DLL_INTERFACE unsigned int wrJointDefinition_GetNumBones(wrJointDefinitionHandleConst);
WRNCH_DLL_INTERFACE void wrJointDefinition_GetBonePairs(wrJointDefinitionHandleConst,
                                                        unsigned int* pairs);
WRNCH_DLL_INTERFACE int wrJointDefinition_GetJointIndex(wrJointDefinitionHandleConst,
                                                        const char* jointName);
WRNCH_DLL_INTERFACE const char* wrJointDefinition_GetName(wrJointDefinitionHandleConst);
WRNCH_DLL_INTERFACE void wrJointDefinition_PrintJointDefinition(wrJointDefinitionHandleConst);

#ifdef __cplusplus
}
#endif

#endif /* WRNCH_JOINT_DEFINITON_C_API */
