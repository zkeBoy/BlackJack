//
//  ZKGameStart.m
//  BlackJack
//
//  Created by YellowBoy on 2017/12/17.
//  Copyright © 2017年 YellowBoy. All rights reserved.
//

#import "ZKGameStart.h"
@interface ZKGameStart ()
@property (nonatomic, strong) UIImageView  * backgroundView;
@property (nonatomic, strong) UIButton     * playBtn;
@property (nonatomic, strong) UIButton     * voiceBtn; //声音
@property (nonatomic, strong) UIImageView  * coinImageView;
@property (nonatomic, strong) UILabel      * coinLabel;//金币总额
@property (nonatomic, strong) UIImageView  * bottomImageView;
@end

@implementation ZKGameStart

+ (ZKGameStart *)addGameStartView:(CGRect)frame andClick:(void(^)(void))clickBlock {
    ZKGameStart * start = [[ZKGameStart alloc] initWithFrame:frame];
    start.playBlock = clickBlock;
    return start;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-80);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - lazy init
- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.image = [UIImage imageNamed:@"icon_start"];
    }
    return _backgroundView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        _playBtn.backgroundColor = [UIColor purpleColor];
        [_playBtn addTarget:self action:@selector(playGameAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = [[UIButton alloc] init];
        _voiceBtn.backgroundColor = [UIColor redColor];
        [_voiceBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_voiceBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [_voiceBtn addTarget:self action:@selector(switchVoiceAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn;
}

- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] init];
        _bottomImageView.image = [UIImage imageNamed:@""];
    }
    return _bottomImageView;
}

- (UIImageView *)coinImageView {
    if (!_coinImageView) {
        _coinImageView = [[UIImageView alloc] init];
        _coinImageView.image = [UIImage imageNamed:@""];
    }
    return _coinImageView;
}

- (UILabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel = [[UILabel alloc] init];
        _coinLabel.backgroundColor = [UIColor clearColor];
        _coinLabel.textColor = [UIColor whiteColor];
        _coinLabel.textAlignment = NSTextAlignmentRight;
        _coinLabel.font = [UIFont systemFontOfSize:16];
    }
    return _coinLabel;
}

#pragma mark - Button Method
- (void)playGameAction:(UIButton *)btn {
    if (self.playBlock) {
        self.playBlock();
    }
}

//声音开关
- (void)switchVoiceAction:(UIButton *)btn {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
