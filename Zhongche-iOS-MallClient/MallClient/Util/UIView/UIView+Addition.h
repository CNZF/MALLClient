//
//  UIView+Addition.h
//  BaseProject
//
//  Created by zhangrongbing on 2016/10/12.
//  Copyright © 2016年 lovcreate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kScreenWidthRatio [UIScreen mainScreen].bounds.size.width / 375.f
#define kScreenHeightRatio [UIScreen mainScreen].bounds.size.height / 667.f

@interface UIView (Addition)


@property (assign, nonatomic) CGFloat lc_x;
@property (assign, nonatomic) CGFloat lc_y;
@property (assign, nonatomic) CGFloat lc_w;
@property (assign, nonatomic) CGFloat lc_h;
@property (assign, nonatomic) CGFloat lc_b;
@property (assign, nonatomic, readonly) CGFloat lc_r;
@property (assign, nonatomic) CGSize lc_size;
@property (assign, nonatomic) CGPoint lc_origin;
@property (assign, nonatomic) CGPoint lc_center;

-(void)lc_setCornerRadius:(CGFloat)radius;
-(void)lc_setCornerRadius:(CGFloat)radius cornerRadii:(UIRectCorner)cornerRadii;

@end
