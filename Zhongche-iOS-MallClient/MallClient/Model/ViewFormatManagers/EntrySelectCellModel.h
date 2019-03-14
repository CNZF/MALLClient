//
//  EntrySelectCellModel.h
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/28.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"

@interface EntrySelectCellModel : BaseModel

@property (nonatomic, strong)NSMutableArray * entrys;

@property (nonatomic, assign)BOOL cellCloseOrOpen;

@property (nonatomic, assign)double cellHeightOpen;

@property (nonatomic, assign)double cellHeightClose;

@property (nonatomic,assign)BOOL  plusSignHidden;//default is YES

@property (nonatomic, copy)NSString * selectStr;
@end
