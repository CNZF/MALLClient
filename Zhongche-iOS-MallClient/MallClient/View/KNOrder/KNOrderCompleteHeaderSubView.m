//
//  KNOrderCompleteHeaderSubView.m
//  MallClient
//
//  Created by 沙漠 on 2018/4/26.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNOrderCompleteHeaderSubView.h"

@interface KNOrderCompleteHeaderSubView ()

@end

@implementation KNOrderCompleteHeaderSubView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.dayButton.layer.borderColor = [HelperUtil colorWithHexString:@"00A1FA"].CGColor;
    self.dayButton.layer.borderWidth = 1.0;
}


@end
