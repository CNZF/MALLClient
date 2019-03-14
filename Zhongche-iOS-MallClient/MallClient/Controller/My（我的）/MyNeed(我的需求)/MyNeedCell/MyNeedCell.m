//
//  MyNeedCell.m
//  MallClient
//
//  Created by lxy on 2018/9/6.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "MyNeedCell.h"

@implementation MyNeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setNeedModel:(MyNeedModel *)needModel{
    _needModel = needModel;
    NSString * goodType;
    if ([needModel.business_type_name containsString:@"集装箱"]) {
//        goodName = model.goodsName;
        goodType = @"集装箱";
        self.typeLabel.backgroundColor = [UIColor colorWithRed:59/255.0f green:160/255.0f blue:243/255.0f alpha:0.2];
        self.typeLabel.textColor = [UIColor colorWithRed:59/255.0f green:160/255.0f blue:243/255.0f alpha:1];
    }else if ([needModel.business_type_name containsString:@"大件"]){
        goodType = @"大件";
//        goodName = model.goodsName;
        self.typeLabel.backgroundColor = [UIColor colorWithRed:217/255.0f green:72/255.0f blue:15/255.0f alpha:0.2];
        self.typeLabel.textColor = [UIColor colorWithRed:217/255.0f green:72/255.0f blue:15/255.0f alpha:1];
    }else if ([needModel.business_type_name containsString:@"散堆装"]){
//        goodName = model.goodsName;
        goodType = @"散堆装";
        self.typeLabel.backgroundColor = [UIColor colorWithRed:116/255.0f green:184/255.0f blue:22/255.0f alpha:0.2];
        self.typeLabel.textColor = [UIColor colorWithRed:116/255.0f green:184/255.0f blue:22/255.0f alpha:1];
    }else{
//        goodName = @"";
        goodType = @"商品车";
        self.typeLabel.backgroundColor = [UIColor colorWithRed:240/255.0f green:140/255.0f blue:0/255.0f alpha:0.2];
        self.typeLabel.textColor = [UIColor colorWithRed:240/255.0f green:140/255.0f blue:0/255.0f alpha:1];
    }
    
//     self.startLabel.text = goodType;
    self.orderNumLabel.text = needModel.code;
    self.startLabel.text = needModel.start_region_name;
    self.endLabel.text = needModel.end_region_name;
    self.tstateLabel.text = needModel.statusName;
    self.typeLabel.text = goodType;
    self.goodName.text = needModel.goods_name;
    
}
//"business_type_code" = "BUSINESS_TYPE_BULK_STACK";
//"business_type_name" = "\U6563\U5806\U88c5";---
//code = TR2018090616053400001;---
//contacts = ccc;
//"contacts_phone" = 14725802580;
//"create_time" = 1536221134000;
//"create_user_id" = 279;
//"create_user_name" = "\U7ebf\U4e0a\U6d4b\U8bd5\U4f01\U4e1a\U8d26\U53f7";
//"delivery_type_code" = "DELIVERY_TYPE_POINT_POINT";--
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
@end
