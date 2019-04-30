//
//  OpenCVWrapper.m
//  OpenCV
//
//  Created by Dmytro Nasyrov on 5/1/17.
//  Copyright © 2017 Pharos Production Inc. All rights reserved.
//


#ifdef __cplusplus
    #import <wrnch/engine.hpp>
    #import <opencv2/opencv.hpp>
    #import "INWWrapper.h"
    #import "wrHelpers.h"
#endif

using namespace std;
using namespace cv;
using namespace wrnch;


@implementation INWWrapper

#pragma mark Public

+ (void)wrAPI_version {
//    cout << "Version: " << WRNCH_ENGINE_API_VERSION ;
}

+(int)wrAPI_sample_Joints {
    wrReturnCode licenseCheckCode = wrnch::LicenseCheck();
    return inw_Test1();
}

+ (UIImage *)toGray:(UIImage *)source {
    cout << "OpenCV: ";
    return [INWWrapper _imageFrom:[INWWrapper _grayFrom:[INWWrapper _matFrom:source]]];
}

#pragma mark Private

+ (Mat)_grayFrom:(Mat)source {
    cout << "-> grayFrom ->";
    Mat result;
    cvtColor(source, result, COLOR_BGR2GRAY);
    return result;
}

+ (Mat)_matFrom:(UIImage *)source {
    cout << "matFrom ->";
    CGImageRef image = CGImageCreateCopy(source.CGImage);
    CGFloat cols = CGImageGetWidth(image);
    CGFloat rows = CGImageGetHeight(image);
    Mat result(rows, cols, CV_8UC4);
    CGBitmapInfo bitmapFlags = kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault;
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = result.step[0];
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image);
    CGContextRef context = CGBitmapContextCreate(result.data, cols, rows, bitsPerComponent, bytesPerRow, colorSpace, bitmapFlags);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, cols, rows), image);
    CGContextRelease(context);
    return result;
}

+ (UIImage *)_imageFrom:(Mat)source {
    cout << "-> imageFrom\n";
    NSData *data = [NSData dataWithBytes:source.data length:source.elemSize() * source.total()];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGBitmapInfo bitmapFlags = kCGImageAlphaNone | kCGBitmapByteOrderDefault;
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = source.step[0];
    CGColorSpaceRef colorSpace = (source.elemSize() == 1 ? CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB());
    CGImageRef image = CGImageCreate(source.cols, source.rows, bitsPerComponent, bitsPerComponent * source.elemSize(), bytesPerRow, colorSpace, bitmapFlags, provider, NULL, false, kCGRenderingIntentDefault);
    UIImage *result = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    return result;
}

@end
