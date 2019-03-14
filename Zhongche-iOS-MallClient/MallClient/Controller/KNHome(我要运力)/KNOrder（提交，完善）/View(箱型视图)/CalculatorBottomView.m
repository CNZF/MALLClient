//
//  CalculatorBottomView.m
//  MallClient
//
//  Created by lxy on 2018/6/13.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "CalculatorBottomView.h"


@interface CalculatorBottomView()

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, assign) NSInteger index;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@end

@implementation CalculatorBottomView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.finishBtn.layer.cornerRadius = 4.0f;
    self.finishBtn.layer.masksToBounds = YES;
    self.btn1.layer.cornerRadius = 4.0f;
    self.btn1.layer.masksToBounds = YES;
    self.btn2.layer.cornerRadius = 4.0f;
    self.btn2.layer.masksToBounds = YES;
    self.btn3.layer.cornerRadius = 4.0f;
    self.btn3.layer.masksToBounds = YES;
  
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.titleArray = @[@"20英尺通用集装箱",@"20英尺53t敞顶箱",@"40英尺通用集装箱"];
    }
    return self;
}


- (IBAction)pressBtn1:(id)sender {
//    [self registBtnStatus];
//    self.btn1.layer.borderWidth = 1.0;
    [self.btn1 setTitleColor:APP_COLOR_Btn forState:UIControlStateNormal];
    self.btn1.layer.borderColor = APP_COLOR_Btn.CGColor;
    
    self.btn2.layer.borderColor = [HelperUtil colorWithHexString:@"666666"].CGColor;
    [self.btn2 setTitleColor:[HelperUtil colorWithHexString:@"666666"] forState:UIControlStateNormal];
    
    self.btn3.layer.borderColor = [HelperUtil colorWithHexString:@"666666"].CGColor;
    [self.btn3 setTitleColor:[HelperUtil colorWithHexString:@"666666"] forState:UIControlStateNormal];
    
    self.index = 0;
}
- (IBAction)pressBtn2:(id)sender {
//    [self registBtnStatus];
    [self.btn1 setTitleColor:[HelperUtil colorWithHexString:@"666666"] forState:UIControlStateNormal];
    self.btn1.layer.borderColor = [HelperUtil colorWithHexString:@"666666"].CGColor;
    
    self.btn2.layer.borderColor = APP_COLOR_Btn.CGColor;
    [self.btn2 setTitleColor:APP_COLOR_Btn forState:UIControlStateNormal];
    
    self.btn3.layer.borderColor = [HelperUtil colorWithHexString:@"666666"].CGColor;
    [self.btn3 setTitleColor:[HelperUtil colorWithHexString:@"666666"] forState:UIControlStateNormal];
    self.index = 1;
}
- (IBAction)pressBtn3:(id)sender {
//    [self registBtnStatus];
    [self.btn1 setTitleColor:[HelperUtil colorWithHexString:@"666666"] forState:UIControlStateNormal];
    self.btn1.layer.borderColor = [HelperUtil colorWithHexString:@"666666"].CGColor;
    
    self.btn2.layer.borderColor = [HelperUtil colorWithHexString:@"666666"].CGColor;
    [self.btn2 setTitleColor:[HelperUtil colorWithHexString:@"666666"] forState:UIControlStateNormal];
    
    self.btn3.layer.borderColor = APP_COLOR_Btn.CGColor;
    [self.btn3 setTitleColor:APP_COLOR_Btn forState:UIControlStateNormal];
    self.index = 2;
}

- (IBAction)pressFInishBtn:(id)sender {

    if (self.finishbBlock) {
        self.finishbBlock(self.index);
    }
}


- (void)setBoxModel:(BoxModel *)boxModel
{
    _boxModel = boxModel;
    if (!boxModel) {
        self.btn1.layer.borderWidth = 1.0f;
        self.btn1.layer.borderColor = [HelperUtil colorWithHexString:@"666666"].CGColor;
    
        self.btn2.layer.borderWidth = 1.0f;
        self.btn2.layer.borderColor = [HelperUtil colorWithHexString:@"666666"].CGColor;
        
        self.btn3.layer.borderWidth = 1.0f;
        self.btn3.layer.borderColor = [HelperUtil colorWithHexString:@"666666"].CGColor;
        
        [self.btn1 setTitleColor:[HelperUtil colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [self.btn2 setTitleColor:[HelperUtil colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [self.btn3 setTitleColor:[HelperUtil colorWithHexString:@"666666"] forState:UIControlStateNormal];
        return;
    }
    
    if ([self.boxModel.name isEqualToString:self.titleArray[0]]) {
        self.btn1.layer.borderWidth = 1.0;
        self.btn1.layer.borderColor = APP_COLOR_Btn.CGColor;
    }
    if ([self.boxModel.name isEqualToString:self.titleArray[1]]) {
        self.btn2.layer.borderWidth = 1.0;
        self.btn2.layer.borderColor = APP_COLOR_Btn.CGColor;
    }
    if ([self.boxModel.name isEqualToString:self.titleArray[2]]) {
        self.btn3.layer.borderWidth = 1.0;
        self.btn3.layer.borderColor = APP_COLOR_Btn.CGColor;
    }
}

//- (void)registBtnStatus
//{
//    self.btn1.layer.borderWidth = 0;
//    self.btn1.layer.borderColor = [UIColor clearColor].CGColor;
//    self.btn2.layer.borderWidth = 0;
//    self.btn2.layer.borderColor = [UIColor clearColor].CGColor;
//    self.btn3.layer.borderWidth = 0;
//    self.btn3.layer.borderColor = [UIColor clearColor].CGColor;
//}
@end
