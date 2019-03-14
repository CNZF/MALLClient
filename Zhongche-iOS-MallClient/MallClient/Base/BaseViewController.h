//
//  AppDelegate.h
//  Zhongche
//
//  Created by lxy on 16/7/8.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Toast.h"
#import "UIView+Frame.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIImageView+WebCache.h"
#import "MyFilePlist.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "UINavigationController+StackManager.h"
#import "YMTextView.h"
#import "YMKJVerificationTools.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIButton *btnRight;
@property (nonatomic, strong) UIButton *btnLeft;
@property (nonatomic, strong) NSString *stTelephone;

@property (nonatomic, strong) NSMutableArray *dataArray;


- (void)bindView;
- (void)bindModel;
- (void)bindAction;
- (void)onBackAction;
- (void)onRightAction;
- (void)getData;

/**
 *  导航按钮设置
 */
- (void)navigationSet;

- (NSString*)dictionaryToJson:(NSDictionary *)dic;

//时间戳转时间格式字符串
- (NSString *)stDateToString:(NSString *)stDate;

//时间戳转时间格式字符串
- (NSString *)stDateToString1:(NSString *)stDate;

//时间格式字符串转时间
- (NSDate *)stDateToDate:(NSString *)string;

//生成UILabel
- (UILabel *)labelWithText:(NSString *)text WithFont:(UIFont *)font WithTextAlignment:(NSTextAlignment)textAlignment WithTextColor:(UIColor *)color;

- (BaseViewController *)getControllerWithBaseName:(NSString *)name;

- (NSString *)getMoneyStringWithMoneyNumber:(double)money;

//UTC转北京时间

- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDat;

//打电话
- (void)callAction;

//跳转登录
-(void)pushLogoinVC;

/**
 * 登录校验
 */
- (void)checkout_logInSuccessBlock:(void (^)())successBlock;


/**
 *  文字转富文本
 *
 *  @param st 文字
 *
 *  @return 富文本
 */

- (NSMutableAttributedString *)attributedStrWithString:(NSString *)st;

@end
