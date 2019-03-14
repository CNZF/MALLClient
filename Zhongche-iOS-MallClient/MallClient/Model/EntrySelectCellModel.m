//
//  EntrySelectCellModel.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/28.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "EntrySelectCellModel.h"

@implementation EntrySelectCellModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.plusSignHidden = YES;
    }
    return self;
}
-(NSMutableArray *)entrys
{
    if (!_entrys) {
        _entrys = [NSMutableArray array];
    }
    return _entrys;
}
@end
