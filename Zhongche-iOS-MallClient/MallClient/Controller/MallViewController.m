//
//  MallViewController.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/10.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "MallViewController.h"
#import "MLNavigationController.h"
#import "FirstPageViewController.h"
#import "OrderCenterVC.h"
#import "UserViewController.h"
#import "GuideVi.h"
#import "PersonalAuthenticationVC.h"
#import "LoginViewController.h"

@interface MallViewController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) GuideVi *gvi;

@end

@implementation MallViewController

-(instancetype)init {

    self = [super init];
    if (self)
    {
//        NSArray * classStrings = @[@"FirstPageViewController",@"OrderCenterVC",@"UIViewController",@"UserViewController"];
//        NSArray * titles = @[@"首页",@"订单中心",@"购物车",@"我的"];
//        NSArray * images = @[@"Group 04",@"Group 17",@"购物车",@"Group 18"];
//        NSArray * selectedImages = @[@"Group 4",@"iconfont-dingdan (1)",@"购物车",@"iconfont-wode (1)"];
        NSArray * classStrings = @[@"FirstPageViewController",@"OrderCenterVC",@"UserViewController"];
        NSArray * titles = @[@"首页",@"订单",@"我的"];
        NSArray * images = @[@"Group 04",@"iconfont-dingdan (1)",@"iconfont-wode (1)"];
        NSArray * selectedImages = @[@"Group 404",@"Group 17",@"person"];
        UIViewController * vc;
        for (int i = 0; i < classStrings.count ; i ++)
        {
            if (i < 4)
            {
                vc = [[MLNavigationController alloc] initWithRootViewController:[[NSClassFromString(classStrings[i]) alloc]init]];
                
                //设置导航条背景图片
                [((MLNavigationController *)vc).navigationBar setBackgroundImage:[UIImage getImageWithColor:[UIColor whiteColor] andSize:CGSizeMake(SCREEN_W * 3, 64)] forBarMetrics:UIBarMetricsDefault];
                
                //设置导航条字体颜色
                [((MLNavigationController *)vc).navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:APP_COLOR_BLACK_TEXT}];

            }
            else
            {
                vc = [[NSClassFromString(classStrings[i]) alloc]init];
            }
            vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:titles[i] image:[[UIImage imageNamed:[images[i] adS]] modifyTheImg] selectedImage:[[UIImage imageNamed:[selectedImages[i] adS]] modifyTheImg]];
            [self addChildViewController:vc];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSelectedVC:) name:@"setSelectedViewController" object:nil];
        self.tabBar.backgroundImage = [UIImage getImageWithColor:APP_COLOR_WHITE andSize:CGSizeMake(1, 1)];
        self.delegate = self;
    }
    return self;
}

// 标签通知跳转页面
-(void)setSelectedVC:(NSNotification *)noti {

    if ([noti.object[@"isShow"] boolValue]) {
        self.gvi  = [GuideVi new];
        self.gvi.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);

        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self.gvi];

        [self.gvi.cancleBtn addTarget:self action:@selector(cancelInteraction) forControlEvents:UIControlEventTouchUpInside];
        [self.gvi.validationBtn addTarget:self action:@selector(perFactAction) forControlEvents:UIControlEventTouchUpInside];

    }

    for (UIViewController * obj in self.viewControllers) {
        if ([obj isKindOfClass:[UINavigationController class]]) {
            for (UIViewController * vc in ((UINavigationController *)obj).viewControllers) {
                if ([vc isKindOfClass:NSClassFromString(noti.object[@"className"])]) {
                    self.selectedViewController = obj;
                    return ;
                }
            }
        }
    }
}

//移除引导页
- (void)cancelInteraction {
    [self.gvi removeFromSuperview];
}

//跳转用户中心
- (void)perFactAction {
    
    [self cancelInteraction];
    [self.viewControllers[0] pushViewController:[PersonalAuthenticationVC new] animated:YES];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setSelectedViewController" object:nil];
}

//标签选择按钮时间
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{

    if ([self.viewControllers indexOfObject:viewController] == 1) {
           if (!USER_INFO) {
               [self pushLogoinVC];
               return NO;
           }
    }
    return YES;
}

//登录跳转
-(void)pushLogoinVC {

    MLNavigationController * vc = [[MLNavigationController alloc] initWithRootViewController:[LoginViewController new]];
    [vc.navigationBar setBackgroundImage:[UIImage getImageWithColor:[UIColor whiteColor] andSize:CGSizeMake(SCREEN_W * 3, 64)] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:vc animated:YES completion:^{

    }];
}

@end
