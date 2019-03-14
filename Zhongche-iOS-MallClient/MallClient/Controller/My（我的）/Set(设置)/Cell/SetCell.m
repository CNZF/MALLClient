//
//  SetCell.m
//  MallClient
//
//  Created by lxy on 2018/6/26.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "SetCell.h"


@interface SetCell()

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serverLabel;

@end

@implementation SetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) setIndex:(NSInteger)index titleArray:(NSArray *)titleArray  imageArray:(NSArray *)imageArray
{
    self.leftImageView.image = [UIImage imageNamed:imageArray[index]];
    self.nameLabel.text = titleArray[index];
    self.serverLabel.text = APP_CUSTOMER_SERVICE;
    if (index == 1) {
        self.serverLabel.hidden = NO;
    }
}
@end
