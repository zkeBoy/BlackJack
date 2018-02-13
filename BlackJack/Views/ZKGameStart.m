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
@property (nonatomic, strong) UIImageView  * lineView;
@property (nonatomic, strong) ZKScoreView  * bestView; //最高分数
@property (nonatomic, strong) UIImageView  * addCoinView;
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
        [self updatePlayerCoinNum];
        [self addUserCoinAnimation];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(ZScale(38));
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
        make.top.equalTo(self).offset(ZScale(0));
        make.left.equalTo(self).offset(S_WIDTH/5);
        make.width.mas_equalTo(ZScale(S_WIDTH/5+20));
        make.height.mas_equalTo(ZScale(32));
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
    
    [self addSubview:self.bestView];
    [self.bestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(ZScale(20));
        make.left.equalTo(self).offset(20);
        make.width.height.mas_equalTo(self.bottomImageView);
    }];
    
    [self addSubview:self.voiceBtn];
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ZScale(0));
        make.width.height.mas_offset(ZScale(30));
        make.right.equalTo(self).offset(ZScale(-120));
    }];
    
    [self addSubview:self.addCoinView];
    [self.addCoinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(40);
        make.width.mas_equalTo(ZScale(130/2));
        make.height.mas_equalTo(ZScale(30));
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

- (void)addUserCoinAnimation {
    self.addCoinView.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.5 animations:^{
            self.addCoinView.transform = CGAffineTransformMakeScale(2, 2);
        }completion:^(BOOL finished) {
            [ZKCardsManagerDefault playerWin:80];
            self.addCoinView.hidden = YES;
            [self updatePlayerCoinNum];
            [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationUpdateCoinKey object:nil];
        }];
    });
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
        //_bottomImageView.image = [UIImage imageNamed:@""];
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

- (UIImageView *)lineView {
    if (!_lineView) {
        _lineView = [[UIImageView alloc] init];
        _lineView.image = [UIImage imageNamed:@"icon_line"];
    }
    return _lineView;
}

- (ZKScoreView *)bestView {
    if (!_bestView) {
        _bestView = [[ZKScoreView alloc] initWithFrame:CGRectZero andType:coinTypeScore];
        _bestView.backgroundView.image = [UIImage imageNamed:@"icon_best"];
        _bestView.scoreLabel.text = @"5280";
        _bestView.scoreLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _bestView;
}

- (UIImageView *)addCoinView {
    if (!_addCoinView) {
        _addCoinView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_addCoin"]];
        _addCoinView.hidden = YES;
    }
    return _addCoinView;
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
