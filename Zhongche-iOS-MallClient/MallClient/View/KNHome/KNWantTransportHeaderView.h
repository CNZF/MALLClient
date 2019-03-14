//
//  KNWantTransportHeaderView.h
//  MallClient
//
//  Created by dushenke on 2018/4/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseView.h"

@interface KNWantTransportHeaderView : BaseView
// banner图
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
// 起运
@property (nonatomic, strong) UIButton *startButton;
// 到达
@property (nonatomic, strong) UIButton *arriveButton;
// 发货日期
@property (nonatomic, strong) UIButton *timeButton;
//搜索按钮
@property (nonatomic, strong) UIButton *searchButton;

@property (nonatomic, strong) UIButton *changeButton;
//标题
@property (nonatomic, strong) UILabel *titleLabel;
@end
