//
//  AppDelegate.h
//  Zhongche
//
//  Created by lxy on 16/7/8.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "ZSSearchCollectionViewCell.h"

@interface BaseViewController()<UIAlertViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer * clickMAXView;

@end


@implementation BaseViewController
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

- (id)init {
    self = [super init];
    if (self) {
        [self initParameters];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    tempAppDelegate.LeftSlideVC.pan.enabled = NO;
    [self.view addGestureRecognizer:self.clickMAXView];
    [self.clickMAXView addTarget:self action:@selector(hideTheKeyboard)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigationSet];
    [self bindModel];
    [self bindView];
    [self bindAction];
   
    // Do any additional setup after loading the view from its nib.
}

- (void)initParameters {
}


/**
 *  导航按钮设置
 */
- (void)navigationSet{
    
    self.btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnRight setFrame:CGRectMake(0, 0, 26, 20)];
    [_btnRight addTarget:self action:@selector(onRightAction) forControlEvents:UIControlEventTouchUpInside];

    _btnRight.titleLabel.textAlignment = NSTextAlignmentRight;
    _btnRight.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:_btnRight];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.btnRight.hidden = YES;
    
    self.btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnLeft setFrame:CGRectMake(0, 0, 26, 20)];
    [_btnLeft addTarget:self action:@selector(onBackAction) forControlEvents:UIControlEventTouchUpInside];

    [_btnLeft setImage:[UIImage imageNamed:@"fnahui"] forState:UIControlStateNormal];
    _btnLeft.highlighted = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:_btnLeft];
    self.navigationItem.leftBarButtonItem = backItem;
}

/**
 *  加载视图
 */
- (void)bindView {
}

/**
 *  加载模型
 */
- (void)bindModel {
}

/**
 *  加载方法
 */
- (void)bindAction {
}

- (void)loadViews {
   
}

//*****************************************************************
// MARK: - actions
//*****************************************************************

/**
 *  导航控制器上角按钮方法
 */
- (void)onBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)onRightAction
{
}


//隐藏键盘功能
- (UITapGestureRecognizer *)clickMAXView{
    if (!_clickMAXView) {
        _clickMAXView = [UITapGestureRecognizer new];
        _clickMAXView.delegate = self;
    }
    return _clickMAXView;
}

- (void)hideTheKeyboard {
    [self.view endEditing:YES];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [[touch.view.superview class] isSubclassOfClass:[ZSSearchCollectionViewCell class]]) {
        return NO;
    }
    return  YES;
}
//词典转换为字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//*****************************************************************
// MARK: - getter
//*****************************************************************

@end
