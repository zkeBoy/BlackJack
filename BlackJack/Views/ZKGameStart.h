//
//  ZKGameStart.h
//  BlackJack
//
//  Created by YellowBoy on 2017/12/17.
//  Copyright © 2017年 YellowBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^startPlayBlock)(void);

@interface ZKGameStart : UIView
@property (nonatomic,   copy) startPlayBlock playBlock;
+ (ZKGameStart *)addGameStartView:(CGRect)frame andClick:(void(^)(void))clickBlock;

- (void)updatePlayerCoinNum;
@end
