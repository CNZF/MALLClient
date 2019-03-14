//
//  MessageModel.m
//  MallClient
//
//  Created by lxy on 2018/6/29.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isSelect = NO;
        self.isEdite = NO;
    }
    return self;
}

- (MessageModel *)initWithDictionary:(NSDictionary *)dic
{
    MessageModel * model = [MessageModel new];
    model.body = dic[@"body"];
    model.ID = dic[@"id"];
    model.message_categroy_code = dic[@"message_categroy_code"];
    model.readStatus = dic[@"readStatus"];
    model.send_time = dic[@"send_time"];
    model.send_type = dic[@"send_type"];
    model.send_user_id = dic[@"send_user_id"];
    model.summary_info = dic[@"summary_info"];
    model.title = dic[@"title"];
    model.type = dic[@"type"];
    model.status = dic[@"status"];
    
    return model;
}

@end
