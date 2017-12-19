//
//  ZKCardView.h
//  BlackJack
//
//  Created by Tom on 2017/12/19.
//  Copyright © 2017年 YellowBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKCardView : UIView
@property (nonatomic, strong) UIImageView * frontView;
@property (nonatomic, strong) UIImageView * backView;

- (instancetype)initWithFrame:(CGRect)frame andBackViewName:(NSString *)imageName;
- (void)animateWithDuration:(NSTimeInterval)timeInterval translation:(CGRect)position;
- (void)animateWithDuration:(NSTimeInterval)timeInterval translationX:(CGFloat)x translationY:(CGFloat)y;
- (void)transitionFlipFromLeftWithBlock:(void(^)(void))completion;
- (void)transitionFlipFromRightWithBlock:(void(^)(void))completion;
@end
