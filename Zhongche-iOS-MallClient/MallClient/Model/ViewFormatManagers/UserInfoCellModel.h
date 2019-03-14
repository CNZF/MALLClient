//
//  UserInfoCellModel.h
//  MallClient
//
//  Created by iOS_Developers_LL on 07/02/2017.
//  Copyright © 2017 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoCellModel : BaseModel

@property (nonatomic, copy)NSString * classStr;
@property (nonatomic, assign)int cellHeight;
@property (nonatomic, assign)UITableViewCellAccessoryType    accessoryType;
@property (nonatomic, copy)NSString * titleStr;
@property (nonatomic, copy)NSString * imgStr;
@property (nonatomic, copy)NSString * detailsStr;

@property (nonatomic, assign)BOOL cellLineHidden;

@property (nonatomic, assign)BOOL btnHidden;

-(instancetype)initWithClassStr:(NSString *)classStr withCellHeight:(int)cellHeight withAccessoryType:(UITableViewCellAccessoryType)accessoryType withTitleStr:(NSString *)titleStr withImgStr:(NSString *)imgStr withDetailsStr:(NSString *)detailsStr withCellLineHidden:(BOOL)cellLineHidden;

@end
