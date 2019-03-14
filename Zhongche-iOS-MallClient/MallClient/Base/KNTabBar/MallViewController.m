//
//  MallViewController.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/10.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "MallViewController.h"
#import "MLNavigationController.h"
#import "OrderCenterVC.h"
#import "UserViewController.h"
#import "GuideVi.h"
#import "PersonalAuthenticationVC.h"
#import "LoginViewController.h"
#import "KNCustomTransportVC.h"
#import "VerbViewController.h"
#import "NSObject+Current.h"

@interface MallViewController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) GuideVi *gvi;
@property (nonatomic, assign) NSInteger curtten_vc;
@property (nonatomic, assign) NSInteger pre_vc;
@end

@implementation MallViewController

-(instancetype)init {

    self = [super init];
    if (self){
        self.curtten_vc = 0;
        NSArray * classStrings = @[@"KNWantTransportVC",@"KNCustomTransportVC",@"OrderCenterVC",@"UserViewController"];
        NSArray * titles = @[@"我要运力",@"需求申报",@"订单",@"我的"];
        NSArray * images = @[@"KN_tabbar_trans_nor",@"KN_tabbar_custom_nor",@"KN_tabbar_order_nor",@"KN_tabbar_mine_nor"];
        NSArray * selectedImages = @[@"KN_tabbar_trans_sel",@"KN_tabbar_custom_sel",@"KN_tabbar_order_sel",@"KN_tabbar_mine_sel"];
        UIViewController * vc;
        for (int i = 0; i < classStrings.count ; i ++){
            if (i < 4){
                vc = [[MLNavigationController alloc] initWithRootViewController:[[NSClassFromString(classStrings[i]) alloc]init]];
                //设置导航条背景图片
                [((MLNavigationController *)vc).navigationBar setBackgroundImage:[UIImage getImageWithColor:[UIColor whiteColor] andSize:CGSizeMake(SCREEN_W * 3, 64)] forBarMetrics:UIBarMetricsDefault];
                //设置导航条字体颜色
                [((MLNavigationController *)vc).navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:APP_COLOR_BLACK_TEXT}];
            }else{
                vc = [[NSClassFromString(classStrings[i]) alloc]init];
            }
            
            //设置图片原始颜色，不让其渲染
            UIImage *imageHome = [UIImage imageNamed:images[i]];
            imageHome = [imageHome imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImage *imageHomeSelect = [UIImage imageNamed:selectedImages[i]];
            imageHomeSelect = [imageHomeSelect imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:titles[i] image:imageHome selectedImage:imageHomeSelect];
            //文字颜色
            NSDictionary *dictHome = [NSDictionary dictionaryWithObject:[HelperUtil colorWithHexString:@"3BA0F3"] forKey:NSForegroundColorAttributeName];
            [vc.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateSelected];

       
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

//标签选择按钮事件
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    UserInfoModel * info = USER_INFO;
    
     NSArray * arr = [viewController childViewControllers];
     NSArray * arrs = [tabBarController childViewControllers];
    if ([self.viewControllers indexOfObject:viewController] == 1 ) {
        
        
        
           if (!USER_INFO) {
               [self pushLogoinVC];
               return NO;
           }else{
//               CONTRACT_CARRIER(1, "签约承运商"), REGISTER_USER(2, "注册用户"), REAL_NAME_USER(3, "实名用户"),AUTH_USER(4,"认证用户"),PLATFORM(5,"平台企业");
//               if ([info.companyType isEqualToString:@"4"] || [info.companyType isEqualToString:@"1"] || [info.companyType isEqualToString:@"3"] ) {
//
                   AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                   app.isClearCapModel = YES;

                   return YES;
//               }else{
//                   UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"\n您的账号尚未完成认证，请认证后继续后续操作\n" preferredStyle:UIAlertControllerStyleAlert];
//
//                   UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                       NSLog(@"点击了按钮1，进入按钮1的事件");
//
//                   }];
//
//                   UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                       UIViewController * controller = [self lc_getCurrentVC];
//
//                       VerbViewController * vc = [VerbViewController new];
//                       [controller.navigationController pushViewController:vc animated:YES];
//                   }];
//
//                   [alert addAction:action1];
//                   [alert addAction:action2];
//
//                   [self presentViewController:alert animated:YES completion:nil];
//                   return NO;
//
//               }
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
- (UIViewController *)lc_getCurrentVC {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    
    return result;
}
@end
