//
//  GudePageVi.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/2/21.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "GudePageVi.h"

@interface GudePageVi()

@property (nonatomic, strong)UIScrollView * scrollVi;

@property (nonatomic, strong)UIButton * removeBtn;

@end

@implementation GudePageVi

-(void)binView
{
    self.scrollVi.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.scrollVi];
}

-(UIScrollView *)scrollVi
{
    if (!_scrollVi) {
        UIScrollView * scr = [UIScrollView new];
        scr.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        scr.backgroundColor = APP_COLOR_WHITE;
        scr.bounces = NO;
        scr.contentSize = CGSizeMake(SCREEN_W * 3,SCREEN_H);
        scr.showsHorizontalScrollIndicator = NO;
        scr.showsVerticalScrollIndicator = NO;
        scr.pagingEnabled = YES;
        CGPoint point = {0,0};
        scr.contentOffset = point;
        
        UIImageView * igv;
        for (int i = 0 ; i < 3; i ++) {
            igv = [[UIImageView alloc]initWithFrame:CGRectMake(i * SCREEN_W, 0, SCREEN_W, SCREEN_H)];
            igv.image = [UIImage imageNamed:[NSString stringWithFormat:@"引导页%d.jpg",i+1]];
            NSLog(@"%@",[NSString stringWithFormat:@"%dx%d-%d",(int)SCREEN_W,(int)SCREEN_H,i+1]);
            [scr addSubview:igv];
        }
        
        self.removeBtn.frame = CGRectMake(SCREEN_W * 2 + 100* SCREEN_W_COEFFICIENT,SCREEN_H - 108*SCREEN_H_COEFFICIENT,SCREEN_W - 200* SCREEN_W_COEFFICIENT, 60);
        
        [scr addSubview:self.removeBtn];
        _scrollVi = scr;
    }
    return _scrollVi;
}

-(UIButton *)removeBtn
{
    if (!_removeBtn) {
        UIButton * btn = [UIButton new];
        
        [btn addTarget:self action:@selector(removeWindowsView) forControlEvents:UIControlEventTouchDown];
        _removeBtn = btn;
    }
    return _removeBtn;
}

- (void)removeWindowsView
{
    [self removeFromSuperview];
    if (self.guideBlock) {
        self.guideBlock();
    }
}
@end
