//
//  ZKCardView.m
//  BlackJack
//
//  Created by Tom on 2017/12/19.
//  Copyright © 2017年 YellowBoy. All rights reserved.
//

#import "ZKCardView.h"

@implementation ZKCardView
- (instancetype)initWithFrame:(CGRect)frame andBackViewName:(NSString *)imageName {
    self = [super initWithFrame:frame];
    if (self) {
        self.backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        self.backView.frame = self.bounds;
        
        self.frontView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_Card"]];
        self.frontView.frame = self.bounds;
        [self addSubview:self.frontView];
    }
    return self;
}

- (void)animateWithDuration:(NSTimeInterval)timeInterval translation:(CGRect)position {
    
}

- (void)animateWithDuration:(NSTimeInterval)timeInterval translationX:(CGFloat)x translationY:(CGFloat)y {
    [UIView animateWithDuration:timeInterval animations:^{
        //移动位置CGAffineTransformMakeTranslation(100, 100); 在原来基础上移动位置
        self.transform = CGAffineTransformMakeTranslation(x, y);
    }completion:^(BOOL finished) {
        [self transitionFlipFromLeftWithBlock:^{
            
        }];
    }];
}

//翻牌动画
- (void)transitionFlipFromLeftWithBlock:(void(^)(void))completion{
    [UIView transitionWithView:self duration:0.25 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        [self.frontView removeFromSuperview];
        [self addSubview:self.backView];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

//恢复翻牌
- (void)transitionFlipFromRightWithBlock:(void(^)(void))completion{
    [UIView transitionWithView:self duration:0.4 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        [self.backView removeFromSuperview];
        [self addSubview:self.frontView];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
