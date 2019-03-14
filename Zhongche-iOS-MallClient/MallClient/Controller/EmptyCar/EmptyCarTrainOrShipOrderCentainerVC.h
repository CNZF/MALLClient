//
//  EmptyCarTrainOrShipOrderCentainerVC.h
//  MallClient
//
//  Created by lxy on 2017/3/31.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "EmptyCarModel.h"
#import "GoodsInfo.h"

@interface EmptyCarTrainOrShipOrderCentainerVC : BaseViewController

@property (nonatomic, strong) EmptyCarModel *currentModel;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) GoodsInfo *goods;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, assign) int num;

@property (nonatomic, assign) int type;//0火车  1轮船

@end
