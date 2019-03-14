//
//  ContainerCapacityController.h
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/25.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "CapacityEntryModel.h"

@interface ContainerCapacityController : BaseViewController

@property (nonatomic, assign)BOOL isFromHot;
@property (nonatomic, strong)CapacityEntryModel * caModel;
@property (nonatomic, assign) BOOL isReturnToFirst;

@end
#pragma mark - 集装箱运力
@interface ContainerCapacityController_Container : ContainerCapacityController

@end
#pragma mark - 散堆装运力
@interface ContainerCapacityController_InBulk : ContainerCapacityController

@end

#pragma mark - 三农化肥运力
@interface ContainerCapacityController_Fertilizer : ContainerCapacityController

@end

#pragma mark - 批量成件运力
@interface ContainerCapacityController_Batch : ContainerCapacityController

@end

#pragma mark - 冷链运力
@interface ContainerCapacityController_ColdChain : ContainerCapacityController

@end

#pragma mark - 大件运力
@interface ContainerCapacityController_Big : ContainerCapacityController

@end

#pragma mark - 商品车运力
@interface ContainerCapacityController_ForCar : ContainerCapacityController

@end

#pragma mark - 液态运力
@interface ContainerCapacityController_Liquid : ContainerCapacityController

@end

#pragma mark - 一带一路运力
@interface ContainerCapacityController_OneBeltOneRoad : ContainerCapacityController

@end

#pragma mark - 快速配送运力
@interface ContainerCapacityController_QuickGo : ContainerCapacityController

@end
