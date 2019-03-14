//
//  ViImg.m
//  MallClient
//
//  Created by lxy on 2017/2/23.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "ViImg.h"

@implementation ViImg

-(void)binView {

    self.backgroundColor = [UIColor blackColor];

    UIImageView *iv = [UIImageView new];
    iv.image = [UIImage imageNamed:@"yulan.jpg"];
    iv.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_W *2);

    UIButton *btnCancle = [UIButton new];
    [btnCancle setBackgroundImage:[UIImage imageNamed:@"Cancle"] forState:UIControlStateNormal];
    [btnCancle addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];

    btnCancle.frame = CGRectMake(5, 20, 25, 25);

    [self addSubview:iv];
    [self addSubview:btnCancle];
}

- (void) cancleAction{

    [self removeFromSuperview];
}

@end
