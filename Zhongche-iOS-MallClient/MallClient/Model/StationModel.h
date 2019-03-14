//
//  StationModel.h
//  MallClient
//
//  Created by lxy on 2017/3/23.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"

@interface StationModel : BaseModel

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *region_code;

@end
