//
//  BoxModel.h
//  MallClient
//
//  Created by lxy on 2018/6/13.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"

@interface BoxModel : BaseModel

//category = "35t\U901a\U7528\U96c6\U88c5\U7bb1";
//containerSizeTypeCode = "CONTAINER_SIZE_TYPE_35";
//containerTypeCode = "CONTAINER_TYPE_NONSTANDARD";
//containerTypeId = 1;
//createTime = 1471866539000;
//createUserId = 1;
//factor = 20;
//id = 2;
//insideHeight = 2698;
//insideLength = 5898;
//insideWidth = 2464;
//loadWeight = "32.5";
//name = "20\U82f1\U5c3a35t\U655e\U9876\U7bb1";
//outsideHeight = 2896;
//outsideLength = 6058;
//outsideWidth = 2550;
//priceBaseContainer = 0;
//remark = "";
//selfWeight = "2.5";
//shortName = "";
//status = 1;
//totalWeight = 35;
//volume = "39.2";

@property (nonatomic, copy)NSString * category;
@property (nonatomic, copy)NSString * containerSizeTypeCode;
@property (nonatomic, copy)NSString * containerTypeCode;
@property (nonatomic, copy)NSString * containerTypeId;
@property (nonatomic, copy)NSString * createTime;
@property (nonatomic, copy)NSString * createUserId;
@property (nonatomic, copy)NSString * factor;
@property (nonatomic, copy)NSString * insideHeight;
@property (nonatomic, copy)NSString * insideLength;
@property (nonatomic, copy)NSString * loadWeight;
@property (nonatomic, copy)NSString * name;
@property (nonatomic, copy)NSString * outsideHeight;
@property (nonatomic, copy)NSString * outsideLength;
@property (nonatomic, copy)NSString * priceBaseContainer;
@property (nonatomic, copy)NSString * totalWeight;
@property (nonatomic, copy)NSString * volume;

@end
