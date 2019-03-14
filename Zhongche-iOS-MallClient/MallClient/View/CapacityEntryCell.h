//
//  CapacityEntryCell.h
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/30.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "CapacityEntryModel.h"

@interface CapacityEntryCell : BaseTableViewCell

@end
#pragma mark - 集装箱运力
@interface CapacityEntryCell_Container : CapacityEntryCell

@end
#pragma mark - 散堆装运力
@interface CapacityEntryCell_InBulk : CapacityEntryCell

@end

#pragma mark - 三农化肥运力
@interface CapacityEntryCell_Fertilizer : CapacityEntryCell

@end

#pragma mark - 批量成件运力
@interface CapacityEntryCell_Batch : CapacityEntryCell

@end

#pragma mark - 冷链运力
@interface CapacityEntryCell_ColdChain : CapacityEntryCell

@end

#pragma mark - 大件运力
@interface CapacityEntryCell_Big : CapacityEntryCell

@end

#pragma mark - 商品车运力
@interface CapacityEntryCell_ForCar : CapacityEntryCell

@end

#pragma mark - 液态运力
@interface CapacityEntryCell_Liquid : CapacityEntryCell

@end

#pragma mark - 一带一路运力
@interface CapacityEntryCell_OneBeltOneRoad : CapacityEntryCell

@end
