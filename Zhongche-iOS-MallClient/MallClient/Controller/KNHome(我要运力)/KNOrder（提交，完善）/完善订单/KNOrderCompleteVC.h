//
//  KNOrderCompleteVC.h
//  MallClient
//
//  Created by 沙漠 on 2018/4/26.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "TicketsDetailModel.h"
#import "TransportationModel.h"
#import "ContainerModel.h"
@class CapacityEntryModel;

@interface KNOrderCompleteVC : BaseViewController

@property (nonatomic, strong) TicketsDetailModel *detailModel;

@property (nonatomic, strong) TransportationModel *transportModel;

@property (nonatomic, strong) CapacityEntryModel *requestModel;

@property (nonatomic, strong)ContainerModel * containerModel;//单个集装箱类型

@end
