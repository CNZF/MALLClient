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

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIButton *btnRight;
@property (nonatomic, strong) UIButton *btnLeft;
   
- (void)bindView;
- (void)bindModel;
- (void)bindAction;
- (void)onBackAction;
- (void)onRightAction;
- (NSString*)dictionaryToJson:(NSDictionary *)dic;

@end
