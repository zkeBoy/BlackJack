//
//  ZKScoreView.h
//  BlackJack
//
//  Created by Tom on 2017/12/26.
//  Copyright © 2017年 YellowBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, coinType) {
    coinTypeScore = 1,
    coinTypeCoin  = 2
};

@interface ZKScoreView : UIView
@property (nonatomic, strong) UIImageView * backgroundView;
@property (nonatomic, strong) UILabel     * scoreLabel;
@property (nonatomic, assign) NSInteger     type;
- (instancetype)initWithFrame:(CGRect)frame andType:(coinType)type;
@end
