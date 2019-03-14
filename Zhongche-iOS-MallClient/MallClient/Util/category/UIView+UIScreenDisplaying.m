//
//  UIView+UIScreenDisplaying.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/12/5.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "UIView+UIScreenDisplaying.h"

@implementation UIView (UIScreenDisplaying)
// 判断View是否显示在屏幕上

- (BOOL)isDisplayedInScreen

{
    
    if (self == nil) {
        
        return NO;
        
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    
    CGRect rect = [self convertRect:self.frame fromView:nil];
    
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        
        return NO;
        
    }
    
    // 若view 隐藏
    
    if (self.hidden) {
        
        return NO;
        
    }
    
    // 若没有superview
    
    if (self.superview == nil) {
        
        return NO;
        
    }
    
    // 若size为CGrectZero
    
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        
        return NO;
        
    }
    
    // 获取 该view与window 交叉的 Rect
    
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        
        return NO;
        
    }
    
    return YES;
    
}
@end
