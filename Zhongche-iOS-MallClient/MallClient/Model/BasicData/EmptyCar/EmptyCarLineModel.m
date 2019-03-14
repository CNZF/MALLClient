//
//  EmptyCarLineModel.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/31.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "EmptyCarLineModel.h"

@implementation EmptyCarLineModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID":@"id"
             };
}

-(NSString *)lineStr {
    NSString * line = @"";
    if(self.startParentAddress) {
        line = [NSString stringWithFormat:@"%@%@",line,self.startParentAddress];
    }
    if(self.startCity) {
        line = [NSString stringWithFormat:@"%@%@",line,self.startCity];
    }
    line = [NSString stringWithFormat:@"%@ - ",line];
    if (self.endParentAddress) {
        line = [NSString stringWithFormat:@"%@%@",line,self.endParentAddress];
    }
    if (self.endCity) {
        line = [NSString stringWithFormat:@"%@%@",line,self.endCity];
    }
    
    return line;
}
@end
