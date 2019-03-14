//
//  VerbCell.m
//  MallClient
//
//  Created by lxy on 2018/6/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "VerbCell.h"

@interface VerbCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UIImageView *jiantouImageView;

@end

@implementation VerbCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (void)setInfo:(UserInfoModel *)info WithIndex:(NSInteger) index
{
    if (index == 0) {
        if (info.userName  == nil ) {
            self.stateLabel.text = @"未认证";
//            self.jiantouImageView.hidden = NO;
            self.stateImageView.image = [UIImage imageNamed:@"Oval 33"];
        }else{
            self.stateLabel.text = @"已认证";
//            self.jiantouImageView.hidden = YES;
            self.stateImageView.image = [UIImage imageNamed:@"Oval 3"];
        }
        self.nameLabel.text = @"账号联系人";
       
    }else if (index == 1){
        
        if ([info.authStatus intValue]  == 0 || info.authStatus == nil) {
            self.stateLabel.text = @"未认证";
            self.jiantouImageView.hidden = NO;
            self.stateImageView.image = [UIImage imageNamed:@"Oval 33"];
        }else if ([info.authStatus intValue] == 1){
            self.stateLabel.text = @"认证中";
            self.jiantouImageView.hidden = YES;
            self.stateImageView.image = [UIImage imageNamed:@"Oval 31"];
        }
        else if ([info.authStatus intValue] == 2){
            self.stateLabel.text = @"已认证";
            self.jiantouImageView.hidden = YES;
            self.stateImageView.image = [UIImage imageNamed:@"Oval 3"];
        }if ([info.authStatus intValue] == 3){
            self.stateLabel.text = @"被拒绝";
            self.jiantouImageView.hidden = NO;
            self.stateImageView.image = [UIImage imageNamed:@"Oval 33"];
        }
        
        self.nameLabel.text = @"企业信息";
    
    }else{
        
        if ([info.quaAuthStatus intValue]  == 0 || info.quaAuthStatus == nil) {
            self.stateLabel.text = @"未认证";
            self.jiantouImageView.hidden = NO;
            self.stateImageView.image = [UIImage imageNamed:@"Oval 33"];
        }else if ([info.quaAuthStatus intValue] == 1){
            self.stateLabel.text = @"认证中";
            self.jiantouImageView.hidden = YES;
            self.stateImageView.image = [UIImage imageNamed:@"Oval 31"];
        }
        else if ([info.quaAuthStatus intValue] == 2){
            self.stateLabel.text = @"已认证";
            self.jiantouImageView.hidden = YES;
            self.stateImageView.image = [UIImage imageNamed:@"Oval 3"];
        }if ([info.quaAuthStatus intValue] == 3){
            self.stateLabel.text = @"被拒绝";
            self.jiantouImageView.hidden = NO;
            self.stateImageView.image = [UIImage imageNamed:@"Oval 33"];
        }
        
        self.nameLabel.text = @"企业资质";
       
    }
}

@end
