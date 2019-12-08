//
//  OpenCVWrapper.h
//  diplomaiOS
//
//  Created by Mary Gerina on 12/8/19.
//  Copyright © 2019 Mary Gerina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

+ (NSString *)openCVVersionString;
+ (UIImage *)detect:(UIImage *)source;

@end

NS_ASSUME_NONNULL_END
