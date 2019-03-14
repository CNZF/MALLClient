//
//  SubmiteOrderViewController.h
//  MallClient
//
//  Created by lxy on 2016/12/1.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "CapacityEntryModel.h"

@interface SubmiteOrderViewController : BaseViewController

@property (nonatomic,strong)CapacityEntryModel * capacityEntry;//订单类Model

@end


#pragma mark - 集装箱运力
@interface SubmiteOrderViewController_Container : SubmiteOrderViewController

@end
#pragma mark - 散堆装运力
@interface SubmiteOrderViewController_InBulk : SubmiteOrderViewController

@end

#pragma mark - 三农化肥运力
@interface SubmiteOrderViewController_Fertilizer : SubmiteOrderViewController

@end

#pragma mark - 一带一路运力
@interface SubmiteOrderViewController_OneBeltOneRoad : SubmiteOrderViewController

@end

#pragma mark - 冷链运力
@interface SubmiteOrderViewController_ColdChain : SubmiteOrderViewController

@end

#pragma mark - 大件运力
@interface SubmiteOrderViewController_Big : SubmiteOrderViewController

@end

#pragma mark - 商品车运力
@interface SubmiteOrderViewController_ForCar : SubmiteOrderViewController

@end

#pragma mark - 液态运力
@interface SubmiteOrderViewController_Liquid : SubmiteOrderViewController

@end

#pragma mark - 快速配送运力
@interface SubmiteOrderViewController_QuickGo : SubmiteOrderViewController

@end