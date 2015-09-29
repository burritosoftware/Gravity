//
//  TitleViewController.m
//  Gravity
//
//  Created by Ryan McLeod on 9/29/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "TitleViewController.h"
#import <POP.h>

@implementation TitleViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        UIFont *normalCaptionFont = [UIFont fontWithName:AvenirNextMedium size:24];
        UIFont *boldCaptionFont = [UIFont fontWithName:AvenirNextBold size:24];
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        
        
        NSMutableAttributedString *attributedTextCaption1 = [[NSMutableAttributedString alloc] initWithString:@"Gravity"
                                                                                                   attributes:@{
                                                                                                                NSFontAttributeName: boldCaptionFont,
                                                                                                                NSParagraphStyleAttributeName: paragraphStyle,
                                                                                                                NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                                                }];
        
        [attributedTextCaption1 appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" turns your iPhone 6s into a digital scale."
                                                                                              attributes:@{
                                                                                                           NSFontAttributeName: normalCaptionFont,
                                                                                                           NSParagraphStyleAttributeName: paragraphStyle,
                                                                                                           NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.9]
                                                                                                           }]];
        [self.contentTextView setAttributedText:attributedTextCaption1];
        
        [self setContinueButtonText:@"Continue"];
        [self.continueButton setAlpha:0];
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    POPBasicAnimation *fadeIn = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    fadeIn.toValue = @(1);
    fadeIn.duration = 1.5;
    fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    fadeIn.beginTime = CACurrentMediaTime() + 1.5;
    
    POPBasicAnimation *scaleIn = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleIn.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.9, 0.9)];
    scaleIn.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    scaleIn.duration = fadeIn.duration;
    scaleIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    scaleIn.beginTime = fadeIn.beginTime;

    [self.continueButton pop_addAnimation:fadeIn forKey:@"fadeIn"];
    [self.continueButton pop_addAnimation:scaleIn forKey:@"scaleIn"];
}

@end
