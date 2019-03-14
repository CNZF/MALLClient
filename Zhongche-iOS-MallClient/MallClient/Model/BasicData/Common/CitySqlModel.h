//
//  CitySqlModel.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/22.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"

@interface CitySqlModel : BaseModel

@property (nonatomic , assign) int      ID;
@property (nonatomic , assign) int      level;
@property (nonatomic , copy  ) NSString *code;
@property (nonatomic , copy  ) NSString *name;
@property (nonatomic , copy  ) NSString *parent_code;
@property (nonatomic , copy  ) NSString *full_name;
@property (nonatomic , copy  ) NSString *geo_area;
@property (nonatomic , copy  ) NSString *center_lat;
@property (nonatomic , copy  ) NSString *center_lng;

@end
