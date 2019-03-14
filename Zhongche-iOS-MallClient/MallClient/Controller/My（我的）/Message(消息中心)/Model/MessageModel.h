//
//  MessageModel.h
//  MallClient
//
//  Created by lxy on 2018/6/29.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic, assign) BOOL  isSelect;
@property (nonatomic, assign) BOOL  isEdite;

@property (nonatomic, copy)NSString * readStatus;
@property (nonatomic, copy)NSString * send_time;
@property (nonatomic, copy)NSString * status;
@property (nonatomic, copy)NSString * ID;
@property (nonatomic, copy)NSString * send_type;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * message_categroy_code;
@property (nonatomic, copy)NSString * type;
@property (nonatomic, copy)NSString * body;
@property (nonatomic, copy)NSString * send_user_id;
@property (nonatomic, copy)NSString * summary_info;

- (MessageModel *)initWithDictionary:(NSDictionary *)dic;

@end
