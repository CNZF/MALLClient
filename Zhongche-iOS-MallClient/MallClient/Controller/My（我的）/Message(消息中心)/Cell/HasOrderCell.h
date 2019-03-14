//
//  HasOrderCell.h
//  MallClient
//
//  Created by lxy on 2018/6/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

//typedef enum MessageTypeEunm {
//    MESSAGE_REGIST_SUCESSED  = 0, //注册成功通知
//    MESSAGE_PASSWORD_RESET, //密码重置通知"
//    MESSAGE_PERMISSION_RESET, //"权限变更通知")
//    MESSAGE_ORDER, //"订单消息
//    MESSAGE_PAY, //支付消息
//    MESSAGE_DELIVER, //发货消息
//    MESSAGE_AUTH, //"认证消息
//    MESSAGE_TRANSPORT_REQUIREMENT  //需求申报消息
//} MessageTypeEnum;

typedef NS_ENUM(NSUInteger, MessageTypeEnum) {
    MESSAGE_REGIST_SUCESSED = 0,
    MESSAGE_PASSWORD_RESET, //密码重置通知"
    MESSAGE_PERMISSION_RESET, //"权限变更通知")
    MESSAGE_ORDER, //"订单消息
    MESSAGE_PAY, //支付消息
    MESSAGE_DELIVER, //发货消息
    MESSAGE_AUTH, //"认证消息
    MESSAGE_TRANSPORT_REQUIREMENT,  //需求申报消息,
};

@interface HasOrderCell : UITableViewCell
@property (nonatomic, strong) MessageModel * model;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isEdite;
@property (nonatomic, assign)MessageTypeEnum  messageEnum;
@end


