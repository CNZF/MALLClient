//
//  MenuView.h
//  Zhongche
//
//  Created by lxy on 16/7/11.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MenuView : UIView

 
+(instancetype)MenuViewWithDependencyView:(UIView *)dependencyView MenuView:(UIView *)leftmenuView isShowCoverView:(BOOL)isCover;

-(instancetype)initWithDependencyView:(UIView *)dependencyView MenuView:(UIView *)leftmenuView isShowCoverView:(BOOL)isCover;
    

-(void)show;

-(void)hidenWithoutAnimation;
-(void)hidenWithAnimation;

@end
