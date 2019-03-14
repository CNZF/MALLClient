//
//  KNOrderSubmitVC.h
//  MallClient
//
//  Created by 沙漠 on 2018/5/3.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "TicketsDetailModel.h"
#import "TransportationModel.h"
@class CapacityEntryModel;

@interface KNOrderSubmitVC : BaseViewController

//是否有发票
@property (nonatomic, assign) BOOL isShowInvoice;

@property (nonatomic, strong) CapacityEntryModel *requestModel;

@property (nonatomic, strong) TicketsDetailModel *detailModel;

@property (nonatomic, strong) TransportationModel *transportModel;


@end
