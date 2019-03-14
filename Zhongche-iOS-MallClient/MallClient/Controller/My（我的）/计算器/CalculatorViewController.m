//
//  CalculatorViewController.m
//  MallClient
//
//  Created by lxy on 2018/6/13.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBottomView.h"
#import "OrderViewModel.h"
#import "BoxModel.h"
#import "ZSSearchViewController.h"
#import "SXColorLabel.h"
#import "YMKJVerificationTools.h"

@interface CalculatorViewController ()<UITextFieldDelegate,ZSSearchViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UITextField *field;
@property (weak, nonatomic) IBOutlet UIButton *btn;//箱型
@property (weak, nonatomic) IBOutlet UIButton *goodsBtn;//货品
@property (weak, nonatomic) IBOutlet UIView *emptview;//遮罩

@property (weak, nonatomic) IBOutlet UILabel *weight;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UITextField *weightField;

@property (weak, nonatomic) IBOutlet UILabel *resultTitleLabel;//计算结果
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIButton *jisuanBtn;

@property (weak, nonatomic) IBOutlet UIImageView *jiantourignt;

@property (nonatomic, strong) CalculatorBottomView * bottomView;
@property (nonatomic, strong)UIView * BGView;
@property (nonatomic, strong)NSArray <BoxModel *> * boxArray;
@property (nonatomic, strong)BoxModel * boxModel;
@property (nonatomic, assign) NSInteger boxNum;//总箱数

@property (nonatomic, assign) BOOL spand;

@end

@implementation CalculatorViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"装箱计算器";
    [self.field setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.jisuanBtn.layer.cornerRadius = 4.0f;
    self.jisuanBtn.layer.masksToBounds = YES;
    
    self.resultTitleLabel.hidden = YES;
    self.resultLabel.hidden = YES;
    self.weightField.delegate = self;
    
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(onNaviRight) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    if (self.entryModel.goodsInfo.name) {
        [self.goodsBtn setTitle:self.entryModel.goodsInfo.name forState:UIControlStateNormal];
        self.goodsBtn.enabled = NO;
        self.btn.enabled = NO;
        self.emptview.hidden = YES;
        self.btnRight.hidden = YES;
        [self.btn setTitle:self.entryModel.box.name forState:UIControlStateNormal];
        self.jiantourignt.hidden = YES;
        
    }else{
//        self.goodName.text = self.entryModel.goodsInfo.name;
        self.goodsBtn.enabled = YES;
        self.btn.enabled = YES;
        self.emptview.hidden = NO;
        self.btnRight.hidden = NO;
        rightBtn.hidden = YES;
//        [self.btn setTitle:self.entryModel.box.name forState:UIControlStateNormal];
    }
    
    [self getBox];
   

}

- (void)getBox{
    [[OrderViewModel new] BoxNumberWithBoxId:@"" Withcallback:^(NSArray *boxModelArray) {
        self.boxArray = boxModelArray;
        for (BoxModel * model in boxModelArray) {
            if ([model.name isEqualToString:self.entryModel.box.name]) {
                self.weightField.text = model.loadWeight;
                self.area.text = [NSString stringWithFormat:@"(%.2f",[model.volume floatValue]];
                self.boxModel = model;
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text floatValue] <= 0 || [textField.text floatValue] >[self.boxModel.loadWeight floatValue]) {
        [[Toast shareToast] makeText:[NSString stringWithFormat:@"请输入>0 且<%.2f的数据",[self.boxModel.loadWeight floatValue]] aDuration:1];
        self.weightField.text = self.boxModel.loadWeight;
    }else{
//        self.boxModel.loadWeight = textField.text;
    }
}


#pragma mark - Public
- (void)textFieldValueChanged:(NSNotification *)notification {
    UITextField *textField = notification.object;
    if (textField.markedTextRange != nil) {
        return;
    }
    if ([textField.text containsString:@" "]) {
        textField.text = [textField.text substringToIndex:textField.text.length-1];
    }
    

    if (textField == self.field) {

        if (![YMKJVerificationTools  isAvailableNumber:textField.text]) {
            if (textField.text.length>0) {
                textField.text = [textField.text substringToIndex:textField.text.length-1];
            }
        }
        if ([textField.text isEqualToString:@"0"]||[textField.text isEqualToString:@"."]) {
            if (textField.text.length>0) {
                textField.text = [textField.text substringToIndex:textField.text.length-1];
            }
        }
    }
    
}

- (void)onNaviRight
{
    if (self.boxNum) {
        if (self.Block) {
            self.Block(self.boxNum);
        }
    }else{
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getGood:(GoodsInfo *)goods{
    [self.goodsBtn setTitle:goods.name forState:UIControlStateNormal];
    
}

//选择箱型
- (IBAction)pressTypeBtn:(id)sender {
    [self.view endEditing:YES];
    if([self.goodsBtn.titleLabel.text isEqualToString:@"请选择货品名称"]){
        [[Toast shareToast] makeText:@"请选择货品" aDuration:1];
        return;
    }
//    if (self.spand) {
//        [self.BGView removeFromSuperview];
//    }else{
//
//    }
    [self.BGView addSubview:self.bottomView];
    self.bottomView.boxModel = self.boxModel;
    [self.view.window addSubview:self.BGView];
}

- (void)onBGViewClicked
{
    [self.BGView removeFromSuperview];
}

//选择货品
- (IBAction)pressGoodsBtn:(id)sender {
    ZSSearchViewController *searchVC = [[ZSSearchViewController alloc] init];
    searchVC.vcDelegate = self;
    [self.navigationController pushViewController:searchVC animated:YES];
}


//计算
- (IBAction)pressBtn:(id)sender {
    [self.view endEditing:YES];
    
    if([self.goodsBtn.titleLabel.text isEqualToString:@"请选择货品名称"]){
        [[Toast shareToast] makeText:@"请选择货品" aDuration:1];
        return;
    }
    if ([self.btn.titleLabel.text isEqualToString:@"请选择箱型"]) {
        [[Toast shareToast] makeText:@"请选择箱型" aDuration:1];
        return;
    }
    if ([self.field.text isEqualToString:@""]) {
        [[Toast shareToast] makeText:@"请输入重量" aDuration:1];
        return;
    }
    
    if ([self.weightField.text floatValue] <= 0 || [self.weightField.text floatValue] >[self.boxModel.loadWeight floatValue]) {
        [[Toast shareToast] makeText:[NSString stringWithFormat:@"请输入>0 且<%.2f的数据",[self.boxModel.loadWeight floatValue]] aDuration:1];
        self.weightField.text = self.boxModel.loadWeight;
        return;
    }
    
    float totlaWeight = [self.field.text floatValue];
    float danWeight = [self.weightField.text floatValue];
    double totleNumber = ceil(totlaWeight/danWeight);
    self.boxNum = totleNumber;
//    NSString * totleWeightStr = [NSString stringWithFormat:@"%f",totlaWeight];
    NSString * totleWeightStr = self.field.text;
    NSString * tempStr;
    if (self.entryModel.goodsInfo.name)
    {
       tempStr  = [NSString stringWithFormat:@"%@吨 %@ ， 大约需%.0f箱 %@",totleWeightStr,self.entryModel.goodsInfo.name,totleNumber,self.boxModel.name];
    }else{
       tempStr = [NSString stringWithFormat:@"%@吨%@ ，大约需%.0f箱 %@",totleWeightStr,self.goodsBtn.titleLabel.text,totleNumber,self.boxModel.name];
    }

    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:tempStr];
    NSUInteger firstLoc;
    if (self.entryModel.goodsInfo.name){
        firstLoc = [tempStr rangeOfString:self.entryModel.goodsInfo.name].location;
    }else{
        firstLoc = [tempStr rangeOfString:self.goodsBtn.titleLabel.text].location;
    }
    NSRange rang1  = NSMakeRange(0, firstLoc);
    NSString *  boxStr = [NSString stringWithFormat:@"%.0f箱",totleNumber];
    NSUInteger secondLocc = [tempStr rangeOfString:boxStr].location;
    NSUInteger allLoc = tempStr.length;
    NSRange range2 = NSMakeRange(firstLoc, secondLocc - firstLoc);
    NSUInteger threeLoc = [tempStr rangeOfString:self.boxModel.name].location;
    NSRange range3 = NSMakeRange(secondLocc, threeLoc - secondLocc);
    NSRange range4 = NSMakeRange(threeLoc, allLoc - threeLoc);

    [aAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:rang1];
    [aAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range2];
    [aAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range3];
    [aAttributedString addAttribute:NSForegroundColorAttributeName value:APP_COLOR_Btn range:range4];
    self.resultLabel.attributedText = aAttributedString;
  
    self.resultTitleLabel.hidden = NO;
    self.resultLabel.hidden = NO;
}

- (UIView *)BGView
{
    if (!_BGView) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onBGViewClicked)];
        [view addGestureRecognizer:tap];
        _BGView = view;
    }
    return _BGView;
}

- (CalculatorBottomView *)bottomView
{
    WS(weakSelf);
    if (!_bottomView) {
        _bottomView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CalculatorBottomView class]) owner:self options:nil] firstObject];
        _bottomView.frame = CGRectMake(0, SCREEN_H - 160-kiPhoneFooterHeight, SCREEN_W, 160);
        _bottomView.boxModel = self.boxModel;
        [_bottomView setFinishbBlock:^(NSInteger index) {
            weakSelf.emptview.hidden = YES;
            [weakSelf.BGView removeFromSuperview];
            BoxModel * model = weakSelf.boxArray[index];
            weakSelf.boxModel = model;
            weakSelf.weightField.text = model.loadWeight;
            weakSelf.area.text = [NSString stringWithFormat:@"(%.2f",[model.volume floatValue]];
            [weakSelf.btn setTitle:model.name forState:UIControlStateNormal];
        }];
    }
    return _bottomView;
}


@end
