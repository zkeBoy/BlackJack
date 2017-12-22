//
//  UIImageView+Animation.h
//  BlackJack
//
//  Created by YellowBoy on 2017/12/18.
//  Copyright © 2017年 YellowBoy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ZKAnimationType) {
    ZKAnimationTypeScale = 0, //放大动画,0.25秒之后恢复原样
    ZKAnimationTypeTrans = 1  //旋转动画
};

@interface UIImageView (Animation)
+ (void)imageView:(UIImageView *)imageView animationWithType:(ZKAnimationType)type completionHandler:(void(^)(void))completionHandler;
@end
