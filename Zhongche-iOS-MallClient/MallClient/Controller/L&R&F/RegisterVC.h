//
//  RegisterVC.h
//  MallClient
//
//  Created by lxy on 2017/1/17.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "UITextField+LCWordLimit.h"

typedef enum : NSUInteger {
    CompanyRegis = 0,
    UserRegis,
} RegisClass;

@interface RegisterVC : BaseViewController

@property (weak, nonatomic  ) IBOutlet UITextField *tfUserName;
@property (weak, nonatomic  ) IBOutlet UITextField *tfPassWord;
@property (weak, nonatomic  ) IBOutlet UITextField *tfPassWordAgain;
@property (weak, nonatomic  ) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic  ) IBOutlet UITextField *tfCode;
@property (weak, nonatomic  ) IBOutlet UIButton    *btnGetCode;
@property (weak, nonatomic  ) IBOutlet UILabel     *lbCompany;
@property (weak, nonatomic  ) IBOutlet UILabel     *lbPerson;
@property (weak, nonatomic  ) IBOutlet UIButton    *btnResist;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *userProtocalBtn;


@property (strong, nonatomic) IBOutlet UIView      *viPersonForbiden;
@property (weak, nonatomic) IBOutlet UITextField *personPhone;
@property (weak, nonatomic) IBOutlet UITextField *personPassWord;
@property (weak, nonatomic) IBOutlet UITextField *personCode;
@property (weak, nonatomic) IBOutlet UIButton *personAgressBtn;
@property (weak, nonatomic) IBOutlet UIButton *personBtnResist;
@property (weak, nonatomic) IBOutlet UIButton *personBtnGetCode;


@end
