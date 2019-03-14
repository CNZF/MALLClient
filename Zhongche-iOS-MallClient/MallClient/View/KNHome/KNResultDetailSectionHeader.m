//
//  KNResultDetailSectionHeader.m
//  MallClient
//
//  Created by 沙漠 on 2018/4/26.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNResultDetailSectionHeader.h"

@interface KNResultDetailSectionHeader ()

@property (nonatomic, strong) UIView *topView;

//分割线
@property (nonatomic, strong) UIView *cuttingLine;

@end

@implementation KNResultDetailSectionHeader

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topView];
    [self addSubview:self.distanceLabel];
    [self addSubview:self.descLabel];
    [self addSubview:self.cuttingLine];
    
    WS(weakSelf)
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(weakSelf);
        make.height.mas_equalTo(@10);
    }];
    [self.distanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.topView.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(@15);
    }];
    [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.distanceLabel.mas_bottom).mas_offset(3);
        make.left.mas_equalTo(weakSelf.distanceLabel);
    }];
    [self.cuttingLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.descLabel.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(SCREEN_W);
        make.height.mas_equalTo(@0.5);
    }];
}

#pragma mark -- Getter
- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
    }
    return _topView;
}
- (UILabel *)distanceLabel{
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.font = [UIFont systemFontOfSize:14];
        _distanceLabel.textColor = [HelperUtil colorWithHexString:@"111111"];
    }
    return _distanceLabel;
}
- (UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = [UIFont systemFontOfSize:12];
        _descLabel.textColor = [HelperUtil colorWithHexString:@"3f3f3f"];
    }
    return _descLabel;
}
-(UIView *)cuttingLine{
    if (!_cuttingLine) {
        _cuttingLine = [[UILabel alloc] init];
        _cuttingLine.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
    }
    return _cuttingLine;
}

@end
