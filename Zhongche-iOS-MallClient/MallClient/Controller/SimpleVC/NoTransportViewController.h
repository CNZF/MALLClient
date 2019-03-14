//
//  NoTransportViewController.h
//  MallClient
//
//  Created by lxy on 2016/11/28.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "CapacityEntryModel.h"

@interface NoTransportViewController : BaseViewController

@property (nonatomic,strong)CapacityEntryModel * capacityEntry;//订单类Model

@end

#pragma mark - 集装箱运力
@interface NoTransportViewController_Container : NoTransportViewController

@end
#pragma mark - 散堆装运力
@interface NoTransportViewController_InBulk : NoTransportViewController

@end

#pragma mark - 三农化肥运力
@interface NoTransportViewController_Fertilizer : NoTransportViewController

@end

#pragma mark 一带一路运力
@interface NoTransportViewController_OneBeltOneRoad : NoTransportViewController

@end

#pragma mark 冷链运力
@interface NoTransportViewController_ColdChain : NoTransportViewController

@end

#pragma mark 大件运力
@interface NoTransportViewController_Big : NoTransportViewController

@end

#pragma mark 商品车运力
@interface NoTransportViewController_ForCar : NoTransportViewController

@end

#pragma mark 液态运力
@interface NoTransportViewController_Liquid : NoTransportViewController

@end

#pragma mark 快速配送运力
@interface NoTransportViewController_QuickGo : NoTransportViewController

@end
