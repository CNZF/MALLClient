//
//  OrderCenterTabCell.h
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/12/5.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "OrderModelForCapacity.h"
#import "OrderModelForEmptyCar.h"
#import "OrderModelForEmptyContainer.h"


@protocol OrderCenterTabCellDelegate <NSObject>

-(void)getTheTopButtonClickWithCellIndexPath:(NSIndexPath*)cellIndexPath;
-(void)getTheTopCancelButtonClickWithCellIndexPath:(NSIndexPath*)cellIndexPath;
-(void)getCellClick:(NSIndexPath*)cellIndexPath;
@end

@interface OrderCenterTabCell : BaseTableViewCell

@property (nonatomic,weak)id<OrderCenterTabCellDelegate>cellDelegate;
@property (nonatomic,strong)NSIndexPath * cellIndexPath;
@property (nonatomic, assign)BOOL beenPlacedAtTheTop;//是否被置顶

@end
