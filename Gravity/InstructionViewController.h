//
//  InstructionViewController.h
//  Gravity
//
//  Created by Ryan McLeod on 9/22/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface InstructionViewController : UIViewController

@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *captionText;
@property (strong, nonatomic) NSString *bottomButtonText;
@property (copy,   nonatomic) VoidBlock buttonAction;

@end
