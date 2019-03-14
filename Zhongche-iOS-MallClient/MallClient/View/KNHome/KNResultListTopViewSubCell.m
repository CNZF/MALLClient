//
//  KNResultListTopViewSubCell.m
//  MallClient
//
//  Created by 沙漠 on 2018/4/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNResultListTopViewSubCell.h"

@interface KNResultListTopViewSubCell ()

@property (weak, nonatomic) IBOutlet UILabel *cuttinLine;


@end

@implementation KNResultListTopViewSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark -- Setter

- (void)setCellSelected:(BOOL)cellSelected{
    _cellSelected = cellSelected;
    if (cellSelected) {
        self.backgroundColor = [HelperUtil colorWithHexString:@"3BA0F3"];
        self.dateLabel.textColor = [UIColor whiteColor];
        self.weekLabel.textColor = [UIColor whiteColor];
        self.priceLabel.textColor = [UIColor whiteColor];
        self.cuttinLine.backgroundColor = [HelperUtil colorWithHexString:@"3BA0F3"];
    }else{
        self.backgroundColor = [UIColor whiteColor];
        self.dateLabel.textColor = APP_COLOR_GRAY_TEXT_1;
        self.weekLabel.textColor = APP_COLOR_GRAY_TEXT_1;
        self.priceLabel.textColor = APP_COLOR_RED1;
        self.cuttinLine.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
    }
}

@end
