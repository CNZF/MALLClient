//
//  KNWantTransportSectionHeader.m
//  MallClient
//
//  Created by dushenke on 2018/4/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNWantTransportSectionHeader.h"

@interface KNWantTransportSectionHeader ()

@property (nonatomic, strong) UIImageView *sectionIcon;

@property (nonatomic, strong) UILabel *sectionLabel;

@property (nonatomic, strong) UIView *cuttingLine;

@property (nonatomic, strong) UIButton * OBtn;
@property (nonatomic, strong) UIButton * TBtn;

@end

@implementation KNWantTransportSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.sectionIcon];
    [self addSubview:self.sectionLabel];
    [self addSubview:self.cuttingLine];
    [self addSubview:self.OBtn];
    [self addSubview:self.TBtn];
    
    
    WS(weakSelf)
    [self.sectionIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@15);
//        make.centerY.mas_equalTo(weakSelf);
        make.top.mas_equalTo(@15);
    }];
    [self.sectionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.sectionIcon.mas_right).mas_offset(5);
        make.top.mas_equalTo(@15);
    }];
    [self.OBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.sectionLabel.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(weakSelf).mas_offset(15);
    }];
    [self.TBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.sectionLabel.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(weakSelf).mas_offset(-15);
    }];
    [self.cuttingLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(weakSelf);
        make.height.mas_equalTo(@0.5);
    }];
}

- (void)onBtnO{
    if (self.headBlock) {
        self.headBlock(@"O");
    }
}
- (void)onBtnT{
    if (self.headBlock) {
        self.headBlock(@"T");
    }
}
#pragma mark -- Getter
- (UIImageView *)sectionIcon{
    if (!_sectionIcon) {
        _sectionIcon = [[UIImageView alloc] init];
        _sectionIcon.image = [UIImage imageNamed:@"KN_hotIcon"];
    }
    return _sectionIcon;
}

- (UIButton *)OBtn
{
    if (!_OBtn) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"集装箱线路" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onBtnO) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font  =[UIFont systemFontOfSize:15];
        _OBtn = btn;
    }
    return _OBtn;
}

- (UIButton *)TBtn
{
    if (!_TBtn) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"散堆装线路" forState:UIControlStateNormal];
        btn.titleLabel.font  =[UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(onBtnT) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _TBtn = btn;
    }
    return _TBtn;
}

- (UILabel *)sectionLabel{
    if (!_sectionLabel) {
        _sectionLabel = [[UILabel alloc] init];
        _sectionLabel.font = [UIFont systemFontOfSize:16];
        _sectionLabel.textColor = APP_COLOR_BLACK_TEXT;
        _sectionLabel.text = @"热门区域路线";
    }
    return _sectionLabel;
}
- (UIView *)cuttingLine{
    if (!_cuttingLine) {
        _cuttingLine = [[UIView alloc] init];
        _cuttingLine.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
    }
    return _cuttingLine;
}

@end
