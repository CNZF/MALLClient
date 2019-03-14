//
//  AppDelegate.h
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/8.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModelForCapacity.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, copy) NSString * priceSuffix;//素材图片后缀

@property (nonatomic, strong) OrderModelForCapacity * model;
@property (nonatomic, strong)NSMutableDictionary * pinyinDictionary;

@property (nonatomic, assign) BOOL ShowOrderLeft;//暂用于判断订单界面是不是有tabbar
@property (nonatomic, assign) BOOL isClearCapModel;//暂用判断是否清空 定制运力的数据

@end

