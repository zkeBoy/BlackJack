//
//  UIImageView+Animation.m
//  BlackJack
//
//  Created by YellowBoy on 2017/12/18.
//  Copyright © 2017年 YellowBoy. All rights reserved.
//

#import "UIImageView+Animation.h"

@implementation UIImageView (Animation)
+ (void)imageView:(UIImageView *)imageView animationWithType:(ZKAnimationType)type completionHandler:(void(^)(void))completionHandler {
    if (type==ZKAnimationTypeScale) {
        [self imageView:imageView scaleAnimationWithCompletionHandler:completionHandler];
    }
}

+ (void)imageView:(UIImageView *)imageView scaleAnimationWithCompletionHandler:(void(^)(void))completionHandler {
    [UIView animateWithDuration:1 animations:^{
        imageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            imageView.transform = CGAffineTransformIdentity;
        }];
        if (completionHandler) {
            completionHandler ();
        }
    }];
}

@end
