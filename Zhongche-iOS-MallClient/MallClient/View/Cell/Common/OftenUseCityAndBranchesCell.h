//
//  OftenUseCityAndBranchesCell.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/5/31.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "OftenUseCityCell.h"


@interface OftenUseCityAndBranchesCell : BaseTableViewCell
@property (nonatomic, weak)id<OftenUseCityCellDelegate> cellDelegate;
+(float)getCellHeightWithmodel:(NSArray *)citys;
@end
