//
//  EntrySelectCell.h
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/28.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "EntrySelectCellModel.h"

@protocol EntrySelectCellDelegate <NSObject>

-(void)tabviewNeedReloadDataForIndexPath:(NSIndexPath *)indexPath;

-(void)getSelectString:(NSString *)str WithStringRow:(NSUInteger)row WithIndexPath:(NSIndexPath *)indexPath;

-(void)plusSignHiddenCellClick;

@end

@interface EntrySelectCell : BaseTableViewCell
@property (nonatomic, strong) EntrySelectCellModel * entrySelectData;

@property (nonatomic,strong)NSIndexPath * indexPath;

@property (nonatomic, weak)id cellDelegate;

@end

@interface EntrySelectView : EntrySelectCell
-(CGFloat )loadViewWithEntrys:(NSArray *)entrys WithWidth:(CGFloat)width;
@end

@interface EntrySelectCellForConditionsForRetrievalVC : EntrySelectCell

-(CGFloat )loadViewWithEntrys:(NSArray *)entrys WithWidth:(CGFloat)width WithSelectStr:(NSString *)selectStr;
@end
