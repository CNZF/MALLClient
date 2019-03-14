//
//  CapacityOrderDetailVC.h
//  MallClient
//
//  Created by lxy on 2018/6/6.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderModelForCapacity.h"

typedef void(^CancleBlock)(OrderModelForCapacity * model);

@interface CapacityOrderDetailVC : BaseViewController

@property (nonatomic, strong) OrderModelForCapacity * model;
@property (nonatomic, copy) CancleBlock cancelBlcok;
@end
