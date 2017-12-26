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
@property (nonatomic, strong) UIImageView  * bottomImageView;
@property (nonatomic, strong) UIImageView  * coinImageView;
@property (nonatomic, strong) UILabel      * coinLabel;//金币总额
@end

@implementation ZKGameStart

+ (ZKGameStart *)addGameStartView:(CGRect)frame andClick:(void(^)(void))clickBlock {
    ZKGameStart * start = [[ZKGameStart alloc] initWithFrame:frame];
    start.playBlock = clickBlock;
    return start;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        self.backgroundColor = [UIColor redColor];
        [self updatePlayerCoinNum];
        [self hiddenCoinLabel];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(ZScale(-66));
        make.width.mas_equalTo(ZScale(124));
        make.height.mas_equalTo(ZScale(64));
    }];
    
    [self addSubview:self.bottomImageView];
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ZScale(10));
        make.left.equalTo(self).offset(S_WIDTH/5);
        make.width.mas_equalTo(ZScale(S_WIDTH/5+20));
        make.height.mas_equalTo(ZScale(40));
    }];
    
    [self.bottomImageView addSubview:self.coinImageView];
    [self.coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(ZScale(25));
        make.left.equalTo(self.bottomImageView).offset(5);
        make.centerY.equalTo(self.bottomImageView);
    }];
    
    [self.bottomImageView addSubview:self.coinLabel];
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.bottomImageView);
        make.right.equalTo(self.bottomImageView).offset(-4);
    }];
    
    [self addSubview:self.voiceBtn];
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ZScale(10));
        make.width.height.mas_offset(ZScale(30));
        make.right.equalTo(self).offset(ZScale(-120));
    }];
}

- (void)updatePlayerCoinNum {
    self.coinLabel.text = [NSString stringWithFormat:@"%ld",(long)[ZKCardsManagerDefault playCoinNum]];
    self.voiceBtn.selected = ZKVoiceDefauleManager.close;
}

- (void)hiddenCoinLabel {
    self.bottomImageView.hidden = YES;
    self.coinImageView.hidden = YES;
    self.coinLabel.hidden = YES;
    self.voiceBtn.hidden = YES;
}

#pragma mark - lazy init
- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.image = [UIImage imageNamed:@"icon_Start_Background"];
    }
    return _backgroundView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        _playBtn.layer.cornerRadius = ZScale(20);
        //_playBtn.layer.masksToBounds = YES;
        //_playBtn.backgroundColor = [UIColor purpleColor];
        //[_playBtn setTitle:@"Play" forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playGameAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = [[UIButton alloc] init];
        [_voiceBtn setImage:[UIImage imageNamed:@"icon_voice"] forState:UIControlStateNormal];
        [_voiceBtn setImage:[UIImage imageNamed:@"icon_voiceClose"] forState:UIControlStateSelected];
        [_voiceBtn addTarget:self action:@selector(switchVoiceAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn;
}

- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] init];
        _bottomImageView.image = [UIImage imageNamed:@""];
        _bottomImageView.layer.cornerRadius = 8.0f;
        _bottomImageView.layer.masksToBounds = YES;
        _bottomImageView.layer.borderWidth = 1.5f;
        _bottomImageView.layer.borderColor = [UIColor blackColor].CGColor;
        _bottomImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
    return _bottomImageView;
}

- (UIImageView *)coinImageView {
    if (!_coinImageView) {
        _coinImageView = [[UIImageView alloc] init];
        _coinImageView.image = [UIImage imageNamed:@"icon_coin"];
    }
    return _coinImageView;
}

- (UILabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel = [[UILabel alloc] init];
        _coinLabel.backgroundColor = [UIColor clearColor];
        _coinLabel.textColor = [UIColor whiteColor];
        _coinLabel.textAlignment = NSTextAlignmentRight;
        _coinLabel.font = [UIFont boldSystemFontOfSize:16];
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
    self.voiceBtn.selected = !btn.selected;
    ZKVoiceDefauleManager.close = self.voiceBtn.selected;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
