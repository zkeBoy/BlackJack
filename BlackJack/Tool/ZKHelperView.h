//
//  ZKHelperView.h
//  BlackJack
//
//  Created by Tom on 2017/12/20.
//  Copyright © 2017年 YellowBoy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, resultType) {
    resultTypeWin  = 0,
    resultTypeLose = 1,
    resultTypePush = 2,
    resultTypeLack = 3 //金币不足
};

@interface ZKHelperView : UIView

- (void)showResultWithType:(resultType)type toView:(UIView *)view hiddenBlock:(void(^)(void))hidden;
- (void)showResultWithType:(resultType)type hiddenBlock:(void(^)(void))hidden;

@end
