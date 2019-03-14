//
//  KNCustomTransportVC.h
//  MallClient
//
//  Created by dushenke on 2018/4/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "CapacityEntryModel.h"

@interface KNCustomTransportVC : BaseViewController

@property (nonatomic, assign) BOOL isNotTabBarSubVC;
@property (nonatomic, strong) CapacityEntryModel *requestModel;
@end
