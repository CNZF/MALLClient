//
//  CityModel.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/14.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseModel.h"

typedef enum {
    city = 1,
    branches = 2
    
}Type;

@interface CityModel : BaseModel


/**
 *  {
 centerLat = "39.90403";
 centerLng = "116.407526";
 code = 110100;
 fullName = "\U5317\U4eac\U5e02\U5317\U4eac\U5e02";
 geoArea = "\U534e\U5317";
 id = 2;
 level = 2;
 name = "\U5317\U4eac";
 parentCode = 110000;
 }
 */

@property (nonatomic, strong) NSString * centerLat;
@property (nonatomic, strong) NSString * centerLng;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSString * fullName;
@property (nonatomic, strong) NSString * geoArea;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * parentCode;
@property (nonatomic, strong) NSString * startPinyin;
@property (nonatomic, assign) Type     modelType;
@property (nonatomic, strong) NSString *entrepotType;//网点属性，城市null

@property (nonatomic, strong) NSString *regionName;//网点城市名

@end
