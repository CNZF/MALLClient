//
//  OrderDetailAdjectiveView.h
//  MallClient
//
//  Created by lxy on 2018/6/8.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModelForCapacity.h"

 typedef void(^AdjectBlock)(void);
@interface OrderDetailAdjectiveView : UIView

@property (nonatomic, strong) OrderModelForCapacity * model;

@property (nonatomic, strong) AdjectBlock block;

- (void) setNewModel:(OrderModelForCapacity * )model WithModel:(OrderModelForCapacity *)oldModel;

@end
