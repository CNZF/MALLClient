//
//  ForgetPwdController.h
//  MallClient
//
//  Created by lxy on 2018/7/11.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ForgetPassWordBlock)(NSString * userName);

@interface ForgetPwdController : BaseViewController

@property (nonatomic, copy) ForgetPassWordBlock  forgetBlock;

@end
