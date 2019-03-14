//
//  OrderPayDetailController.m
//  MallClient
//
//  Created by lxy on 2018/6/10.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "OrderPayDetailController.h"
#import "NinaPagerView.h"
#define NotiDetailModel @"kNotiDetailModel"
#define TITELS @[@"全部",@"线上支付",@"线下付款"];
@interface OrderPayDetailController ()<NinaPagerViewDelegate>

@end

@implementation OrderPayDetailController
{
    NinaPagerView *ninaPagerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"支付明细";
    self.btnLeft.hidden = NO;
    self.btnRight.hidden = YES;
    NSArray *titleArray = TITELS;
    NSArray *colorArray = [self ninaColorArray];
    NSArray *vcsArray = [self ninaVCsArray];
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.model = self.model;
    ninaPagerView = [[NinaPagerView alloc] initWithNinaPagerStyle:NinaPagerStyleBottomLine WithTitles:titleArray WithVCs:vcsArray WithColorArrays:colorArray];
    ninaPagerView.titleScale = 1.15;
    ninaPagerView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - kNavBarHeaderHeight - kiPhoneFooterHeight - kTabbarHight);
    [self.view addSubview:ninaPagerView];
    ninaPagerView.pushEnabled = YES;
    ninaPagerView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)ninaColorArray {
    return @[
             APP_COLOR_BLUE_TOP, /**< 选中的标题颜色 Title SelectColor  **/
             APP_COLOR_GRAY_TEXT_1, /**< 未选中的标题颜色  Title UnselectColor **/
             APP_COLOR_BLUE_TOP, /**< 下划线颜色或滑块颜色 Underline or SlideBlock Color   **/
             APP_COLOR_WHITE, /**<  上方菜单栏的背景颜色 TopTab Background Color   **/
             ];
}
//顶部筛选视图隐藏
- (BOOL)deallocVCsIfUnnecessary {
    return YES;
}

//OrderPayDetailContentController_ALL OrderPayDetailContentController_OnLine OrderPayDetailContentController_Nomal
- (NSArray *)ninaVCsArray {
    return @[
             @"OrderPayDetailContentController_ALL",
             @"OrderPayDetailContentController_OnLine",
             @"OrderPayDetailContentController_Nomal",
             ];
}

@end
