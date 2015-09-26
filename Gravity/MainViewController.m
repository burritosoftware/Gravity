//
//  ViewController.m
//  Gravity
//
//  Created by Ryan McLeod on 9/22/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "MainViewController.h"
#import "InstructionsViewController.h"
#import "WeighArea.h"
#import "UIImage+ImageWithColor.h"
#define MAS_SHORTHAND
#import "Masonry.h"
#import "UIColor+Additions.h"

@interface MainViewController ()

@property (strong, nonatomic) InstructionsViewController *instructions;

@property (strong, nonatomic) WeighArea *weighArea;
@property (strong, nonatomic) UILabel *debugLabel;
@property (strong, nonatomic) UILabel *outputLabel;
@property (strong, nonatomic) UIButton *tareButton;
@property (strong, nonatomic) UIButton *unitsButton;

@end


@implementation MainViewController

static const CGFloat outputLabelMinHeight = 65;
static const CGFloat outputLabelMaxHeight = 80;

static const CGFloat buttonsMinHeight = 50;
static const CGFloat buttonsMaxHeight = 75;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scale = [Scale new];
    [self.scale setScaleDisplayDelegate:self];
    

    self.weighArea = [WeighArea new];
    self.weighArea.weightAreaDelegate = self;
    [self.view addSubview:self.weighArea];
    
    #ifdef DEBUG
    UILabel *debugLabel = [UILabel new];
    [debugLabel setBackgroundColor:[[UIColor gravityPurple] colorWithAlphaComponent:0.9]];
    [debugLabel setFont:[UIFont fontWithName:AvenirNextDemiBold size:14]];
    [debugLabel setTextColor:[UIColor whiteColor]];
    [debugLabel setTextAlignment:NSTextAlignmentLeft];
    [debugLabel setNumberOfLines:0];
    [debugLabel setAdjustsFontSizeToFitWidth:YES];
    self.debugLabel = debugLabel;
    [self.debugLabel setText:@"--"];
    [self.view addSubview:self.debugLabel];
    #endif
    
    UILabel *outputLabel = [UILabel new];
    [outputLabel setBackgroundColor:[UIColor gravityPurple]];
    [outputLabel setFont:[UIFont fontWithName:AvenirNextDemiBold size:36]];
    [outputLabel setTextColor:[UIColor whiteColor]];
    [outputLabel setTextAlignment:NSTextAlignmentCenter];
    [outputLabel setNumberOfLines:1];
    [outputLabel setAdjustsFontSizeToFitWidth:YES];
    self.outputLabel = outputLabel;
    [self.outputLabel setText:@"--"];
    [self.view addSubview:self.outputLabel];
    
    UIButton *tareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tareButton setBackgroundImage:[UIImage imageWithColor:[UIColor roverRed]] forState:UIControlStateNormal];
    [tareButton setBackgroundImage:[UIImage imageWithColor:[[UIColor roverRed] add_colorWithBrightness:0.8]] forState:UIControlStateHighlighted];
    [tareButton.titleLabel setFont:[UIFont fontWithName:AvenirNextDemiBold size:24]];
    [tareButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [tareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tareButton setTitle:@"tare" forState:UIControlStateNormal];
    [tareButton addTarget:self.scale action:@selector(tare) forControlEvents:UIControlEventTouchUpInside];
    self.tareButton = tareButton;
    [self.view addSubview:tareButton];
    
    UIButton *unitsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [unitsButton setBackgroundImage:[UIImage imageWithColor:[UIColor lunarLilac]] forState:UIControlStateNormal];
    [unitsButton setBackgroundImage:[UIImage imageWithColor:[[UIColor lunarLilac] add_colorWithBrightness:0.75]] forState:UIControlStateHighlighted];
    [unitsButton.titleLabel setFont:[UIFont fontWithName:AvenirNextDemiBold size:24]];
    [unitsButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [unitsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [unitsButton setTitle:@"units" forState:UIControlStateNormal];
    [unitsButton addTarget:self.scale action:@selector(switchUnits) forControlEvents:UIControlEventTouchUpInside];
    self.unitsButton = unitsButton;
    [self.view addSubview:unitsButton];
    
    
    self.instructions = [self.storyboard instantiateViewControllerWithIdentifier:@"InstructionsViewController"];
    
    [self createConstraints];
}

- (void) createConstraints {
    
    [self.weighArea makeConstraints:^(MASConstraintMaker *make) {
        UIView *topLayoutGuide = (UIView*)self.topLayoutGuide;
        make.top.equalTo(topLayoutGuide.bottom);
        #ifdef DEBUG
        make.bottom.equalTo(self.debugLabel.top);
        #else
        make.bottom.equalTo(self.outputLabel.top);
        #endif
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [self.tareButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.5);
        
        make.height.equalTo(self.view.height).priorityHigh();
        make.height.lessThanOrEqualTo(@(buttonsMaxHeight));
        make.height.greaterThanOrEqualTo(@(buttonsMinHeight));
    }];
    
    [self.unitsButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.equalTo(self.view.width).multipliedBy(0.5);

        make.height.equalTo(self.view.height).priorityHigh();
        make.height.lessThanOrEqualTo(@(buttonsMaxHeight));
        make.height.greaterThanOrEqualTo(@(buttonsMinHeight));
    }];
    
    [self.outputLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.tareButton.top);
        
        make.height.equalTo(self.view.height).priorityHigh();
        make.height.lessThanOrEqualTo(@(outputLabelMaxHeight));
        make.height.greaterThanOrEqualTo(@(outputLabelMinHeight));
    }];
    
    #ifdef DEBUG
    [self.debugLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.outputLabel.top);
    }];
    #endif
}

- (void) viewDidAppear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:InstructionsCompleted] boolValue]) {
        [self showIntroAnimated:NO];
    }
    
    [self.scale setCurrentForce:4.123991991234];
}

#pragma mark ScaleDisplayDelegate

- (void) displayStringDidChange:(NSString*)displayString {
    [self.outputLabel setText:displayString];
}

#pragma mark WeighAreaEventsDelegate

- (void) singleTouchDetectedWithForce:(CGFloat)force maximumPossibleForce:(CGFloat)maxiumPossibleForce {
    self.weighArea.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
    [self.scale setCurrentForce:force];
}

- (void) multipleTouchesDetected {
    self.weighArea.backgroundColor = [UIColor redColor];
}

- (void) debugDataUpdated:(NSString*)debugData {
    [self.debugLabel setText:debugData];
}

#pragma mark UI Updating

- (void) setCurrentWeight:(CGFloat)grams {
    static NSMassFormatter *massFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        massFormatter = [NSMassFormatter new];
        [massFormatter setUnitStyle:NSFormattingUnitStyleShort];
    });
    
    NSString *massString = [massFormatter stringFromValue:grams unit:NSMassFormatterUnitGram];
    
    [self.outputLabel setText:massString];
}

#pragma mark Intro

- (void) showIntroAnimated:(BOOL)animated {
    [self presentViewController:self.instructions animated:animated completion:nil];
}

- (void) resetIntro {
    [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:InstructionsCompleted];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self showIntroAnimated:YES];
}

#pragma mark Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Status Bar

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark Shaking
-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self resetIntro];
    }
}

#pragma mark Trait Collection
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    UIForceTouchCapability forceTouchCapability = [self.traitCollection forceTouchCapability];
    switch (forceTouchCapability) {
        case UIForceTouchCapabilityUnknown:
            NSLog(@"Force Touch support unknown");
            break;
        case UIForceTouchCapabilityUnavailable:
            NSLog(@"Force Touch unavailable");
            break;
        case UIForceTouchCapabilityAvailable:
            NSLog(@"Force Touch enabled");
            break;
    }
    
    if (forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self.weighArea setForceAvailable:YES];
    } else {
        [self.weighArea setForceAvailable:NO];
    }
}

@end
