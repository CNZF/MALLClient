//
//  KNOrderCompleteHeaderView.h
//  MallClient
//
//  Created by 沙漠 on 2018/4/26.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseView.h"
#import "TransportationModel.h"
@class TicketsDetailModel;
@class AddressInfo;

typedef void (^KNOrderCompleteHeaderViewSelectTopBlock)(void);
typedef void (^KNOrderCompleteHeaderViewSelectBottomBlock)(void);

@interface KNOrderCompleteHeaderView : BaseView

@property (nonatomic, strong) TicketsDetailModel *ticketDetailModel;

@property (nonatomic, strong) TransportationModel *transportModel;

@property (nonatomic, copy) KNOrderCompleteHeaderViewSelectTopBlock topBlock;

@property (nonatomic, copy) KNOrderCompleteHeaderViewSelectBottomBlock bottomBlock;

@property (nonatomic, strong) AddressInfo *topAddressInfo;

@property (nonatomic, strong) AddressInfo *bottomAddressInfo;

@end
