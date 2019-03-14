//
//  OrderDetailHeadView.h
//  MallClient
//
//  Created by lxy on 2018/6/6.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModelForCapacity.h"

 
@interface OrderDetailHeadView : UIView
@property (nonatomic, strong) OrderModelForCapacity * model;
@property (nonatomic, copy) void(^ClickBlcok)(UIImage *image);

@end
