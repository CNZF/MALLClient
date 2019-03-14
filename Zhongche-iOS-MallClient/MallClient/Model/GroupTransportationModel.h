//
//  GroupTransportationModel.h
//  MallClient
//
//  Created by lxy on 2017/2/17.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"
#import "TransportationModel.h"

@interface GroupTransportationModel : BaseModel

@property (nonatomic, strong) NSMutableArray *arrTransportationModel;
@property (nonatomic, strong) NSString *expectTime;
@property (nonatomic, strong) NSString *departureTime;
@property (nonatomic, strong) NSString *ticketTotal;
@property (nonatomic, strong) NSString *lineType;

@end
