//
//  ZKPublickHeader.h
//  BlackJack
//
//  Created by YellowBoy on 2017/12/17.
//  Copyright © 2017年 YellowBoy. All rights reserved.
//

#ifndef ZKPublickHeader_h
#define ZKPublickHeader_h

#define ZKDebug 1

#define S_WIDTH  [UIScreen mainScreen].bounds.size.width
#define S_HEIGHT [UIScreen mainScreen].bounds.size.height

#define WEAK_SELF(obj) __weak typeof(obj) weak##obj = obj;
#define W_H 50
#define ZScale(s) (s*(S_WIDTH/736))

#endif /* ZKPublickHeader_h */
