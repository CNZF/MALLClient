//
//  CustomCapacityController.h
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/29.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "CapacityEntryModel.h"

@protocol CustomCapacityControllerDelegate <NSObject>



-(void)needGoBackLastView;
-(void)needPushNextView;

@end

@interface CustomCapacityController : BaseViewController
@property (nonatomic,strong)CapacityEntryModel * capacityEntry;//搜索条件
@property (nonatomic, assign) int            isRefush; //1、上拉刷新取消

@property (nonatomic, weak)UIViewController<CustomCapacityControllerDelegate>*vcDelgate;
@end
#pragma mark - 集装箱运力
@interface CustomCapacityController_Container : CustomCapacityController

@end
#pragma mark - 散堆装运力
@interface CustomCapacityController_InBulk : CustomCapacityController

@end

#pragma mark - 三农化肥运力
@interface CustomCapacityController_Fertilizer : CustomCapacityController

@end

#pragma mark - 批量成件运力
@interface CustomCapacityController_Batch : CustomCapacityController

@end

#pragma mark - 冷链运力
@interface CustomCapacityController_ColdChain : CustomCapacityController

@end

#pragma mark - 大件运力
@interface CustomCapacityController_Big : CustomCapacityController

@end

#pragma mark - 商品车运力
@interface CustomCapacityController_ForCar : CustomCapacityController

@end

#pragma mark - 液态运力
@interface CustomCapacityController_Liquid : CustomCapacityController

@end

#pragma mark - 一带一路运力
@interface CustomCapacityController_OneBeltOneRoad : CustomCapacityController

@end

#pragma mark - 快速配送运力
@interface CustomCapacityController_QuickGo : CustomCapacityController

@end
