//
//  AppDelegate.h
//  Zhongche
//
//  Created by lxy on 16/7/8.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "MLNavigationController.h"
#include "LoginViewController.h"
#define iOS10Later ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f)

@interface BaseViewController()<UIAlertViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITapGestureRecognizer * clickMAXView;

@end


@implementation BaseViewController

- (id)init {
    self = [super init];
    if (self) {
        [self initParameters];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;

    [self.clickMAXView addTarget:self action:@selector(hideTheKeyboard)];
    self.view.backgroundColor = [UIColor whiteColor];
 
    [self navigationSet];
    [self bindModel];
    [self bindView];
    [self bindAction];
    [self getData];

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage getImageWithColor:APP_COLOR_GRAY_SEARCH_BG andSize:CGSizeMake(1, 1)]];
//    self.navigationController.navigationBar.translucent = NO;

}

- (void)initParameters {
}


/**
 *  导航按钮设置
 */
- (void)navigationSet{
    
    self.btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_btnRight setFrame:CGRectMake(0, 0, 44, 20)];
    [_btnRight addTarget:self action:@selector(onRightAction) forControlEvents:UIControlEventTouchUpInside];

    _btnRight.titleLabel.textAlignment = NSTextAlignmentRight;
    _btnRight.titleLabel.font = [UIFont systemFontOfSize:15];
    [_btnRight setTitleColor:APP_COLOR_GRAY666 forState:UIControlStateNormal];
    //[_btnRight setImage:[UIImage imageNamed:[@"消息" adS]] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:_btnRight];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.btnRight.hidden = YES;
    
    self.btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnLeft.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_btnLeft setFrame:CGRectMake(0, 0, 26, 20)];
    [_btnLeft addTarget:self action:@selector(onBackAction) forControlEvents:UIControlEventTouchUpInside];

    [_btnLeft setImage:[UIImage imageNamed:@"naviBack"] forState:UIControlStateNormal];
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

/**
 *  网络强求数据
 */
- (void)getData {

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

- (void)onRightAction {
}

//打电话
- (void)callAction {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否需要拨打客服电话联系客服？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.stTelephone = APP_CUSTOMER_SERVICE;

    [alert show];
}

//跳转登录页
-(void)pushLogoinVC {
    MLNavigationController * vc = [[MLNavigationController alloc] initWithRootViewController:[LoginViewController new]];
    [vc.navigationBar setBackgroundImage:[UIImage getImageWithColor:[UIColor whiteColor] andSize:CGSizeMake(SCREEN_W * 3, 64)] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:vc animated:YES completion:^{

    }];
}

- (void)checkout_logInSuccessBlock:(void (^)())successBlock{
    if (USER_INFO) {
        if (successBlock) {
            successBlock();
        }
    }else{
        [self pushLogoinVC];
    }
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch {
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] ||
        [NSStringFromClass([touch.view.superview class]) isEqualToString:@"EntryCollectionCell"] ||
        [NSStringFromClass([touch.view.superview class]) isEqualToString:@"EmptyContainerListCell"] ||
        [NSStringFromClass([touch.view.superview class]) isEqualToString:@"ImageCollectionViewCell"] ||
        [NSStringFromClass([touch.view.superview class]) isEqualToString:@"HotCapacityCell"] ||
        [NSStringFromClass([touch.view.superview class]) isEqualToString:@"EntryCollectionCellForConditionsForRetrievalVC"]
        )
    {
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

//时间戳转时间格式字符串
- (NSString *)stDateToString:(NSString *)stDate {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[stDate longLongValue]/1000];
    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    return [outputFormatter stringFromDate:date];

}

//时间戳转时间格式字符串
- (NSString *)stDateToString1:(NSString *)stDate {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[stDate longLongValue]/1000];
    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [outputFormatter stringFromDate:date];

}

//时间格式字符串转时间
- (NSDate *)stDateToDate:(NSString *)string {

    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* inputDate = [outputFormatter dateFromString:string];
    return inputDate;
}

- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate {
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

- (UILabel *)labelWithText:(NSString *)text WithFont:(UIFont *)font WithTextAlignment:(NSTextAlignment)textAlignment WithTextColor:(UIColor *)color{
    UILabel *lb = [UILabel new];
    lb.textAlignment = textAlignment;
    lb.text = text;
    lb.font = font;
    lb.textColor = color;
    return lb;
}

//跳转控制器
- (BaseViewController *)getControllerWithBaseName:(NSString *)name {

    NSString *classStr =  [NSString stringWithFormat:@"%@_%@",name,[NSStringFromClass([self class]) componentsSeparatedByString:@"_"][1]];
    BaseViewController *vc = [NSClassFromString(classStr) new];
    return vc;

}


- (NSString *)getMoneyStringWithMoneyNumber:(double)money{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    // 设置格式
    [numberFormatter setPositiveFormat:@"###,###.00;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:money]];
    return formattedNumberString;
}


/**
 *  文字转富文本
 *
 *  @param st 文字
 *
 *  @return 富文本
 */

- (NSMutableAttributedString *)attributedStrWithString:(NSString *)st {


    NSRange range;
    NSString *tmpStr = st;
    range = [tmpStr rangeOfString:@"："];

    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:tmpStr];


    [AttributedStr addAttribute:NSForegroundColorAttributeName

                          value:[UIColor blackColor]

                          range:NSMakeRange(range.location,tmpStr.length - range.location)];
    
    return AttributedStr;
}

//*****************************************************************
// MARK: - getter
//*****************************************************************


//*****************************************************************
// MARK: - delegates
//*****************************************************************

/**
 *  alertView代理
 *
 *  @param alertView   delegate
 */


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString * tel = [NSString stringWithFormat:@"tel://%@",APP_CUSTOMER_SERVICE_NO_];
    if (buttonIndex == 1) {
        if (iOS10Later) {
            /// 大于等于10.0系统使用此openURL方法
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel] options:@{} completionHandler:nil];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
        }
        
     
//        UIWebView * callWebview = [[UIWebView alloc]init];
//
//        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.stTelephone]]]];
//
//        [[UIApplication sharedApplication].keyWindow addSubview:callWebview];

    }
}

#pragma mark -- Getter
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
