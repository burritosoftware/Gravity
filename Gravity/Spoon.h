//
//  Spoon.h
//  Gravity
//
//  Created by Ryan McLeod on 9/26/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Spoon : NSObject

@property (nonatomic, readonly) CGFloat spoonForce;
@property (strong, nonatomic, readonly) NSDictionary *calibrationForces;

- (void) recordBaseForce:(CGFloat)force;
- (void) recordCalibrationForce:(CGFloat)force forKnownWeight:(CGFloat)knownWeight;

- (CGFloat) spoonWeight;
- (CGFloat) weightFromForce:(CGFloat)force;
- (BOOL) isCalibrated;

@end
