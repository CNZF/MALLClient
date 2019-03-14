//
//  KNTransportResultDetailVC.h
//  MallClient
//
//  Created by 沙漠 on 2018/4/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
@class CapacityEntryModel;
@class TransportationModel;

@interface KNTransportResultDetailVC : BaseViewController

@property (nonatomic, copy) CapacityEntryModel *requestModel;

@property (nonatomic, strong) TransportationModel *transportModel;

@property (nonatomic, copy) NSString *titleStr;

@end
