//
//  NoTransportViewController.m
//  MallClient
//
//  Created by lxy on 2016/11/28.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "NoTransportViewController.h"
#import "MLNavigationController.h"
#import "LoginViewController.h"
#import "CustomCapacityController.h"

@interface NoTransportViewController ()

@property (nonatomic, strong) UILabel *lb1;
@property (nonatomic, strong) UILabel *lb2;
@property (nonatomic, strong) UILabel *lb3;
@property (nonatomic, strong) UIButton *btnOrderTransport;
@property (nonatomic, strong) UIImageView *ivNoTransport;//200 108

@end

@implementation NoTransportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindView {

    self.title = @"定制运力";

    self.view.backgroundColor = [UIColor whiteColor];

    self.ivNoTransport.frame = CGRectMake(SCREEN_W/2 - 100, 60, 200, 108);
    [self.view addSubview:self.ivNoTransport];

    self.lb1.frame = CGRectMake(0, self.ivNoTransport.bottom + 40 , SCREEN_W, 20);
    [self.view addSubview:self.lb1];

    self.lb2.frame = CGRectMake(0, self.lb1.bottom + 20, SCREEN_W, 20);
    [self.view addSubview:self.lb2];

    self.btnOrderTransport.frame = CGRectMake(SCREEN_W/2 - 125, SCREEN_H - 200, 250, 44);
    [self.view addSubview:self.btnOrderTransport];

    self.lb3.frame = CGRectMake(0, self.btnOrderTransport.bottom + 20, SCREEN_W, 20);
    [self.view addSubview:self.lb3];



}

- (void)bindAction {

    WS(ws);

    //定制运力
    [[self.btnOrderTransport rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        if (!USER_INFO) {
            [self pushLogoinVC];
            return ;
        }else {

            MLNavigationController *nv= (MLNavigationController *)self.navigationController;
            [nv addPanGestureRecognizer];

            CustomCapacityController *vc= (CustomCapacityController *)[self getControllerWithBaseName:@"CustomCapacityController"];
            vc.capacityEntry = ws.capacityEntry;
            vc.title = @"定制运力";
            vc.isRefush = 1;
            [ws.navigationController pushViewController:vc animated:YES];

            
        }

        
    }];

}

-(void)pushLogoinVC {
    MLNavigationController * vc = [[MLNavigationController alloc] initWithRootViewController:[LoginViewController new]];
    [vc.navigationBar setBackgroundImage:[UIImage getImageWithColor:[UIColor whiteColor] andSize:CGSizeMake(SCREEN_W * 3, 64)] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:vc animated:YES completion:^{


    }];
}


/**
 *  getter
 */
- (UILabel *)lb1 {
    if (!_lb1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"很抱歉，平台暂时没有对应方案";

        _lb1 = label;
    }
    return _lb1;
}

- (UILabel *)lb2 {
    if (!_lb2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"您可以根据需求进行私人定制";

        _lb2 = label;
    }
    return _lb2;
}

- (UILabel *)lb3 {
    if (!_lb3) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"我们将在24小时之内，安排专人与您商讨新方案";

        _lb3 = label;
    }
    return _lb3;
}

- (UIImageView *)ivNoTransport {
    if (!_ivNoTransport) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"NoTransport"];

        _ivNoTransport = imageView;
    }
    return _ivNoTransport;
}

- (UIButton *)btnOrderTransport {
    if (!_btnOrderTransport) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"定制运力" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:APP_COLOR_BLUE_BTN];
        button.layer.masksToBounds = YES;
        [button.layer setCornerRadius:22.5];

        _btnOrderTransport = button;
    }
    return _btnOrderTransport;
}

@end


#pragma mark - 集装箱运力
@implementation NoTransportViewController_Container : NoTransportViewController

@end

#pragma mark - 散堆装运力
@implementation NoTransportViewController_InBulk : NoTransportViewController

@end
#pragma mark - 三农化肥运力
@implementation  NoTransportViewController_Fertilizer : NoTransportViewController

@end
#pragma mark 一带一路运力
@implementation NoTransportViewController_OneBeltOneRoad : NoTransportViewController

@end

#pragma mark 冷链运力
@implementation NoTransportViewController_ColdChain : NoTransportViewController

@end

#pragma mark 大件运力
@implementation NoTransportViewController_Big : NoTransportViewController

@end

#pragma mark 商品车运力
@implementation NoTransportViewController_ForCar : NoTransportViewController

@end

#pragma mark 液态运力
@implementation NoTransportViewController_Liquid : NoTransportViewController

@end

#pragma mark 快速配送运力
@implementation NoTransportViewController_QuickGo : NoTransportViewController

@end
