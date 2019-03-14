//
//  AccountHeaderCell.m
//  MallClient
//
//  Created by lxy on 2018/6/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "AccountHeaderCell.h"
#import "UIImageView+WebCache.h"

@interface AccountHeaderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *suoImageView;


@end

@implementation AccountHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.suoImageView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setsection:(NSInteger)section row:(NSInteger)row info:(UserInfoModel *)info
{
    if (section == 0) {
        NSString * icon = [NSString stringWithFormat:@"%@%@",BASEIMGURL,info.icon];
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:[@"user_head" adS]]];
    }
    
    if (section == 1) {
        if (row == 0) {
            self.nameLabel.text = @"登录账号";
            self.detailLabel.text = info.loginName;
           
        }else{
            self.nameLabel.text = @"绑定手机";
            if (info.phone) {
                self.detailLabel.text = info.phone;

            }else{
                self.detailLabel.text = @"未绑定";
                self.suoImageView.hidden = NO;
            }
        }
    }else if (section == 2){
        self.nameLabel.text = @"修改密码";
        self.detailLabel.hidden = YES;
    }
}

@end
