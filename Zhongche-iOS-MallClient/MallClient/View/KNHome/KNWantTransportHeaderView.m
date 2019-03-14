//
//  KNWantTransportHeaderView.m
//  MallClient
//
//  Created by dushenke on 2018/4/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNWantTransportHeaderView.h"

@interface KNWantTransportHeaderView ()

@property (nonatomic,strong) UIView *bottomBGView;

//箭头
@property (nonatomic, strong) UIImageView *arrowIcon;

@property (nonatomic, strong) UILabel *startTitleLabel;

@property (nonatomic, strong) UILabel *arriveTitleLabel;

@property (nonatomic, strong) UILabel *timeTitleLabel;

@property (nonatomic, strong) UIView *cuttingLine1;

@property (nonatomic, strong) UIView *cuttingLine2;

@property (nonatomic, strong) UIView *cuttingLine3;

@property (nonatomic, strong) UIView *cuttingLine4;

@end

@implementation KNWantTransportHeaderView

- (void)binView{
    self.backgroundColor = APP_COLOR_WHITEBG;
    [self addSubview:self.cycleScrollView];
    [self addSubview:self.bottomBGView];
    [self.bottomBGView addSubview:self.titleLabel];
    [self.bottomBGView addSubview:self.cuttingLine1];
//    [self.bottomBGView addSubview:self.startTitleLabel];
    [self.bottomBGView addSubview:self.startButton];
//    [self.bottomBGView addSubview:self.arriveTitleLabel];
    [self.bottomBGView addSubview:self.arriveButton];
    [self.bottomBGView addSubview:self.cuttingLine2];
    [self.bottomBGView addSubview:self.cuttingLine3];
    [self.bottomBGView addSubview:self.timeTitleLabel];
    [self.bottomBGView addSubview:self.timeButton];
    [self.bottomBGView addSubview:self.arrowIcon];
    [self.bottomBGView addSubview:self.cuttingLine4];
    [self.bottomBGView addSubview:self.searchButton];
    [self.bottomBGView addSubview:self.changeButton];
    [self updateSubViewConstraints];
    
}

- (void)updateSubViewConstraints{
    WS(weakSelf)
    [self.cycleScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(weakSelf);
        make.height.mas_equalTo(@170);
    }];
    [self.bottomBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.cycleScrollView.mas_bottom);
        make.left.right.mas_equalTo(weakSelf);
        make.bottom.mas_equalTo(weakSelf).mas_offset(-12);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@20);
        make.top.mas_equalTo(@15);
    }];
    [self.cuttingLine1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(@0.5);
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(15);
    }];
//    [self.startTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.leading.mas_equalTo(weakSelf.titleLabel);
//        make.top.mas_equalTo(weakSelf.cuttingLine1.mas_bottom).mas_offset(7);
//    }];
//    [self.arriveTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(SCREEN_W/2+20);
//        make.top.mas_equalTo(weakSelf.startTitleLabel);
//    }];
    [self.startButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(weakSelf).mas_offset(@23);
        make.top.mas_equalTo(weakSelf.cuttingLine1.mas_bottom).mas_offset(@20);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(SCREEN_W/2-60);
    }];
    [self.arriveButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(weakSelf).mas_offset(@-20);
        make.top.mas_equalTo(weakSelf.cuttingLine1.mas_bottom).mas_offset(@20);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(SCREEN_W/2-60);
    }];
    [self.cuttingLine2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(weakSelf).mas_offset(@20);
        make.top.mas_equalTo(weakSelf.startButton.mas_bottom).mas_offset(@20);
        make.height.mas_equalTo(@0.5);
        make.width.mas_equalTo(weakSelf.startButton);
    }];
    [self.cuttingLine3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(weakSelf).mas_offset(@-20);
        make.top.mas_equalTo(weakSelf.arriveButton.mas_bottom).mas_offset(@20);
        make.height.mas_equalTo(@0.5);
        make.width.mas_equalTo(weakSelf.arriveButton);
    }];
    
    [self.changeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf);
        make.centerY.mas_equalTo(weakSelf.cuttingLine2);
        make.width.mas_equalTo(@40);
        make.height.mas_equalTo(@40);
    }];
//    [self.timeTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(weakSelf.cuttingLine2.mas_bottom).mas_offset(20);
//        make.leading.mas_equalTo(weakSelf.titleLabel);
//    }];
    [self.arrowIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(weakSelf.timeButton);
        make.right.mas_equalTo(weakSelf).mas_offset(-20);
        make.width.mas_equalTo(@10);
        make.height.mas_equalTo(@15);
        make.top.mas_equalTo(weakSelf.cuttingLine3).mas_offset(@23);
    }];
    [self.timeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(weakSelf.startButton);
        make.trailing.mas_equalTo(weakSelf.arriveButton);
        make.top.mas_equalTo(weakSelf.cuttingLine2.mas_bottom).mas_offset(@20);
        make.height.mas_equalTo(@30);
//        make.right.mas_equalTo(weakSelf.arrowIcon.mas_left);
    }];
    [self.cuttingLine4 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.timeButton.mas_bottom).mas_offset(@20);
        make.height.mas_equalTo(@0.5);
        make.leading.mas_equalTo(weakSelf.startButton);
        make.right.mas_equalTo(@-20);
    }];
    [self.searchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf.cuttingLine4.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(@44);
        make.width.mas_equalTo(SCREEN_W-40);
    }];
    
}

#pragma mark -- Getter
- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc] init];
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"KN_banner_placeholder"];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.pageDotColor = [UIColor whiteColor];
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor];
        _cycleScrollView.autoScrollTimeInterval = 3.5f;
    }
    return _cycleScrollView;
}
- (UIView *)bottomBGView{
    if (!_bottomBGView) {
        _bottomBGView = [[UIView alloc] init];
        _bottomBGView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomBGView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = APP_COLOR_GRAY999;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.text = @"集装箱运力";
    }
    return _titleLabel;
}
- (UIView *)cuttingLine1{
    if (!_cuttingLine1) {
        _cuttingLine1 = [[UIView alloc] init];
        _cuttingLine1.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
    }
    return _cuttingLine1;
}
//-(UILabel *)startTitleLabel{
//    if (!_startTitleLabel) {
//        _startTitleLabel = [[UILabel alloc] init];
//        _startTitleLabel.textColor = APP_COLOR_GRAY999;
//        _startTitleLabel.font = [UIFont systemFontOfSize:12];
//        _startTitleLabel.text = @"起运地";
//    }
//    return _startTitleLabel;
//}
- (UIButton *)startButton{
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startButton setTitleColor:APP_COLOR_GRAY999 forState:UIControlStateNormal];
        _startButton.titleLabel.font = [UIFont systemFontOfSize:22];
//        [_startButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22]];
        _startButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_startButton setTitle:@"起运地" forState:UIControlStateNormal];
    }
    return _startButton;
}
//-(UILabel *)arriveTitleLabel{
//    if (!_arriveTitleLabel) {
//        _arriveTitleLabel = [[UILabel alloc] init];
//        _arriveTitleLabel.textColor = APP_COLOR_GRAY999;
//        _arriveTitleLabel.font = [UIFont systemFontOfSize:12];
//        _arriveTitleLabel.text = @"抵运地";
//    }
//    return _arriveTitleLabel;
//}
- (UIButton *)arriveButton{
    if (!_arriveButton) {
        _arriveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arriveButton setTitleColor:APP_COLOR_GRAY999 forState:UIControlStateNormal];
        _arriveButton.titleLabel.font = [UIFont systemFontOfSize:22];
//        [_arriveButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22]];
        _arriveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_arriveButton setTitle:@"抵运地" forState:UIControlStateNormal];
    }
    return _arriveButton;
}
-(UILabel *)timeTitleLabel{
    if (!_timeTitleLabel) {
        _timeTitleLabel = [[UILabel alloc] init];
        _timeTitleLabel.textColor = APP_COLOR_GRAY999;
        _timeTitleLabel.font = [UIFont systemFontOfSize:12];
        
        _timeTitleLabel.text = @"发货日期";
    }
    return _timeTitleLabel;
}
- (UIButton *)timeButton{
    if (!_timeButton) {
        _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_timeButton setTitleColor:APP_COLOR_GRAY999 forState:UIControlStateNormal];
        _timeButton.titleLabel.font = [UIFont systemFontOfSize:18];
//        [_timeButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        _timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_timeButton setTitle:@"发货时间" forState:UIControlStateNormal];
    }
    return _timeButton;
}

- (UIButton *)changeButton{
    if (!_changeButton) {
        _changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeButton setBackgroundImage:[UIImage imageNamed:@"change... 3"] forState:UIControlStateNormal];
    }
    return _changeButton;
}
- (UIImageView *)arrowIcon{
    if (!_arrowIcon) {
        _arrowIcon = [[UIImageView alloc] init];
        _arrowIcon.image = [UIImage imageNamed:@"KN_enterIcon_black"];
    }
    return _arrowIcon;
}
- (UIView *)cuttingLine2{
    if (!_cuttingLine2) {
        _cuttingLine2 = [[UIView alloc] init];
        _cuttingLine2.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
    }
    return _cuttingLine2;
}
- (UIView *)cuttingLine3{
    if (!_cuttingLine3) {
        _cuttingLine3 = [[UIView alloc] init];
        _cuttingLine3.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
    }
    return _cuttingLine3;
}
- (UIView *)cuttingLine4{
    if (!_cuttingLine4) {
        _cuttingLine4 = [[UIView alloc] init];
        _cuttingLine4.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
    }
    return _cuttingLine4;
}
- (UIButton *)searchButton{
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setBackgroundColor:[HelperUtil colorWithHexString:@"3BA0F3"]];
        _searchButton.layer.cornerRadius =  3.0;
        _searchButton.layer.masksToBounds = YES;
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    }
    return _searchButton;
}

@end
