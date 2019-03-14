//
//  OftenUseCityCell.h
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/12/1.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol OftenUseCityCellDelegate <NSObject>

-(void)getClickBtnNum:(NSInteger)num;

@end

@interface OftenUseCityCell : BaseTableViewCell
@property (nonatomic, weak)id<OftenUseCityCellDelegate> cellDelegate;
@end
