//
//  PerfectOrderViewController.h
//  MallClient
//
//  Created by lxy on 2016/12/2.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"

#import "CapacityEntryModel.h"


@interface PerfectOrderViewController : BaseViewController

@property (nonatomic,strong)CapacityEntryModel * capacityEntry;//订单类Model


@end


#pragma mark - 集装箱运力
@interface PerfectOrderViewController_Container : PerfectOrderViewController

@end
#pragma mark - 散堆装运力
@interface PerfectOrderViewController_InBulk : PerfectOrderViewController

@end

#pragma mark - 三农化肥运力
@interface PerfectOrderViewController_Fertilizer : PerfectOrderViewController
@end

#pragma mark - 一带一路运力
@interface PerfectOrderViewController_OneBeltOneRoad : PerfectOrderViewController
@end

#pragma mark - 快速配送力
@interface PerfectOrderViewController_QuickGo : PerfectOrderViewController
@end

#pragma mark - 冷链运力
@interface PerfectOrderViewController_ColdChain : PerfectOrderViewController
@end

#pragma mark - 大件运力
@interface PerfectOrderViewController_Big : PerfectOrderViewController
@end

#pragma mark - 商品车运力
@interface PerfectOrderViewController_ForCar : PerfectOrderViewController
@end

#pragma mark - 液态运力
@interface PerfectOrderViewController_Liquid : PerfectOrderViewController
@end