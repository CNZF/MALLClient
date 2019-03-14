//
//  UserInfoCellModel.m
//  MallClient
//
//  Created by iOS_Developers_LL on 07/02/2017.
//  Copyright © 2017 com.zhongche.cn. All rights reserved.
//

#import "UserInfoCellModel.h"

@implementation UserInfoCellModel

-(instancetype)initWithClassStr:(NSString *)classStr withCellHeight:(int)cellHeight withAccessoryType:(UITableViewCellAccessoryType)accessoryType withTitleStr:(NSString *)titleStr withImgStr:(NSString *)imgStr withDetailsStr:(NSString *)detailsStr withCellLineHidden:(BOOL)cellLineHidden
{
    self = [super init];
    if (self) {
        _btnHidden = YES;
        self.classStr = classStr;
        self.cellHeight = cellHeight;
        self.accessoryType = accessoryType;
        self.titleStr = titleStr;
        self.imgStr = imgStr;
        self.detailsStr = detailsStr;
        self.cellLineHidden = cellLineHidden;
    }
    return self;
}
@end
