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
@protocol ZKGameScreenDelegate;
@interface ZKGameScreen : UIView
@property (nonatomic, weak) id <ZKGameScreenDelegate> delegate;

- (void)compareVoiceBtnStatus;
@end

@protocol ZKGameScreenDelegate <NSObject>
@optional
- (void)clickMenu;
@end
