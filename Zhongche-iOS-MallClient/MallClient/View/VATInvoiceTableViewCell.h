//
//  VATInvoiceTableViewCell.h
//  MallClient
//
//  Created by lxy on 2016/12/15.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VATInvoiceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viButton;
@property (weak, nonatomic) IBOutlet UIButton *btnSetDefault;
@property (weak, nonatomic) IBOutlet UIButton *btnEditbtn;
@property (weak, nonatomic) IBOutlet UIButton *btnShowAll;
@property (weak, nonatomic) IBOutlet UILabel *lbCompany;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbPhone;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbIdCode;
@property (weak, nonatomic) IBOutlet UILabel *lbRegAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbRegTel;
@property (weak, nonatomic) IBOutlet UILabel *lbRegBank;
@property (weak, nonatomic) IBOutlet UILabel *lbRegAcount;
@property (weak, nonatomic) IBOutlet UIImageView *ivChoose;
@property (weak, nonatomic) IBOutlet UIImageView *ivDefault;

@end
