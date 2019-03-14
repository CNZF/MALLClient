//
//  NoTransDataView.m
//  MallClient
//
//  Created by lxy on 2018/7/18.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "NoTransDataView.h"


@interface NoTransDataView ()
@property (weak, nonatomic) IBOutlet UIButton *dxBtn;

@end

@implementation NoTransDataView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.dxBtn.layer.cornerRadius = 22.0f;
    self.dxBtn.layer.masksToBounds = YES;
}
- (IBAction)pressDzBtn:(id)sender {
    if (self.block) {
        self.block(0);
    }
    
}
- (IBAction)presstelBtn:(id)sender {
    if (self.block) {
        self.block(1);
    }
}

@end
