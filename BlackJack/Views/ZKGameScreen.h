//
//  ZKGameSceen.h
//  BlackJack
//
//  Created by YellowBoy on 2017/12/17.
//  Copyright © 2017年 YellowBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, clickType) {
    clickTypeEnd = 0,
    clickTypeBet = 1,
    clickTypeDouble = 2,
    clickTypeStop = 3,
    clickTypeMore = 4
};

@interface ZKGameScreen : UIView

@end
