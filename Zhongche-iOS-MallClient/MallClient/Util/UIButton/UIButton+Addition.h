//
//  UIButton+Addition.h
//  BaseProject
//
//  Created by zhangrongbing on 2016/12/5.
//  Copyright © 2016年 lovcreate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Addition)

//倒计时
-(void)lc_countDownFromTime:(NSInteger)time title:(NSString*)title countDownTitle:(NSString*)countDownTitle handler:(void(^)(void)) handler;

@end

