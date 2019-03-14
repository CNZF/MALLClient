//
//  OrderModelForEmptyContainer.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/4/5.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "OrderModelForEmptyContainer.h"
#import "OrderProgressModel.h"

@implementation OrderModelForEmptyContainer


/**
 *   STATUS = 7;
 containerOrderCode = CO2017040110232800000;
 containerOrderId = 25;
 containerType = "20\U82f1\U5c3a\U901a\U7528\U96c6\U88c5\U7bb1";
 "create_time" = 1491013408000;
 endDate = 1491128536000;
 number = 1;
 payable = 550;
 "photo_url" = "/container/1490607390301.png";
 saleTypeCode = "CONTAINER_RENTSALE_TYPE_RENT";
 sellerName = "\U60c5\U4eba\U8282\U6d4b\U8bd5";
 sellerPhone = 18810325947;
 startDate = 1491042136000;
 *

 */

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"orderState":@[@"STATUS",@"statusName"],
             @"orderID":@"containerOrderCode",
             @"containerType":@"containerType",

             @"endTime":@"endDate",
             @"containerNum":@"number",
             @"price":@"payable",
             @"ID":@"containerOrderId",

             @"imgUrl":@"photo_url",
             @"orderType":@"saleTypeCode",
             @"companyName":@"sellerName",
             @"phone":@"sellerPhone",
             @"startTime":@"startDate",

             @"peopelName":@"buyerContactsName",
             @"buyersAddress":@"receiveAddress",
             @"sellerAddress":@"givebackAddress",
             @"containerPrice":@"salePrice",
             @"mortgage":@"depositPrice",
             @"giveBackPrice":@"offsiteReturnBoxPrice",
             @"orderProgress":@"orderProcess",
             @"imgUrlList":@"photoUrl"

             };
}

-(void)setOrderProgress:(NSArray *)orderProgress {
    NSMutableArray * arr = [NSMutableArray new];
    for (NSDictionary * dict in orderProgress) {
        [arr addObject:[OrderProgressModel yy_modelWithJSON:dict]];

    }
    _orderProgress = arr;
}

-(void)setContainerState:(int)containerState {

    switch (containerState) {
        case 1:
            self.containerCondition = @"新造箱";
            break;
        case 2:
            self.containerCondition = @"完好在用箱";
            break;
        case 3:
            self.containerCondition = @"轻微瑕疵在用箱";
            break;
        case 4:
            self.containerCondition = @"破损在用箱";
            break;

        default:
            break;
    }

    _containerState = containerState;
}

-(void)setOrderType:(NSString *)orderType {
    if ([orderType isEqualToString:@"CONTAINER_RENTSALE_TYPE_RENT"]) {
        _orderType = @"租赁";
        _orderTypeEnum = rentContainer;

    }else if ([orderType isEqualToString:@"CONTAINER_RENTSALE_TYPE_SALE"])
    {
        _orderType = @"购买";
        _orderTypeEnum = buyContainer;
    }
}

-(void)setImgUrlList:(id)imgUrlList{
    if ([imgUrlList isKindOfClass:[NSString class]]) {
        NSArray *arrImg = [imgUrlList componentsSeparatedByString:@"☼"];
        self.imgUrl = arrImg[0];
    }
}
@end
