//
//  KNTransportResultListTopView.h
//  MallClient
//
//  Created by 沙漠 on 2018/4/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseView.h"
@class CapacityEntryModel;

typedef void (^KNTransportResultListTopViewSelectBlock)(NSDate *date);

@interface KNTransportResultListTopView : BaseView

// 低价日历
@property (nonatomic, strong) UIButton *rightButton;
// 预计里程
@property (nonatomic, strong) UILabel *distanceLabel;

@property (nonatomic, strong) CapacityEntryModel *requestModel;

@property (nonatomic, copy) KNTransportResultListTopViewSelectBlock selectModel;

- (instancetype)initWithRequestModel:(CapacityEntryModel *)model;

- (void)requestData;

@end
