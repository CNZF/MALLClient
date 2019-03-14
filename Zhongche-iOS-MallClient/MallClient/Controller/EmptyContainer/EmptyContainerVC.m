//
//  EmptyContainerVC.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2016/12/27.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "EmptyContainerVC.h"
#import "EmptyContainerListVC.h"

@interface EmptyContainerVC ()

@property (nonatomic, strong)UISegmentedControl * segmented;//选择按钮

@property (nonatomic, strong)UIScrollView * bgVi;

@property (nonatomic, strong)EmptyContainerListVC * rentVC;
@property (nonatomic, strong)EmptyContainerListVC * buyVC;

@end

@implementation EmptyContainerVC

-(void)dealloc {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"空箱之家";
    self.view.backgroundColor = APP_COLOR_WHITE;
}

-(void)viewWillAppear:(BOOL)animated {
    self.bgVi.contentOffset = CGPointMake(SCREEN_W * self.segmented.selectedSegmentIndex, self.bgVi.contentOffset.y);
    [super viewWillAppear:animated];

}

- (void)bindView {
    self.segmented.frame = CGRectMake(SCREEN_W / 2 - 100, 10, 200, 35);
    [self.view addSubview:self.segmented];
    
    self.bgVi.frame = CGRectMake(0,55, SCREEN_W * 2, SCREEN_H - 64 - 55);
    [self.view addSubview:self.bgVi];

    self.rentVC.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64 - 55);
    [self addChildViewController:self.rentVC];
    [self.bgVi addSubview:self.rentVC.view];
    
    self.buyVC.view.frame = CGRectMake(SCREEN_W, 0, SCREEN_W, SCREEN_H - 64 - 55);
    [self addChildViewController:self.buyVC];
    [self.bgVi addSubview:self.buyVC.view];
}

- (void)segmentedControlAction:(UISegmentedControl *)sgd {
    
    WS(ws);
    [UIView animateWithDuration:0.5 animations:^{
        
        ws.bgVi.contentOffset = CGPointMake(SCREEN_W * sgd.selectedSegmentIndex, ws.bgVi.contentOffset.y);
    }];
}

/**
 *  getter
 *
 */
-(UISegmentedControl *)segmented {
    if (!_segmented) {
        UISegmentedControl * sgd = [[UISegmentedControl alloc]initWithItems:@[@"租用",@"购买"]];
        sgd.tintColor = APP_COLOR_BLUE_BTN;
        sgd.selectedSegmentIndex = 0;
        [sgd addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
        
        _segmented = sgd;
    }
    return _segmented;
}

-(UIScrollView *)bgVi {
    if (!_bgVi) {
        UIScrollView * view = [UIScrollView new];
        view.contentSize = CGSizeMake(SCREEN_W * 2, 2 * (SCREEN_H - 64 - 55));
        view.backgroundColor = APP_COLOR_WHITE;
        view.scrollEnabled = NO;
        _bgVi = view;
    }
    return _bgVi;
}

-(EmptyContainerListVC *)rentVC {
    if (!_rentVC) {
        EmptyContainerListVC * vc = [EmptyContainerListVC_Rent new];
        _rentVC = vc;
    }
    return _rentVC;
}

-(EmptyContainerListVC *)buyVC {
    if (!_buyVC) {
        EmptyContainerListVC * vc = [EmptyContainerListVC_Buy new];
        _buyVC = vc;
    }
    return _buyVC;
}



@end
