//
//  EmptySubmiteOrderShipAndTrainViewController.h
//  MallClient
//
//  Created by lxy on 2017/3/30.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "EmptyCarModel.h"

@interface EmptySubmiteOrderShipAndTrainViewController : BaseViewController

@property (nonatomic, assign) int type;//0火车  1轮船
@property (nonatomic, strong) EmptyCarModel *currentModel;

@end
