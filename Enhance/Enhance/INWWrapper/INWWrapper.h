//
//  OpenCVWrapper.h
//  OpenCV
//
//  Created by Dmytro Nasyrov on 5/1/17.
//  Copyright © 2017 Pharos Production Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface INWWrapper : NSObject

+(UIImage *)toGray:(UIImage *)source;

+(void)wrAPI_version;
+(int)wrAPI_sample_Joints;

@end
