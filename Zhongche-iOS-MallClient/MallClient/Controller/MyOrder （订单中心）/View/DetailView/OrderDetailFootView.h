//
//  OrderDetailFootView.h
//  MallClient
//
//  Created by lxy on 2018/6/7.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModelForCapacity.h"

typedef enum : NSUInteger {
    PressDetailBTN,
    PressLeftBTN,
    PressRightBTN,
} PressSelectState;

 typedef void(^PressBlock)(BOOL isShow);
 typedef void(^CancelBlock)(OrderModelForCapacity * orderModel);
@interface OrderDetailFootView : UIView

@property (nonatomic, strong) OrderModelForCapacity * model;
@property (nonatomic, copy)PressBlock block;//点击当前视图
@property (nonatomic, copy)CancelBlock cancelBlock;
@property (assign,nonatomic) BOOL isShow;
@property (nonatomic, strong) id targat;

@end
