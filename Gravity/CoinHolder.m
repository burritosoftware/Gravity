
//  CoinHolder.m
//  Gravity
//
//  Created by Ryan McLeod on 9/26/15.
//  Copyright © 2015 Ryan McLeod. All rights reserved.
//

#import "CoinHolder.h"
#import "CoinButton.h"
#import "Masonry.h"

@interface CoinHolder ()
    @property (strong, nonatomic) NSArray *coinButtons;
    @property (nonatomic) NSUInteger activeCoinButtonIndex;
@end

@implementation CoinHolder

static const CGFloat coinSpacing = 20;

- (instancetype) initWithFrame:(CGRect)frame coinType:(CoinType)coinType numCoins:(NSUInteger)numCoins {
    self = [super initWithFrame:frame];
    if (self) {
        
        _coinType = coinType;
        _numCoins = numCoins;
        
        [self setAxis:UILayoutConstraintAxisHorizontal];
        [self setAlignment:UIStackViewAlignmentCenter];
        [self setDistribution:UIStackViewDistributionFillEqually];

        [self setLayoutMarginsRelativeArrangement:YES];
        [self setLayoutMargins:UIEdgeInsetsMake(0, coinSpacing, 0, coinSpacing)];

        [self setSpacing:coinSpacing];
        
        self.coinButtons = [NSArray new];
        
        for (int ctr = 0; ctr < numCoins; ctr++) {
            CoinButton *coinButton = [CoinButton buttonWithCoinType:CoinTypeUSQuarter fillColor:[UIColor gravityPurple] accentColor:[UIColor whiteColor] disabledAccentColor:[UIColor gravityPurpleDark]];
            
            [coinButton makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(coinButton.width);
            }];
            
            [coinButton setAction:^{
                [self coinSelected:ctr];
            }];
            
            self.coinButtons = [self.coinButtons arrayByAddingObject:coinButton];
            [self addArrangedSubview:coinButton];
        }
        
        [self setActiveCoinButtonIndex:0];
    }
    return self;
}

- (void) coinSelected:(NSUInteger)coinIndex {
    NSLog(@"Coin Selected: %ld", coinIndex);
    [self.coinSelectionDelegate coinSelected:coinIndex];
    self.activeCoinButtonIndex++;
}

- (void) setActiveCoinButtonIndex:(NSUInteger)activeCoinButtonIndex {
    _activeCoinButtonIndex = activeCoinButtonIndex;
    
    for (int ctr = 0; ctr < self.numCoins; ctr++) {
        [self.coinButtons[ctr] setEnabled:(ctr <= activeCoinButtonIndex)];
        [self.coinButtons[ctr] setUserInteractionEnabled:(ctr == activeCoinButtonIndex)];
    }
}

- (void) reset {
    
    // Reset userInteractionEnabled and enabled for all buttons
    self.activeCoinButtonIndex = 0;
    
    // Unselect all buttons
    for (CoinButton *coinButton in self.coinButtons) {
        [coinButton setSelected:NO];
    }
}

@end