//
//  AccountCell.m
//  MallClient
//
//  Created by lxy on 2018/6/26.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "AccountCell.h"
#import "NSString+Money.h"

@interface AccountCell ()

@property (weak, nonatomic) IBOutlet UILabel *allAcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *debtLabel;


@end
@implementation AccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}
- (void)setInfo:(UserInfoModel *)info
{
    NSString * zeroStr = [NSString stringWithFormat:@"%@",@"0.00"];
    if (info) {
         self.allAcountLabel.textColor = [HelperUtil colorWithHexString:@"F03E3E"];
        self.debtLabel.textColor = [HelperUtil colorWithHexString:@"F03E3E"];
        if (info.accountAmount) {
            self.allAcountLabel.attributedText = [NSString getFormartPrice:[info.accountAmount floatValue]];
        }else{
            self.allAcountLabel.attributedText =[NSString getFormartPrice:[zeroStr floatValue]] ;
        }
        if (info.creditLimit) {
            self.debtLabel.attributedText = [NSString getFormartPrice:[info.creditLimit floatValue]];
        }else{
             self.debtLabel.attributedText =[NSString getFormartPrice:[zeroStr floatValue]] ;
        }
        
        
    }else{
        self.allAcountLabel.textColor = [HelperUtil colorWithHexString:@"999999"];
        self.debtLabel.textColor = [HelperUtil colorWithHexString:@"999999"];
        self.allAcountLabel.text = @"-- --";
        self.debtLabel.text = @"-- --";
    }
}

@end
