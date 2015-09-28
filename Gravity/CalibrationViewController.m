//
//  CalibrationViewController.m
//  Gravity
//
//  Created by Ryan McLeod on 9/27/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "CalibrationViewController.h"
#import "CKShapeView.h"
#import "SpoonView.h"
#import "Masonry.h"
#import "GhostButton.h"
#import "UIStackView+RemoveAllArrangedSubviews.h"
#import "CoinInfo.h"

@interface CalibrationViewController ()

typedef NS_ENUM(NSInteger, CalibrationStep) {
    CalibrationStepLayFlat,
    CalibrationStepWeighSpoon,
    CalibrationStepAddCoins,
    CalibrationStepFinish
};

@property (nonatomic) CalibrationStep calibrationStep;

@property (strong, nonatomic) Spoon *spoon;

@property (strong, nonatomic) WeighArea *weighArea;

@property (strong, nonatomic) UIView *statusBarBackground;
@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) UILabel *topLabel;
@property (strong, nonatomic) CKShapeView *spoonView;
@property (strong, nonatomic) UILabel *bottomLabel;
@property (strong, nonatomic) CoinHolder *coins;

@property (strong, nonatomic) UIStackView *buttonBar;
@property (strong, nonatomic) UIView *buttonSpacer1;
@property (strong, nonatomic) UIView *buttonSpacer2;
@property (strong, nonatomic) GhostButton *nextButton;
@property (strong, nonatomic) GhostButton *resetButton;
@property (strong, nonatomic) GhostButton *finishButton;

@end


@implementation CalibrationViewController

//static CGFloat const staleTimestampThreshold = 0.2;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.spoon = [Spoon new];
    
    [self.view setBackgroundColor:[UIColor gravityPurple]];
    
    self.statusBarBackground = [UIView new];
    [self.statusBarBackground setBackgroundColor:[UIColor gravityPurpleDark]];
    [self.view addSubview:self.statusBarBackground];
    
    UILabel *headerLabel = [UILabel new];
    headerLabel.backgroundColor = [UIColor gravityPurpleDark];
    [headerLabel setTextColor:[UIColor gravityPurple]];
    [headerLabel setFont:[UIFont fontWithName:AvenirNextDemiBold size:22]];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setNumberOfLines:0];
    [headerLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.headerLabel = headerLabel;
    [self.view addSubview:self.headerLabel];

    UILabel *topLabel = [UILabel new];
    [topLabel setTextColor:[UIColor whiteColor]];
    [topLabel setFont:[UIFont fontWithName:AvenirNextDemiBold size:22]];
    [topLabel setTextAlignment:NSTextAlignmentCenter];
    [topLabel setNumberOfLines:0];
    [topLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.topLabel = topLabel;
    [self.view addSubview:self.topLabel];
    
    CKShapeView *spoonView = [SpoonView new];
    self.spoonView = spoonView;
    [self.view addSubview:self.spoonView];
    
    UILabel *bottomLabel = [UILabel new];
    [bottomLabel setTextColor:[UIColor whiteColor]];
    [bottomLabel setFont:[UIFont fontWithName:AvenirNextDemiBold size:22]];
    [bottomLabel setTextAlignment:NSTextAlignmentCenter];
    [bottomLabel setNumberOfLines:0];
    [bottomLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.bottomLabel = bottomLabel;
    [self.view addSubview:self.bottomLabel];
    
    
    self.coins = [[CoinHolder alloc] initWithFrame:CGRectZero coinType:CoinTypeUSQuarter numCoins:4];
    self.coins.coinSelectionDelegate = self;
    [self.view addSubview:self.coins];
    
    [self setupButtonBar];
    
    
    // Weigh area
    self.weighArea = [WeighArea new];
    self.weighArea.weightAreaDelegate = self;
    [self.view addSubview:self.weighArea];
    


    
    [self setupViewConstraints];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self resetCalibration];
    [self setCalibrationStep:CalibrationStepLayFlat];
    
    [self.headerLabel setText:@"Set device on flat surface"];
}

- (void) setupButtonBar {
    UIStackView *buttonBar = [UIStackView new];
    [buttonBar setAlignment:UIStackViewAlignmentCenter];
    [buttonBar setAxis:UILayoutConstraintAxisHorizontal];
    [buttonBar setDistribution:UIStackViewDistributionEqualSpacing];
    [buttonBar setSpacing:30];
    self.buttonBar = buttonBar;

    GhostButton *nextButton = [GhostButton new];
    nextButton.fillColor = [UIColor gravityPurple];
    nextButton.borderColor = [UIColor whiteColor];
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    self.nextButton = nextButton;

    GhostButton *resetButton = [GhostButton new];
    resetButton.fillColor = [UIColor gravityPurple];
    resetButton.borderColor = [UIColor gravityPurpleDark];
    [resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    self.resetButton = resetButton;
    
    GhostButton *finishButton = [GhostButton new];
    finishButton.fillColor = [UIColor whiteColor];
    finishButton.borderColor = [UIColor gravityPurple];
    [finishButton setTitle:@"Finish" forState:UIControlStateNormal];
    self.finishButton = finishButton;
    
    [self.view addSubview:self.buttonBar];
}

- (void) setupViewConstraints {
    
    [self.statusBarBackground makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.mas_topLayoutGuideBottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [self.headerLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusBarBackground.bottom);
        make.topMargin.equalTo(self.mas_topLayoutGuideBottom).multipliedBy(2).priorityHigh();
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(55));
    }];
    
    [self.topLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerLabel.bottom);
        make.bottom.equalTo(self.spoonView.top);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [self.spoonView makeConstraints:^(MASConstraintMaker *make) {
        // Try to guarantee that the center of the spoon bowl is in the center of the screen
        make.left.equalTo(self.view.centerX).with.offset(-132);
        // Approximately the height of the bottom buttons in the main view
        make.centerY.equalTo(self.view).with.offset(-62);
    }];
    
    [self.bottomLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.spoonView.bottom);
        make.bottom.equalTo(self.coins.top);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [self.coins makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLabel.bottom);
        make.bottom.equalTo(self.buttonBar.top);
        make.centerX.equalTo(self.view);
        make.height.lessThanOrEqualTo(@100);
        make.height.equalTo(self.view).priorityLow();
        make.width.equalTo(self.view).with.offset(-20);
    }];
    
    [self.buttonBar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).priorityHigh();
        make.centerX.equalTo(self.view);
        make.height.lessThanOrEqualTo(@100);
    }];
    
    
    // Transparent weigh area
    [self.weighArea makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerLabel.bottom);
        make.bottom.equalTo(self.coins.top);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
}

#pragma mark - Calibration State

- (void) setCalibrationStep:(CalibrationStep)calibrationStep {
    _calibrationStep = calibrationStep;

    switch (calibrationStep) {
            
        case CalibrationStepLayFlat:
        {
            NSLog(@">> Lay Flat");
            
            [self.headerLabel setTextColor:[UIColor whiteColor]];
            
            [self.buttonBar removeAllArrangedSubviewsFromSuperView];
            [self.buttonBar addArrangedSubview:self.nextButton];

            [self.nextButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [self.nextButton addTarget:self action:@selector(phoneHasBeenLayedFlat) forControlEvents:UIControlEventTouchUpInside];
            
            [self.topLabel setText:@""];
            [self.coins setHidden:YES];
            [self.bottomLabel setText:@""];
            
            break;
        }
            
        case CalibrationStepWeighSpoon:
        {
            NSLog(@">> Weigh Spoon");
            
            [self.headerLabel setTextColor:[UIColor gravityPurple]];

            [self.nextButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [self.nextButton addTarget:self action:@selector(recordSpoonForce) forControlEvents:UIControlEventTouchUpInside];
            
            [self.buttonBar removeAllArrangedSubviewsFromSuperView];
            [self.buttonBar addArrangedSubview:self.nextButton];
            
            [self.topLabel setText:@"Gently place spoon below"];
            [self.coins setHidden:YES];
            [self.bottomLabel setText:@""];
            
            break;
        }
            
        case CalibrationStepAddCoins:
        {
            NSLog(@">> Add Coins");
            
            [self.headerLabel setTextColor:[UIColor gravityPurple]];

            [self.resetButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [self.resetButton addTarget:self action:@selector(resetCalibration) forControlEvents:UIControlEventTouchUpInside];

            [self.buttonBar removeAllArrangedSubviewsFromSuperView];
            [self.buttonBar addArrangedSubview:self.resetButton];
            
            [self.topLabel setText:@""];
            [self.coins setHidden:NO];
            [self.bottomLabel setText:@"Place one quarter into the spoon and press the icon below"];

            break;
        }
            
        case CalibrationStepFinish:
        {
            NSLog(@">> Done");
            
            [self.headerLabel setTextColor:[UIColor gravityPurple]];

            [self.resetButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [self.resetButton addTarget:self action:@selector(resetCalibration) forControlEvents:UIControlEventTouchUpInside];

            [self.finishButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [self.finishButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];

            [self.buttonBar removeAllArrangedSubviewsFromSuperView];
            [self.buttonBar addArrangedSubview:self.resetButton];
            [self.buttonBar addArrangedSubview:self.finishButton];
            
            [self.topLabel setText:@""];
            [self.coins setHidden:NO];
            [self.bottomLabel setText:@"Very good"];

            break;
        }
    }
}

#pragma mark - Button actions

- (void) phoneHasBeenLayedFlat {
    [self setCalibrationStep:CalibrationStepWeighSpoon];
}

- (void) resetCalibration {
    self.spoon = [Spoon new];
    [self.coins reset];
    [self setCalibrationStep:CalibrationStepLayFlat];
}

#pragma mark - Calibration actions

- (void) recordSpoonForce {
    
    // record it
    UITouch *lastActiveTouch = self.weighArea.lastActiveTouch;
//    CGFloat systemUptime = [[NSProcessInfo processInfo] systemUptime];
//    if ((systemUptime - touch.timestamp) < staleTimestampThreshold) {
    if (lastActiveTouch) {
        [self.spoon recordBaseForce:lastActiveTouch.force];
        //    [self.spoon recordCalibrationForce:0 forKnownWeight:0];

        [self setCalibrationStep:CalibrationStepAddCoins];
    }
    else {
//        NSLog(@"Record spoon weight: touch was stale by %fs", (systemUptime - lastActiveTouch.timestamp));

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No spoon?" message:@"Gravity isn't detecting a metal spoon on the screen. Try slightly dampening the back of the spoon or trying a new spoon!" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [alert dismissViewControllerAnimated:YES completion:^{}];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }

    
}



- (void) done {
    [self.spoonCalibrationDelegate spoonCalibrated:self.spoon];
    
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

#pragma mark - WeighAreaEventDelegate

- (void) singleTouchDetectedWithForce:(CGFloat)force maximumPossibleForce:(CGFloat)maxiumPossibleForce {
    [self.weighArea setBackgroundColor:[UIColor clearColor]];
}

- (void) multipleTouchesDetected {
    [self.weighArea setBackgroundColor:[UIColor roverRed]];
}

#pragma mark CoinSelectionDelegate

- (void) coinSelected:(NSUInteger)coinIndex {
    
    // record it
    CGFloat knownWeight = (coinIndex+1) * [CoinInfo knownWeightForCoinType:[self.coins coinType]];
    
    UITouch *lastActiveTouch = self.weighArea.lastActiveTouch;
//    CGFloat systemUptime = [[NSProcessInfo processInfo] systemUptime];
//    if ((systemUptime - touch.timestamp) < staleTimestampThreshold) {
    if (lastActiveTouch) {
            [self.spoon recordCalibrationForce:lastActiveTouch.force forKnownWeight:knownWeight];
    }
    else {
//        NSLog(@"Record coin %d: touch was stale by %fs", (int)(coinIndex+1), (systemUptime - touch.timestamp));
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No spoon?" message:@"Gravity isn't detecting a metal spoon on the screen. Try slightly dampening the back of the spoon or trying a new spoon!" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ignore" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Restart Calibration" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            [alert dismissViewControllerAnimated:YES completion:nil];
            [self resetCalibration];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    // HACK
    if (coinIndex == ([self.coins numCoins] - 1)) {
        [self setCalibrationStep:CalibrationStepFinish];
    }
}

#pragma mark Status Bar

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end