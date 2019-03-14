//
//  SearTransportResultViewController.h
//  MallClient
//
//  Created by lxy on 2016/11/29.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "CapacityEntryModel.h"

@interface SearTransportResultViewController : BaseViewController

@property (nonatomic,strong)CapacityEntryModel * capacityEntry;//订单类Model

@end

#pragma mark - 集装箱运力
@interface SearTransportResultViewController_Container : SearTransportResultViewController

@end
#pragma mark - 散堆装运力
@interface SearTransportResultViewController_InBulk : SearTransportResultViewController

@end

#pragma mark - 三农化肥运力
@interface SearTransportResultViewController_Fertilizer : SearTransportResultViewController

@end

#pragma mark - 一带一路运力
@interface SearTransportResultViewController_OneBeltOneRoad : SearTransportResultViewController

@end

#pragma mark - 冷链运力
@interface SearTransportResultViewController_ColdChain : SearTransportResultViewController

@end

#pragma mark - 大件运力
@interface SearTransportResultViewController_Big : SearTransportResultViewController

@end

#pragma mark - 商品车运力
@interface SearTransportResultViewController_ForCar : SearTransportResultViewController

@end

#pragma mark - 液态运力
@interface SearTransportResultViewController_Liquid : SearTransportResultViewController

@end

#pragma mark - 快速运力
@interface SearTransportResultViewController_QuickGo : SearTransportResultViewController

@end