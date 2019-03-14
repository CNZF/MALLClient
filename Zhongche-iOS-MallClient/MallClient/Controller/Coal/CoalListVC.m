//
//  CoalListVC.m
//  MallClient
//
//  Created by lxy on 2017/10/12.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "CoalListVC.h"
#import "CoaCell.h"
#import "CoalViewModel.h"
#import "CoalDetailVC.h"

@interface CoalListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView      *viHead;

@property (nonatomic, strong) UIButton    *btnCoalKinds;
@property (nonatomic, strong) UIButton    *btnWater;
@property (nonatomic, strong) UIButton    *btnHot;
@property (nonatomic, strong) UIButton    *btnChoose;

@property (nonatomic, strong) UITableView *tvList;


@property (nonatomic, strong) NSArray     *arrCoalKinds;
@property (nonatomic, strong) NSArray     *arrWater;
@property (nonatomic, strong) NSArray     *arrHot;
@property (nonatomic, strong) NSArray     *arrShap;//粒度
@property (nonatomic, strong) NSArray     *arrSulphur;//全硫份
@property (nonatomic, strong) NSArray     *arrVolatility;//挥发份
@property (nonatomic, strong) NSArray     *arrGray;//灰份

@property (nonatomic, strong) UIView *viBack;
@property (nonatomic, strong) UIView *viBack1;

@property (nonatomic, strong) UIView      *viCoalKinds;
@property (nonatomic, strong) UIButton *btnSelectedCoalKinds;

@property (nonatomic, strong) UIView      *viWater;
@property (nonatomic, strong) UIButton *btnSelectedWater;

@property (nonatomic, strong) UIView      *viHot;
@property (nonatomic, strong) UIButton *btnSelectedHot;

@property (nonatomic, strong) UIView *viSelected;

@property (nonatomic, strong) UIButton *btnReset;
@property (nonatomic, strong) UIButton *btnFinish;

@property (nonatomic, strong) UIScrollView *scvSelect;

@property (nonatomic, strong) UIButton *btnSelectedShap;
@property (nonatomic, strong) UIButton *btnSelectedSulphur;
@property (nonatomic, strong) UIButton *btnSelectedVolatility;
@property (nonatomic, strong) UIButton *btnSelectedGray;

@property (nonatomic, strong) NSArray *arrModel;

@property (nonatomic, strong) NSMutableDictionary *dicConditions;



@end

@implementation CoalListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindView {


    self.title = @"绿色煤炭";



    self.tvList.frame = CGRectMake(0, 60, SCREEN_W, SCREEN_H - 60 - 64);
    [self.view addSubview:self.tvList];


    [self.view addSubview:self.viBack];

    self.view.backgroundColor = APP_COLOR_WHITE_BTN;
    self.viHead.frame = CGRectMake(0, 0, SCREEN_H, 50);
    [self.view addSubview:self.viHead];

    self.viCoalKinds.frame = CGRectMake(0, self.viHead.bottom, SCREEN_W, 80);
    [self.view addSubview:self.viCoalKinds];

    self.viWater.frame = CGRectMake(0, self.viHead.bottom, SCREEN_W, 180);
    [self.view addSubview:self.viWater];

    self.viHot.frame = CGRectMake(0, self.viHead.bottom, SCREEN_W, 180);
    [self.view addSubview:self.viHot];


    [self.view addSubview:self.viBack1];


    [self.view addSubview:self.viSelected];

}

- (void)bindModel {



    //self.arrCoalKinds = @[@"动力煤",@"无烟煤",@"炼焦煤"];
//    self.arrWater = @[@"10以下",@"10-15",@"15-20",@"20-25",@"25以上"];
//    self.arrHot = @[@"3000以下",@"3000-3500",@"3500-4000",@"4000-4500",@"4500-5000",@"5000-5500",@"5500-6000",@"6000以上"];

//    self.arrShap = @[@"沫煤",@"10-30毫米籽煤",@"20-50毫米二五煤块",@"30-80毫米三八煤块",@"40-90毫米四九煤块",@"30-60毫米三六煤块",@"100-250毫米中煤块",@"250毫米以上大煤块"];
//
//    self.arrSulphur = @[@"0.5以下",@"0.5-0.8",@"0.8-1.0",@"1.0以上"];
//    self.arrGray = @[@"5以下",@"5-10",@"10-15",@"15-20",@"20-25",@"25-30",@"30-35",@"35-40",@"40以上"];
//    self.arrVolatility = @[@"10以下",@"10-20",@"20-30",@"30以上"];

    self.dicConditions = [NSMutableDictionary dictionary];

}

-(void)getData {

    WS(ws);


    CoalViewModel *vm = [CoalViewModel new];
    [vm getCoalListWithConditions:self.dicConditions callback:^(NSArray *arr) {

        ws.arrModel = arr;
        [ws.tvList reloadData];

    }];

    [vm getConditionscallback:^(NSDictionary *dic) {

        ws.arrCoalKinds = dic[@"produceTypeList"];
        ws.arrWater = dic[@"moistureList"];
        ws.arrHot = dic[@"qnetList"];

        ws.arrShap = dic[@"particleList"];

        ws.arrSulphur = dic[@"sulfurList"];
        ws.arrGray = dic[@"ashList"];
        ws.arrVolatility = dic[@"moistureList"];

        

        [self btnAdd1];
        [self btnAdd2];
        [self btnAdd3];
        [self btnAdd4];

    }];


}

-(void)refreshAction {

    WS(ws);
    CoalViewModel *vm = [CoalViewModel new];
    [vm getCoalListWithConditions:self.dicConditions callback:^(NSArray *arr) {

        ws.arrModel = arr;
        [ws.tvList reloadData];

    }];

}

-(void)btnAdd1{

    UILabel *lb = [UILabel new];
    lb.font = [UIFont systemFontOfSize:12];
    lb.textColor = APP_COLOR_GRAY999;
    lb.text = @"煤种";
    lb.frame = CGRectMake(20, 10, SCREEN_W - 20, 20);
    [_viCoalKinds addSubview:lb];

    CGFloat x = 20;

    for (int i = 0; i<self.arrCoalKinds.count; i++) {

        UIButton *btn = [UIButton new];
        btn.tag = i;
        [btn setTitle:self.arrCoalKinds[i][@"name"]  forState:UIControlStateNormal];
        btn.frame = CGRectMake(x, lb.bottom + 10, SCREEN_W/3-80/3, 30);
        [btn setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
        [btn setBackgroundColor:APP_COLOR_WHITE_BTN];
        [btn addTarget:self action:@selector(chooseCoal:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_viCoalKinds addSubview:btn];

        x = btn.right + 20;


    }

}

-(void)btnAdd2 {
    UILabel *lb = [UILabel new];
    lb.font = [UIFont systemFontOfSize:12];
    lb.textColor = APP_COLOR_GRAY999;
    lb.text = @"全水份";
    lb.frame = CGRectMake(20, 10, SCREEN_W - 20, 20);
    [_viWater addSubview:lb];

    CGFloat x = 20;
    CGFloat y = lb.bottom + 10;

    for (int i = 0; i<self.arrWater.count; i++) {

        UIButton *btn = [UIButton new];
        btn.tag = i;
        NSDictionary *dic= self.arrWater[i];
        [btn setTitle:[NSString stringWithFormat:@"%@-%@",dic[@"mix"],dic[@"max"]]  forState:UIControlStateNormal];
        btn.frame = CGRectMake(x, y, SCREEN_W/3-80/3, 30);
        [btn setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
        [btn setBackgroundColor:APP_COLOR_WHITE_BTN];
        [btn addTarget:self action:@selector(chooseWater:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_viWater addSubview:btn];

        x = btn.right + 20;
        if ((i+1)%3 == 0 ) {
            y = btn.bottom + 20;
            x = 20;
        }
    }

}

-(void)btnAdd3 {

    UILabel *lb = [UILabel new];
    lb.font = [UIFont systemFontOfSize:12];
    lb.textColor = APP_COLOR_GRAY999;
    lb.text = @"低位热值";
    lb.frame = CGRectMake(20, 10, SCREEN_W - 20, 20);
    [_viHot addSubview:lb];

    CGFloat x = 20;
    CGFloat y = lb.bottom + 10;

    for (int i = 0; i<self.arrHot.count; i++) {

        UIButton *btn = [UIButton new];
        btn.tag = i;
        NSDictionary *dic= self.arrHot[i];
        [btn setTitle:[NSString stringWithFormat:@"%@-%@",dic[@"mix"],dic[@"max"]]  forState:UIControlStateNormal];
        btn.frame = CGRectMake(x, y, SCREEN_W/3-80/3, 30);
        [btn setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
        [btn setBackgroundColor:APP_COLOR_WHITE_BTN];
        [btn addTarget:self action:@selector(chooseHot:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_viHot addSubview:btn];

        x = btn.right + 20;
        if ((i+1)%3 == 0 ) {
            y = btn.bottom + 20;
            x = 20;
        }


    }

}

-(void)btnAdd4{

    UILabel *lb0 = [self labelWithText:@"    筛选" WithFont:[UIFont systemFontOfSize:12] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY999];
    lb0.backgroundColor = APP_COLOR_WHITE_BTN;
    lb0.frame = CGRectMake(0, 0, SCREEN_W - 80, 20);

    [_scvSelect addSubview:lb0];

    UILabel *lb1 = [self labelWithText:@"    煤种" WithFont:[UIFont systemFontOfSize:12] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY999];
    lb1.frame = CGRectMake(0, 50, SCREEN_W - 80, 20);

    [_scvSelect addSubview:lb1];

    CGFloat x = 20;
    CGFloat y = lb1.bottom + 10;

    for (int i = 0; i<self.arrCoalKinds.count; i++) {

        UIButton *btn = [UIButton new];
        btn.tag = i;
        [btn setTitle:self.arrCoalKinds[i][@"name"]   forState:UIControlStateNormal];
        btn.frame = CGRectMake(x, y, (SCREEN_W- 160)/3, 30);
        [btn setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
        [btn setBackgroundColor:APP_COLOR_WHITE_BTN];
        [btn addTarget:self action:@selector(chooseCoal:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_scvSelect addSubview:btn];

        x = btn.right + 20;
        if ((i+1)%3 == 0 ) {
            y = btn.bottom + 20;
            x = 20;
        }

        if (i == self.arrCoalKinds.count-1 ) {

            y = btn.bottom + 20;
            x = 20;
        }


    }


    UILabel *lb2 = [self labelWithText:@"    粒度" WithFont:[UIFont systemFontOfSize:12] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY999];
    lb2.frame = CGRectMake(0, y , SCREEN_W - 80, 20);

    [_scvSelect addSubview:lb2];
    y = lb2.bottom + 20;

    for (int i = 0; i<self.arrShap.count; i++) {

        UIButton *btn = [UIButton new];
        btn.tag = i;
        [btn setTitle:self.arrShap[i][@"name"]   forState:UIControlStateNormal];
        btn.frame = CGRectMake(x, y, (SCREEN_W- 140)/2, 30);
        [btn setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
        [btn setBackgroundColor:APP_COLOR_WHITE_BTN];
        [btn addTarget:self action:@selector(chooseShap:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_scvSelect addSubview:btn];

        x = btn.right + 20;
        if ((i+1)%2 == 0 ) {
            y = btn.bottom + 20;
            x = 20;
        }

        if (i == self.arrShap.count-1 ) {

            y = btn.bottom + 20;
            x = 20;
        }


    }

    UILabel *lb3 = [self labelWithText:@"    低位热值" WithFont:[UIFont systemFontOfSize:12] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY999];
    lb3.frame = CGRectMake(0, y , SCREEN_W - 80, 20);

    [_scvSelect addSubview:lb3];
    y = lb3.bottom + 20;

    for (int i = 0; i<self.arrHot.count; i++) {

        UIButton *btn = [UIButton new];
        btn.tag = i;
        NSDictionary *dic= self.arrHot[i];
        [btn setTitle:[NSString stringWithFormat:@"%@-%@",dic[@"mix"],dic[@"max"]]  forState:UIControlStateNormal];
        btn.frame = CGRectMake(x, y, (SCREEN_W- 140)/2, 30);
        [btn setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
        [btn setBackgroundColor:APP_COLOR_WHITE_BTN];
        [btn addTarget:self action:@selector(chooseHot:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_scvSelect addSubview:btn];

        x = btn.right + 20;
        if ((i+1)%2 == 0 ) {
            y = btn.bottom + 20;
            x = 20;
        }

        if (i == self.arrHot.count-1 ) {

            y = btn.bottom + 20;
            x = 20;
        }


    }

    UILabel *lb4 = [self labelWithText:@"    全水份" WithFont:[UIFont systemFontOfSize:12] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY999];
    lb4.frame = CGRectMake(0, y, SCREEN_W - 80, 20);
    y = lb4.bottom + 20;

    [_scvSelect addSubview:lb4];


    for (int i = 0; i<self.arrWater.count; i++) {

        UIButton *btn = [UIButton new];
        btn.tag = i;
        NSDictionary *dic= self.arrWater[i];
        [btn setTitle:[NSString stringWithFormat:@"%@-%@",dic[@"mix"],dic[@"max"]]  forState:UIControlStateNormal];
        btn.frame = CGRectMake(x, y, (SCREEN_W- 160)/3, 30);
        [btn setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
        [btn setBackgroundColor:APP_COLOR_WHITE_BTN];
        [btn addTarget:self action:@selector(chooseWater:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_scvSelect addSubview:btn];

        x = btn.right + 20;
        if ((i+1)%3 == 0 ) {
            y = btn.bottom + 20;
            x = 20;
        }

        if (i == self.arrWater.count-1 ) {

            y = btn.bottom + 20;
            x = 20;
        }


    }

    UILabel *lb5 = [self labelWithText:@"    全硫份" WithFont:[UIFont systemFontOfSize:12] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY999];
    lb5.frame = CGRectMake(0, y, SCREEN_W - 80, 20);
    y = lb5.bottom + 20;
    [_scvSelect addSubview:lb5];


    for (int i = 0; i<self.arrSulphur.count; i++) {

        UIButton *btn = [UIButton new];
        btn.tag = i;

        NSDictionary *dic= self.arrSulphur[i];
        [btn setTitle:[NSString stringWithFormat:@"%@-%@",dic[@"mix"],dic[@"max"]]  forState:UIControlStateNormal];
        btn.frame = CGRectMake(x, y, (SCREEN_W- 160)/3, 30);
        [btn setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
        [btn setBackgroundColor:APP_COLOR_WHITE_BTN];
        [btn addTarget:self action:@selector(chooseSulphur:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_scvSelect addSubview:btn];

        x = btn.right + 20;
        if ((i+1)%3 == 0 ) {
            y = btn.bottom + 20;
            x = 20;
        }

        if (i == self.arrSulphur.count-1 ) {

            y = btn.bottom + 20;
            x = 20;
        }


    }

    UILabel *lb6 = [self labelWithText:@"    挥发份" WithFont:[UIFont systemFontOfSize:12] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY999];
    lb6.frame = CGRectMake(0, y, SCREEN_W - 80, 20);
    y = lb6.bottom + 20;

    [_scvSelect addSubview:lb6];


    for (int i = 0; i<self.arrVolatility.count; i++) {

        UIButton *btn = [UIButton new];
        btn.tag = i;
        [btn setTitle:self.arrVolatility[i]  forState:UIControlStateNormal];
        NSDictionary *dic= self.arrVolatility[i];
        [btn setTitle:[NSString stringWithFormat:@"%@-%@",dic[@"mix"],dic[@"max"]]  forState:UIControlStateNormal];
        btn.frame = CGRectMake(x, y, (SCREEN_W- 160)/3, 30);
        [btn setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
        [btn setBackgroundColor:APP_COLOR_WHITE_BTN];
        [btn addTarget:self action:@selector(chooseVolatility:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_scvSelect addSubview:btn];

        x = btn.right + 20;
        if ((i+1)%3 == 0 ) {
            y = btn.bottom + 20;
            x = 20;
        }

        if (i == self.arrVolatility.count-1 ) {

            y = btn.bottom + 20;
            x = 20;
        }


    }


    UILabel *lb7 = [self labelWithText:@"    灰份" WithFont:[UIFont systemFontOfSize:12] WithTextAlignment:NSTextAlignmentLeft WithTextColor:APP_COLOR_GRAY999];
    lb7.frame = CGRectMake(0, y, SCREEN_W - 80, 20);
    y = lb7.bottom + 20;

    [_scvSelect addSubview:lb7];


    for (int i = 0; i<self.arrGray.count; i++) {

        UIButton *btn = [UIButton new];
        btn.tag = i;
        [btn setTitle:self.arrGray[i]  forState:UIControlStateNormal];
        NSDictionary *dic= self.arrGray[i];
        [btn setTitle:[NSString stringWithFormat:@"%@-%@",dic[@"mix"],dic[@"max"]]  forState:UIControlStateNormal];

        btn.frame = CGRectMake(x, y, (SCREEN_W- 160)/3, 30);
        [btn setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
        [btn setBackgroundColor:APP_COLOR_WHITE_BTN];
        [btn addTarget:self action:@selector(chooseGray:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_scvSelect addSubview:btn];

        x = btn.right + 20;
        if ((i+1)%3 == 0 ) {
            y = btn.bottom + 20;
            x = 20;
        }

        if (i == self.arrGray.count-1 ) {

            y = btn.bottom + 20;
            x = 20;
        }


    }



    _scvSelect.contentSize = CGSizeMake(SCREEN_W - 80, y );
}

- (void)viChooseShow {

    self.viSelected.hidden = !self.viSelected.hidden;
    self.viBack1.hidden = self.viSelected.hidden;
}

-(void)reSetAction {

    self.viCoalKinds.hidden = YES;
    self.viWater.hidden = YES;
    self.viHot.hidden = YES;
    self.viBack.hidden = YES;
}

-(void)chooseCoalKinds {


    if (self.viCoalKinds.hidden) {
        [self reSetAction];
    }

    self.viCoalKinds.hidden = !self.viBack.hidden;
    self.viBack.hidden = self.viCoalKinds.hidden;
}

-(void) chooseWater{

    if (self.viWater.hidden) {
        [self reSetAction];
    }
    self.viWater.hidden = !self.viWater.hidden;
    self.viBack.hidden = self.viWater.hidden;

}

-(void) chooseHot{

    if (self.viHot.hidden) {
        [self reSetAction];
    }
    self.viHot.hidden = !self.viHot.hidden;
    self.viBack.hidden = self.viHot.hidden;
    
}

-(void)chooseCoal:(UIButton *)btn{

    self.btnSelectedCoalKinds.layer.borderWidth = 0;
    [self.btnSelectedCoalKinds setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
    [self.btnSelectedCoalKinds setBackgroundColor:APP_COLOR_WHITE_BTN];

    [btn setTitleColor:APP_COLOR_ORANGE1 forState:UIControlStateNormal];
    btn.layer.borderColor = [APP_COLOR_ORANGE1 CGColor];
    btn.layer.borderWidth = 0.5;
    [btn setBackgroundColor:APP_COLOR_WHITE];
    self.btnSelectedCoalKinds = btn;

    [self.btnCoalKinds setTitle:btn.titleLabel.text forState:UIControlStateNormal];
    self.btnCoalKinds.layer.borderColor = [APP_COLOR_BLUE_BTN CGColor];
    [self.btnCoalKinds setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];
    self.btnCoalKinds.layer.borderWidth = 0.5;
    [self.btnCoalKinds setBackgroundColor:APP_COLOR_WHITE];

    NSDictionary *dic =self.arrCoalKinds[btn.tag];

    [self.dicConditions setObject:dic[@"code"] forKey:@"type"];

    [self refreshAction];



}


-(void)chooseWater:(UIButton *)btn{

    self.btnSelectedWater.layer.borderWidth = 0;
    [self.btnSelectedWater setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
    [self.btnSelectedWater setBackgroundColor:APP_COLOR_WHITE_BTN];

    [btn setTitleColor:APP_COLOR_ORANGE1 forState:UIControlStateNormal];
    btn.layer.borderColor = [APP_COLOR_ORANGE1 CGColor];
    btn.layer.borderWidth = 0.5;
    [btn setBackgroundColor:APP_COLOR_WHITE];
    self.btnSelectedWater = btn;

    [self.btnWater setTitle:btn.titleLabel.text forState:UIControlStateNormal];
    self.btnWater.layer.borderColor = [APP_COLOR_BLUE_BTN CGColor];
    [self.btnWater setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];
    self.btnWater.layer.borderWidth = 0.5;
    [self.btnWater setBackgroundColor:APP_COLOR_WHITE];
    
    NSDictionary *dic =self.arrWater[btn.tag];

    [self.dicConditions setObject:dic[@"mix"] forKey:@"startMoisture"];
    [self.dicConditions setObject:dic[@"max"] forKey:@"endMoisture"];

    [self refreshAction];
}


-(void)chooseHot:(UIButton *)btn{

    self.btnSelectedHot.layer.borderWidth = 0;
    [self.btnSelectedHot setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
    [self.btnSelectedHot setBackgroundColor:APP_COLOR_WHITE_BTN];

    [btn setTitleColor:APP_COLOR_ORANGE1 forState:UIControlStateNormal];
    btn.layer.borderColor = [APP_COLOR_ORANGE1 CGColor];
    btn.layer.borderWidth = 0.5;
    [btn setBackgroundColor:APP_COLOR_WHITE];
    self.btnSelectedHot = btn;

    [self.btnHot setTitle:btn.titleLabel.text forState:UIControlStateNormal];
    self.btnHot.layer.borderColor = [APP_COLOR_BLUE_BTN CGColor];
    [self.btnHot setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];
    self.btnHot.layer.borderWidth = 0.5;
    [self.btnHot setBackgroundColor:APP_COLOR_WHITE];

    NSDictionary *dic =self.arrHot[btn.tag];

    [self.dicConditions setObject:dic[@"mix"] forKey:@"startQnet"];
    [self.dicConditions setObject:dic[@"max"] forKey:@"endQnet"];

    [self refreshAction];
    
    
}


-(void)chooseShap:(UIButton *)btn{

    self.btnSelectedShap.layer.borderWidth = 0;
    [self.btnSelectedShap setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
    [self.btnSelectedShap setBackgroundColor:APP_COLOR_WHITE_BTN];

    [btn setTitleColor:APP_COLOR_ORANGE1 forState:UIControlStateNormal];
    btn.layer.borderColor = [APP_COLOR_ORANGE1 CGColor];
    btn.layer.borderWidth = 0.5;
    [btn setBackgroundColor:APP_COLOR_WHITE];
    self.btnSelectedShap = btn;

    NSDictionary *dic =self.arrShap[btn.tag];

    [self.dicConditions setObject:dic[@"code"] forKey:@"particleType"];

    [self refreshAction];

    
}

-(void)chooseSulphur:(UIButton *)btn{

    self.btnSelectedSulphur.layer.borderWidth = 0;
    [self.btnSelectedSulphur setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
    [self.btnSelectedSulphur setBackgroundColor:APP_COLOR_WHITE_BTN];

    [btn setTitleColor:APP_COLOR_ORANGE1 forState:UIControlStateNormal];
    btn.layer.borderColor = [APP_COLOR_ORANGE1 CGColor];
    btn.layer.borderWidth = 0.5;
    [btn setBackgroundColor:APP_COLOR_WHITE];
    self.btnSelectedSulphur = btn;

    NSDictionary *dic =self.arrSulphur[btn.tag];

    [self.dicConditions setObject:dic[@"mix"] forKey:@"startSulfur"];
    [self.dicConditions setObject:dic[@"max"] forKey:@"endSulfur"];

    [self refreshAction];
    
    
}

-(void)chooseVolatility:(UIButton *)btn{

    self.btnSelectedVolatility.layer.borderWidth = 0;
    [self.btnSelectedVolatility setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
    [self.btnSelectedVolatility setBackgroundColor:APP_COLOR_WHITE_BTN];

    [btn setTitleColor:APP_COLOR_ORANGE1 forState:UIControlStateNormal];
    btn.layer.borderColor = [APP_COLOR_ORANGE1 CGColor];
    btn.layer.borderWidth = 0.5;
    [btn setBackgroundColor:APP_COLOR_WHITE];
    self.btnSelectedVolatility = btn;

    NSDictionary *dic =self.arrVolatility[btn.tag];

    [self.dicConditions setObject:dic[@"mix"] forKey:@"startVolatilize"];
    [self.dicConditions setObject:dic[@"max"] forKey:@"endVolatilize"];

    [self refreshAction];

    
}

-(void)chooseGray:(UIButton *)btn{

    self.btnSelectedGray.layer.borderWidth = 0;
    [self.btnSelectedGray setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
    [self.btnSelectedGray setBackgroundColor:APP_COLOR_WHITE_BTN];

    [btn setTitleColor:APP_COLOR_ORANGE1 forState:UIControlStateNormal];
    btn.layer.borderColor = [APP_COLOR_ORANGE1 CGColor];
    btn.layer.borderWidth = 0.5;
    [btn setBackgroundColor:APP_COLOR_WHITE];
    self.btnSelectedGray = btn;

    NSDictionary *dic =self.arrVolatility[btn.tag];

    [self.dicConditions setObject:dic[@"mix"] forKey:@"startAsh"];
    [self.dicConditions setObject:dic[@"max"] forKey:@"endAsh"];

    [self refreshAction];

    
}

-(void)finishActon{

    self.viSelected.hidden = YES;
    self.viBack1.hidden = YES;
}

-(void)reSetChooseAction{

    [self.btnWater setTitle:@"全水份  ▼" forState:UIControlStateNormal];
    [self.btnWater setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnWater setBackgroundColor:APP_COLOR_WHITE_BTN];
    [self.btnHot setTitle:@"低位热值  ▼" forState:UIControlStateNormal];
    [self.btnHot setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnHot setBackgroundColor:APP_COLOR_WHITE_BTN];
    [self.btnCoalKinds setTitle:@"煤种  ▼" forState:UIControlStateNormal];
    [self.btnCoalKinds setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnCoalKinds setBackgroundColor:APP_COLOR_WHITE_BTN];

    [self.btnSelectedHot setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
    [self.btnSelectedHot setBackgroundColor:APP_COLOR_WHITE_BTN];

    [self.btnSelectedCoalKinds setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
    [self.btnSelectedCoalKinds setBackgroundColor:APP_COLOR_WHITE_BTN];

    [self.btnSelectedWater setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
    [self.btnSelectedWater setBackgroundColor:APP_COLOR_WHITE_BTN];

    [self.btnSelectedShap setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
    [self.btnSelectedShap setBackgroundColor:APP_COLOR_WHITE_BTN];

    [self.btnSelectedSulphur setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
    [self.btnSelectedSulphur setBackgroundColor:APP_COLOR_WHITE_BTN];

    [self.btnSelectedVolatility setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
    [self.btnSelectedVolatility setBackgroundColor:APP_COLOR_WHITE_BTN];

    [self.btnSelectedGray setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
    [self.btnSelectedGray setBackgroundColor:APP_COLOR_WHITE_BTN];
}

//delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arrModel.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {



    static NSString *CellIdentifier = @"Celled";
    CoaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CoaCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    CoalModel *model = [self.arrModel objectAtIndex:indexPath.row];
    cell.lbName.text = model.name;
    cell.lbPrice.text = [NSString stringWithFormat:@"￥%@",model.price];
    cell.leDetail.text = [NSString stringWithFormat:@"%@    %@",model.sku,model.deliveryAddress];
    cell.lbPriceDesc.text = model.priceTypeDesc;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 90;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    CoalModel *model = [self.arrModel objectAtIndex:indexPath.row];
    CoalDetailVC *vc = [CoalDetailVC new];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
    
}


/**
 *  getter
 */

- (UIView *)viHead {
    if (!_viHead) {
        _viHead = [UIView new];
        _viHead.backgroundColor = APP_COLOR_WHITE;

        self.btnCoalKinds.frame = CGRectMake(20, 10, SCREEN_W/3 -110/3, 30);
        [_viHead addSubview:self.btnCoalKinds];

        self.btnWater.frame = CGRectMake(self.btnCoalKinds.right + 15, 10, SCREEN_W/3 -110/3, 30);
        [_viHead addSubview:self.btnWater];

        self.btnHot.frame = CGRectMake(self.btnWater.right + 15, 10, SCREEN_W/3 -110/3, 30);
        [_viHead addSubview:self.btnHot];

        self.btnChoose.frame = CGRectMake(self.btnHot.right , 10, 60, 30);
        [_viHead addSubview:self.btnChoose];



    }
    return _viHead;
}

- (UIButton *)btnCoalKinds {
    if (!_btnCoalKinds) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"煤种  ▼" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:APP_COLOR_WHITE_BTN];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
       [button addTarget:self action:@selector(chooseCoalKinds) forControlEvents:UIControlEventTouchUpInside];



        _btnCoalKinds = button;
    }
    return _btnCoalKinds;
}

- (UIButton *)btnWater {
    if (!_btnWater) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"全水份  ▼" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:APP_COLOR_WHITE_BTN];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button addTarget:self action:@selector(chooseWater) forControlEvents:UIControlEventTouchUpInside];


        _btnWater = button;
    }
    return _btnWater;
}

- (UIButton *)btnHot {
    if (!_btnHot) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"低位热值  ▼" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:APP_COLOR_WHITE_BTN];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button addTarget:self action:@selector(chooseHot) forControlEvents:UIControlEventTouchUpInside];

        _btnHot = button;
    }
    return _btnHot;
}

- (UIButton *)btnChoose {
    if (!_btnChoose) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"筛选" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"shaixuan"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(viChooseShow) forControlEvents:UIControlEventTouchUpInside];



        _btnChoose = button;
    }
    return _btnChoose;
}

- (UITableView *)tvList {
    if (!_tvList) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        tableView.backgroundColor = APP_COLOR_WHITE_BTN;

        _tvList = tableView;
    }
    return _tvList;
}

- (UIView *)viBack {
    if (!_viBack) {
        _viBack = [UIView new];
        _viBack.alpha = 0.2;
        _viBack.backgroundColor = [UIColor blackColor];
        _viBack.frame = CGRectMake(0, 0, SCREEN_W,SCREEN_H);
        _viBack.hidden = YES;

    }
    return _viBack;
}

- (UIView *)viBack1 {
    if (!_viBack1) {
        _viBack1 = [UIView new];
        _viBack1.alpha = 0.2;
        _viBack1.backgroundColor = [UIColor blackColor];
        _viBack1.frame = CGRectMake(0, 0, SCREEN_W,SCREEN_H);
        _viBack1.hidden = YES;

    }
    return _viBack1;
}

- (UIView *)viCoalKinds {
    if (!_viCoalKinds) {
        _viCoalKinds = [UIView new];
        _viCoalKinds.backgroundColor = APP_COLOR_WHITE;
        _viCoalKinds.hidden = YES;

        


    }
    return _viCoalKinds;
}

- (UIView *)viWater {
    if (!_viWater) {
        _viWater = [UIView new];

        _viWater.backgroundColor = APP_COLOR_WHITE;
        _viWater.hidden = YES;


            
        }


    return _viWater;
}


- (UIView *)viHot {
    if (!_viHot) {
        _viHot = [UIView new];

        _viHot.backgroundColor = APP_COLOR_WHITE;
        _viHot.hidden = YES;


    }
    return _viHot;
}

- (UIView *)viSelected {
    if (!_viSelected) {
        _viSelected = [UIView new];
        _viSelected.backgroundColor = APP_COLOR_WHITE;
        _viSelected.frame = CGRectMake(80, 0,SCREEN_W - 80 , SCREEN_H - 64);
        _viSelected.hidden = YES;

        self.btnReset.frame  =CGRectMake(0, SCREEN_H - 64 - 50, (SCREEN_W - 80)/2, 50);
        self.btnFinish.frame  =CGRectMake(self.btnReset.right, SCREEN_H - 64 - 50, (SCREEN_W - 80)/2, 50);

        [_viSelected addSubview:self.btnReset];
        [_viSelected addSubview:self.btnFinish];

        self.scvSelect.frame = CGRectMake(0, 0, SCREEN_W - 80, SCREEN_H - 64 - 50);
        [_viSelected addSubview:self.scvSelect];

        UILabel *lb = [UILabel new];
        lb.frame = CGRectMake(0, SCREEN_H - 64 - 50, SCREEN_W - 80, 0.5);
        lb.backgroundColor = APP_COLOR_GRAY666;
        [_viSelected addSubview:lb];








    }
    return _viSelected;
}

- (UIButton *)btnReset {
    if (!_btnReset) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"重置" forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];

        [button addTarget:self action:@selector(reSetChooseAction) forControlEvents:UIControlEventTouchUpInside];



        _btnReset = button;
    }
    return _btnReset;
}

- (UIButton *)btnFinish {
    if (!_btnFinish) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setBackgroundColor:APP_COLOR_BLUE_BTN];

       [button addTarget:self action:@selector(finishActon) forControlEvents:UIControlEventTouchUpInside];

        _btnFinish = button;
    }
    return _btnFinish;
}

- (UIScrollView *)scvSelect {
    if (!_scvSelect) {
        _scvSelect = [UIScrollView new];
        _scvSelect.contentSize = CGSizeMake(SCREEN_W - 80, 1600);



        



    }
    return _scvSelect;
}





@end
