//
//  CustomButton.h
//  Sloth
//
//  Created by 张熔冰 on 2017/9/5.
//  Copyright © 2017年 Lovcreate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Addition.h"
//IB_DESIGNABLE

@interface CustomButton : UIButton

@property(nonatomic, strong) NSString* badgeValue;

/**
 公用按钮样式
 */
@property(nonatomic, assign) IBInspectable BOOL isMainStyleButton;

/**
 左侧title
 */
@property(nonatomic, assign) IBInspectable BOOL styleLeft;


/**
 底部title
 */
@property(nonatomic, assign) IBInspectable BOOL styleBottom;

@end
