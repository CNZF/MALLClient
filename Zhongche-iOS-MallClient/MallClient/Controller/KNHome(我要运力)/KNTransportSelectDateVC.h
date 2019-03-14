//
//  KNTransportSelectDateVC.h
//  MallClient
//
//  Created by dushenke on 2018/4/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
@class CapacityEntryModel;

typedef void (^KNTransportselectDateBlock)(NSDate *date);

@interface KNTransportSelectDateVC : BaseViewController

@property (nonatomic, copy) KNTransportselectDateBlock selectDateBlock;

@property (nonatomic, strong) CapacityEntryModel *requestModel;

@end
