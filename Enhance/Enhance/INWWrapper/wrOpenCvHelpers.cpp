/*
 Copyright (c) 2018 Wrnch Inc.
 All rights reserved
*/

#include "wrOpenCvHelpers.h"
/*
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>

extern "C" {

wrReturnCode wrCvMat_LoadImage(const char* filename, wrCvMatHandle* handle)
{
    try {
        cv::Mat mat = cv::imread(filename);
        if (!mat.data) {
            return wrReturnCode_PATH_ERROR;
        }
        *handle = reinterpret_cast<wrCvMatHandle>(new cv::Mat(mat));
    }
    catch (const std::bad_alloc&) {
        return wrReturnCode_BAD_ALLOC;
    }
    catch (...) {
        return wrReturnCode_OTHER_ERROR;
    }
    return wrReturnCode_OK;
}


void wrCvMat_Release(wrCvMatHandle handle) { delete reinterpret_cast<cv::Mat*>(handle); }

const unsigned char* wrCvMat_GetData(wrCvMatHandleConst handle) {
    return reinterpret_cast<const cv::Mat*>(handle)->data;
}


int wrCvMat_GetCols(wrCvMatHandleConst handle) {
    return reinterpret_cast<const cv::Mat*>(handle)->cols;
}

int wrCvMat_GetRows(wrCvMatHandleConst handle) {
    return reinterpret_cast<const cv::Mat*>(handle)->rows;
}


}
*/
