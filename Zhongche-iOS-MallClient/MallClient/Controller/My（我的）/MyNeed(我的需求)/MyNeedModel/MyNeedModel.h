//
//  MyNeedModel.h
//  MallClient
//
//  Created by lxy on 2018/9/6.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"
#import "NSString+Money.h"
@interface MyNeedModel : BaseModel

@property (nonatomic, copy)NSString *  business_type_code;
@property (nonatomic, copy)NSString *  business_type_name;
@property (nonatomic, copy)NSString *  code;
@property (nonatomic, copy)NSString *  contacts;
@property (nonatomic, copy)NSString *  contacts_phone;
@property (nonatomic, copy)NSString *  create_time;
@property (nonatomic, copy)NSString *  create_user_id;
@property (nonatomic, copy)NSString *  create_user_name;//托运人

@property (nonatomic, copy)NSString *  delivery_type_code;
@property (nonatomic, copy)NSString *  end_region_code;
@property (nonatomic, copy)NSString *  end_region_name;
@property (nonatomic, copy)NSString *  estimate_departure_time;
@property (nonatomic, copy)NSString *  goods_code;
@property (nonatomic, copy)NSString *  goods_name;
@property (nonatomic, copy)NSString *  ID;
@property (nonatomic, copy)NSString *  province_end_region_name;
@property (nonatomic, copy)NSString *  province_start_region_name;
@property (nonatomic, copy)NSString *  start_region_code;
@property (nonatomic, copy)NSString *  start_region_name;
@property (nonatomic, copy)NSString *  status;
@property (nonatomic, copy)NSString *  statusName;

@property (nonatomic, copy)NSString *  end_address;
@property (nonatomic, copy)NSString *  end_contacts;
@property (nonatomic, copy)NSString *  end_phone;
@property (nonatomic, copy)NSString *  start_address;
@property (nonatomic, copy)NSString *  start_contacts;
@property (nonatomic, copy)NSString *  start_phone;
@property (nonatomic, copy)NSString *  container_id;
@property (nonatomic, copy)NSString *  container_number;//箱数
@property (nonatomic, copy)NSString *  container_type_name;
@property (nonatomic, copy)NSString *  volume;
@property (nonatomic, copy)NSString *  weight;//重量
@property (nonatomic, copy)NSString *  vehicle_num;//台数
@property (nonatomic, copy)NSString *  vehicle_type;//车辆类型
@property (nonatomic, copy)NSString *  unit_max_weight;//最大单件重量
@property (nonatomic, copy)NSString *  unit_max_length;//最大单件重量
@property (nonatomic, copy)NSString *  unit_max_width;//最大单件重量
@property (nonatomic, copy)NSString *  unit_max_high;//最大单件重量
@property (nonatomic, copy)NSString *  wrapper_number;//最大单件重量
@end
//"business_type_code" = "BUSINESS_TYPE_BULK_STACK";
//"business_type_name" = "\U6563\U5806\U88c5";
//code = TR2018090616053400001;
//contacts = ccc;
//"contacts_phone" = 14725802580;
//"create_time" = 1536221134000;
//"create_user_id" = 279;
//"create_user_name" = "\U7ebf\U4e0a\U6d4b\U8bd5\U4f01\U4e1a\U8d26\U53f7";
//"delivery_type_code" = "DELIVERY_TYPE_POINT_POINT";
//"end_region_code" = 310100;
//"end_region_name" = "\U4e0a\U6d77";
//"estimate_departure_time" = 1536825867000;
//"goods_code" = 1551019;
//"goods_name" = "\U805a\U6c2f\U4e59\U70ef";
//id = 31;
//"province_end_region_name" = "\U4e0a\U6d77";
//"province_start_region_name" = "\U65b0\U7586";
//"start_region_code" = 650100;
//"start_region_name" = "\U4e4c\U9c81\U6728\U9f50";
//status = 1;
//volume = 44;
//weight = 55;

//"business_type_code" = "BUSINESS_TYPE_BULK_STACK";
//"business_type_name" = "\U6563\U5806\U88c5";
//code = TR2018090311234500009;
//contacts = fhhh;
//"contacts_phone" = 14725802147;
//"create_time" = 1535945025000;
//"create_user_id" = 279;
//"create_user_name" = "\U7ebf\U4e0a\U6d4b\U8bd5\U4f01\U4e1a\U8d26\U53f7";
//"delivery_type_code" = "DELIVERY_TYPE_DOOR_DOOR";
//"end_address" = "\U5929\U6cb3\U57ce\U767e\U8d27(\U5929\U6cb3\U57ce)";
//"end_contacts" = "\U59d0\U59d0";
//"end_phone" = 15687456325;
//"end_region_code" = 150500;
//"end_region_name" = "\U901a\U8fbd";
//"estimate_departure_time" = 1535945016000;
//"goods_code" = 0110006;
//"goods_name" = "\U539f\U7164";
//id = 25;
//"province_end_region_name" = "\U5185\U8499\U53e4";
//"province_start_region_name" = "\U5185\U8499\U53e4";
//"start_address" = "\U664f\U57ce\U7ad9";
//"start_contacts" = "\U6f33\U5dde";
//"start_phone" = 13333333333;
//"start_region_code" = 152500;
//"start_region_name" = "\U9521\U6797\U90ed\U52d2";
//status = 1;
//volume = 3;
//weight = 7;
