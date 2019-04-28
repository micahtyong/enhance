/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/

#ifndef WRNCH_DEFINITIONS
#define WRNCH_DEFINITIONS

#if !defined(WRNCH_DLL_INTERFACE)
#if defined(_WIN32) && defined(WRNCH_API_SHARED)
#ifdef WRNCH_DLL_EXPORT
#define WRNCH_DLL_INTERFACE __declspec(dllexport)
#else
#define WRNCH_DLL_INTERFACE __declspec(dllimport)
#endif
#else
#define WRNCH_DLL_INTERFACE
#endif
#endif


#endif /* WRNCH_DEFINITIONS */
