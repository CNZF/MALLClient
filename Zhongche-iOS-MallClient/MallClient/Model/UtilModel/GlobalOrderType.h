//
//  GlobalOrderType.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/4/14.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalOrderType : NSObject
@property (nonatomic , copy)NSString * orderType;
@property (nonatomic , assign)BOOL whetherTheAvailable;//!该类仅可用一次,一旦订单中心页面显示过该对象立即编程不可用状态
+(GlobalOrderType *)shareGlobalOrderType;
@end
