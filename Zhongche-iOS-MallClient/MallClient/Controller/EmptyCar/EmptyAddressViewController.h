//
//  EmptyAddressViewController.h
//  MallClient
//
//  Created by lxy on 2017/3/30.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "EmptyCarModel.h"

@interface EmptyAddressViewController : BaseViewController

typedef void (^ReturnBlock)(NSString *name,NSString *phone,NSString *startFullName,NSString *endFullName);

@property (nonatomic, copy  ) ReturnBlock    returnInfoBlock;
@property (weak, nonatomic  ) IBOutlet UITextField *tfName;
@property (weak, nonatomic  ) IBOutlet UITextField *tfPhone;
@property (nonatomic, strong) YMTextView  *tvStart;
@property (nonatomic, strong) YMTextView  *tvEnd;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;

@property (nonatomic, assign) int type;


- (void)returnInfo:(ReturnBlock)block;

@property (nonatomic, strong) EmptyCarModel *currentModel;

@end
