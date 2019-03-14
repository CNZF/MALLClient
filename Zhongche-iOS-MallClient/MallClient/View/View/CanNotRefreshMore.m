//
//  CanNotRefreshMore.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2016/12/20.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "CanNotRefreshMore.h"
@interface CanNotRefreshMore()
@end
@implementation CanNotRefreshMore

#pragma mark - 懒加载子控件

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    [self setNeedsLayout];
}
#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

@end
