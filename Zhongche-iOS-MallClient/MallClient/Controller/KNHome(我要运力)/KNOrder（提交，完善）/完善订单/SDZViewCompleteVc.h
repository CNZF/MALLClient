//
//  SDZViewController.h
//  MallClient
//
//  Created by lxy on 2018/8/13.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "CapacityViewModel.h"

@interface SDZViewCompleteVc : BaseViewController

@property (nonatomic, strong) CapacityViewModel *reRequestModel;
@property (nonatomic, strong) GoodsInfo *goods;
@end
