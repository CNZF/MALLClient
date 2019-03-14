//
//  KNResultDetailHeaderView.m
//  MallClient
//
//  Created by dushenke on 2018/4/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNResultDetailHeaderView.h"

@interface KNResultDetailHeaderView ()

@end

@implementation KNResultDetailHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dateBGView.layer.borderWidth = 0.5;
    self.dateBGView.layer.cornerRadius = 2.0;
    self.dateBGView.layer.masksToBounds = YES;
    self.dateBGView.layer.borderColor = APP_COLOR_GRAY_CAPACITY_LINE.CGColor;
}


@end
