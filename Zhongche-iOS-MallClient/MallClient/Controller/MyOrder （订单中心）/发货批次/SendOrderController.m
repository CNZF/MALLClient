//
//  SendOrderController.m
//  MallClient
//
//  Created by lxy on 2018/6/10.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "SendOrderController.h"
#import "NinaPagerView.h"
#define NotiDetailModel @"kNotiDetailModel"
#define TITELS @[@"全部",@"待发货",@"在途",@"已交付"];

@interface SendOrderController ()<NinaPagerViewDelegate>
@property (nonatomic, strong) UIButton *btnLeft;
@end

@implementation SendOrderController
{
    NinaPagerView *ninaPagerView;
}
@dynamic btnLeft;

- (void)viewDidLoad{
    [self navigationSet];
    self.title = @"发货批次";
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

- (void)navigationSet{

    self.btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnLeft.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.btnLeft setFrame:CGRectMake(0, 0, 26, 20)];
    [self.btnLeft addTarget:self action:@selector(onBackAction) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.btnLeft setImage:[UIImage imageNamed:[@"naviBack" adS]] forState:UIControlStateNormal];
    [self.btnLeft setImage:[UIImage imageNamed:@"naviBack"] forState:UIControlStateNormal];
    self.btnLeft.highlighted = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:self.btnLeft];
    self.navigationItem.leftBarButtonItem = backItem;
    
}
- (NSArray *)ninaColorArray {
    return @[
             APP_COLOR_BLUE_TOP, /**< 选中的标题颜色 Title SelectColor  **/
             APP_COLOR_GRAY_TEXT_1, /**< 未选中的标题颜色  Title UnselectColor **/
             APP_COLOR_BLUE_TOP, /**< 下划线颜色或滑块颜色 Underline or SlideBlock Color   **/
             APP_COLOR_WHITE, /**<  上方菜单栏的背景颜色 TopTab Background Color   **/
             ];
}

- (void)onBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}
//顶部筛选视图隐藏
- (BOOL)deallocVCsIfUnnecessary {
    return YES;
}

//SendOrderDetailController_ALL SendOrderDetailController_WaitSend  SendOrderDetailController_OnLoad  SendOrderDetailController_HadSend
- (NSArray *)ninaVCsArray {
    return @[
             @"SendOrderDetailController_ALL",
             @"SendOrderDetailController_WaitSend",
             @"SendOrderDetailController_OnLoad",
             @"SendOrderDetailController_HadSend",
             ];
}
@end
