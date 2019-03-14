//
//  FilterModel.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/20.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"
#import "CityModel.h"
#import "ContainerTypeModel.h"

typedef enum {
    new100,
    new75,
    new50,
    new25,
    new0,//未选择状态
}boxCondition;

@interface FilterModel : BaseModel

@property (nonatomic, strong)CityModel * city;

@property (nonatomic, strong)NSDate * startTime;
@property (nonatomic, strong)NSDate * endTime;

@property (nonatomic, strong)ContainerTypeModel * container;
@property (nonatomic, assign)boxCondition containerCondition;

@property (nonatomic, assign)int currentPage;//加载?页数据
@property (nonatomic, assign)int pageSize;//每页大小

@property (nonatomic, copy)NSString * saleType;//租用or购买
@property (nonatomic, assign)int useNumberSort;//数量排序方式
@property (nonatomic, assign)int isAuthenticated;//是否认证
//@property (nonatomic, copy)NSString * location;//位置
//@property (nonatomic, assign)int containerTypeId;//箱型id
//@property (nonatomic, copy)NSString * containerStatus;//箱况
@end
