//
//  OrderAlertView.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/4/10.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseView.h"

@interface OrderAlertView : BaseView

-(instancetype)initWithTitle:(NSString *)title entryArray:(NSArray<NSString *>*)entry annotation:(id)annotation
           cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)buttonTitle;
-(void)show;
@end
