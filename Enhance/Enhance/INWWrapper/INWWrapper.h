//
//  OpenCVWrapper.h
//  OpenCV
//
//  Created by Dmytro Nasyrov on 5/1/17.
//  Copyright © 2017 Pharos Production Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface INWWrapper : NSObject

+(UIImage *)toGray:(UIImage *)source;

+(void)wrAPI_version;
+(int)wrAPI_sample_Joints;

-(void) matrixMin: (double *) data
        data_size:(int)data_size
        data_rows:(int)data_rows
        heat_rows:(int)heat_rows;

-(void) maximum_filter: (double *) data
             data_size:(int)data_size
             data_rows:(int)data_rows
             mask_size:(int)mask_size
             threshold:(double)threshold;

-(UIImage*) renderKeyPoint:(CGRect) bounds
                  keypoint:(int*) keypoint
             keypoint_size:(int) keypoint_size
                       pos:(CGPoint*) pos;

@end
