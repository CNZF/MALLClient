//
//  UIButton+Addition.m
//  BaseProject
//
//  Created by zhangrongbing on 2016/12/5.
//  Copyright © 2016年 lovcreate. All rights reserved.
//

#import "UIButton+Addition.h"
#import <objc/runtime.h>
#import "UIImage+Addition.h"

@implementation UIButton (Addition)

-(void)lc_countDownFromTime:(NSInteger)time title:(NSString*)title countDownTitle:(NSString*)countDownTitle handler:(void(^)(void)) handler{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setEnabled:NO];
        [self setTitle:[NSString stringWithFormat:@"%lds后重发", (long)time] forState:UIControlStateDisabled];
    });
    //倒计时时间
    __block NSInteger timeOut = time;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setEnabled:YES];
                if (handler) {
                    handler();
                }
            });
        } else {
            NSInteger seconds = --timeOut % (time + 1);
            NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setEnabled:NO];
                [self setTitle:[NSString stringWithFormat:@"%@%@",timeStr,countDownTitle] forState:UIControlStateDisabled];
            });
        }
    });
    dispatch_resume(_timer);
}

@end

