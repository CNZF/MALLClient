//
//  MessageBottomView.m
//  MallClient
//
//  Created by lxy on 2018/7/2.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "MessageBottomView.h"

@interface MessageBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *allSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *delegateBtn;

@end

@implementation MessageBottomView

- (void)setSelectBtnState
{
    self.allSelectBtn.selected = NO;
}

- (IBAction)pressAllSelectBtn:(id)sender {
    self.allSelectBtn.selected = !self.allSelectBtn.selected;
    if (self.block) {
        self.block(self.allSelectBtn.selected);
    }
}
- (IBAction)pressDelegateBtn:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock(@"delete");
    }
}
- (IBAction)pressRead:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock(@"read");
    }
}

@end
