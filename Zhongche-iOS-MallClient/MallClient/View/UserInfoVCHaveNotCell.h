//
//  UserInfoVCHaveNotCell.h
//  MallClient
//
//  Created by iOS_Developers_LL on 07/02/2017.
//  Copyright © 2017 com.zhongche.cn. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "UserInfoCellModel.h"

@protocol UserInfoVCHaveNotCellDeleGate <NSObject>

-(void)cellButtonDidSelectRowAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface UserInfoVCHaveNotCell : BaseTableViewCell

@property (nonatomic, strong)NSIndexPath * cellIndexPath;

@property (nonatomic, weak)id<UserInfoVCHaveNotCellDeleGate> cellDelegate;
@end
