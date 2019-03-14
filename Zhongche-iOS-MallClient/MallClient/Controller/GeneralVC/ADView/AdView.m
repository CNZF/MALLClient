//
//  AdView.m
//  MallClient
//
//  Created by lxy on 2018/8/4.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "AdView.h"

@implementation AdView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addChild];
    }
    return self;
}


- (void)addChild
{
    //图片
    UIImageView * adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    int imageIndex = arc4random()%4+1;
    adImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ad%i",imageIndex]];
    adImageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onadViewSelect)];
//    [adImageView addGestureRecognizer:tap];
    [self addSubview:adImageView];
    
    //跳过按钮
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREEN_W-80,kNavBarHeaderHeight - 44,70 , 40);
    [btn setTitle:@"跳过 3" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onadViewSelect) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    [self countDownFromTime:btn];
}

- (void)countDownFromTime:(UIButton *)button
{
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [button setEnabled:NO];
//        [self setTitle:[NSString stringWithFormat:@"%lds后重发", (long)time] forState:UIControlStateDisabled];
//    });
    //倒计时时间
    __block NSInteger timeOut = 3;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(__timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(__timer, ^{
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(__timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self onadViewSelect];
            });
        } else {
            NSInteger seconds = timeOut--;
            NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self setEnabled:NO];
                [button setTitle:[NSString stringWithFormat:@"%@ %ld",@"跳过",seconds] forState:UIControlStateNormal];
            });
        }
    });
    dispatch_resume(__timer);
}

- (void)onadViewSelect
{
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADVIEWMISS" object:nil];
    __timer = nil;
}
@end
