//
//  Scale.h
//  Gravity
//
//  Created by Ryan McLeod on 9/23/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - ScaleDisplayDelegate
// -----------------------------------------------

@protocol ScaleDisplayDelegate <NSObject>

- (void) displayStringDidChange:(NSString*)displayString;

@end

#pragma mark - Scale
// -----------------------------------------------

@interface Scale : NSObject

// The system reported force maximum value
@property (nonatomic) CGFloat maximumPossibleForce;
// The current force from a touch
@property (nonatomic) CGFloat currentForce;
// The current set tare in grams
@property (nonatomic, readonly) CGFloat tareMass;
// The current estimated mass in grams.
@property (nonatomic, readonly) CGFloat currentMass;

@property (weak, nonatomic) id<ScaleDisplayDelegate> scaleDisplayDelegate;

- (void) tare;
- (void) switchUnits;

@end