//
//  ZKHelperView.m
//  BlackJack
//
//  Created by Tom on 2017/12/20.
//  Copyright © 2017年 YellowBoy. All rights reserved.
//

#import "ZKHelperView.h"
@interface ZKHelperView ()
@property (nonatomic, strong) UIImageView  * noticeImageView;
@property (nonatomic, strong) UILabel      * noticeLabel;
@end

@implementation ZKHelperView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.noticeLabel];
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(S_HEIGHT*0.55);
        make.left.equalTo(self).offset(ZScale(300));
        make.right.equalTo(self).offset(ZScale(-300));
        make.height.mas_equalTo(40);
    }];
}

- (void)showResultWithType:(resultType)type toView:(UIView *)view hiddenBlock:(void(^)(void))hidden {
    [view addSubview:self];
    [self showResultWithType:type hiddenBlock:hidden];
}

- (void)showResultWithType:(resultType)type hiddenBlock:(void(^)(void))hidden {
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -S_HEIGHT);
    }completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                self.transform = CGAffineTransformIdentity;
            }completion:^(BOOL finished) {
                [self removeFromSuperview];
                if (hidden) {
                    hidden();
                }
            }];
        });
    }];
    
    if (type==resultTypeWin) {
        [self showTitle:NSLocalizedString(@"You Win", nil)];
        self.noticeLabel.textColor = [UIColor purpleColor];
    }else if (type==resultTypeLose) {
        [self showTitle:NSLocalizedString(@"You Lose", nil)];
        self.noticeLabel.textColor = [UIColor redColor];
    }else if(type==resultTypePush){
        [self showTitle:NSLocalizedString(@"Push !", nil)];
        self.noticeLabel.textColor = [UIColor blueColor];
    }else {
        [self showTitle:NSLocalizedString(@"You Coin!", nil)];
        self.noticeLabel.textColor = [UIColor yellowColor];
    }
}

- (void)showTitle:(NSString *)title {
    self.noticeLabel.text = title;
}

#pragma mark - lazy init
- (UIImageView *)noticeImageView {
    if (!_noticeImageView) {
        _noticeImageView = [[UIImageView alloc] init];
    }
    return _noticeImageView;
}

- (UILabel *)noticeLabel {
    if (!_noticeLabel) {
        _noticeLabel = [[UILabel alloc] init];
        _noticeLabel.textAlignment = NSTextAlignmentCenter;
        _noticeLabel.font = [UIFont boldSystemFontOfSize:24];
        _noticeLabel.backgroundColor = [UIColor whiteColor];
        _noticeLabel.layer.cornerRadius = 10;
        _noticeLabel.layer.masksToBounds = YES;
        _noticeLabel.layer.borderWidth = 2;
        _noticeLabel.layer.borderColor = [UIColor orangeColor].CGColor;
    }
    return _noticeLabel;
}

- (void)dealloc {
    NSLog(@"ZKHelperView dealloc !!!!!!");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
