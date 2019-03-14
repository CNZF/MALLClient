//
//  OrderAlertViCell.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/4/10.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "OrderAlertViCell.h"

@interface OrderAlertViCell()

@property (nonatomic, strong)UIView * lineVi;

@end

@implementation OrderAlertViCell

-(void)bindView {
    self.lineVi.frame = CGRectMake(0, 43, SCREEN_W - 60, 1);
    [self addSubview:self.lineVi];
}

-(UIView *)lineVi {
    if (!_lineVi) {
        UIView * vi= [UIView new];
        vi.backgroundColor = APP_COLOR_WHITEBG;
        _lineVi = vi;
    }
    return _lineVi;
}
@end
