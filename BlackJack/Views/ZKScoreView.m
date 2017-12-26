//
//  ZKScoreView.m
//  BlackJack
//
//  Created by Tom on 2017/12/26.
//  Copyright © 2017年 YellowBoy. All rights reserved.
//

#import "ZKScoreView.h"

@implementation ZKScoreView
- (instancetype)initWithFrame:(CGRect)frame andType:(coinType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        [self setUI];
        [self setCoin];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_scores"]];
    [self addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.textColor = [UIColor whiteColor];
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreLabel.backgroundColor = [UIColor clearColor];
    self.scoreLabel.font = [UIFont systemFontOfSize:ZScale(16)];
    [self addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setCoin {
    self.backgroundView.image = [UIImage imageNamed:@"icon_money"];
    self.scoreLabel.textAlignment = NSTextAlignmentLeft;
    [self.scoreLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(ZScale(80));
        make.centerY.equalTo(self);
        make.width.equalTo(self.scoreLabel);
        make.height.mas_equalTo(20);
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
