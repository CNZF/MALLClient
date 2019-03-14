//
//  SearchGoodsCell.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/28.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "SearchGoodsCell.h"

@interface SearchGoodsCell()

@property (nonatomic,strong) UIImageView * img;
@property (nonatomic,strong) UILabel * textLab;
@property (nonatomic,strong) UIView * line;
@end

@implementation SearchGoodsCell
-(void)loadUIWithmodel:(GoodsInfo *)model
{
    self.textLab.text = model.name;
}
-(void)bindView
{
    self.img.frame = CGRectMake(15, 15, 13, 13);
    [self addSubview:self.img];
    
    self.textLab.frame = CGRectMake(self.img.right + 15, 5, SCREEN_W - 30 - self.img.right, 30);
    [self addSubview:self.textLab];
    
    self.line.frame = CGRectMake(0, 43, SCREEN_W, 1);
    [self addSubview:self.line];
}

-(UIImageView *)img
{
    if (!_img) {
        _img = [UIImageView new];
        _img.image = [UIImage imageNamed:[@"shangpin" adS]];
    }
    return _img;
}
-(UIView *)line
{
    if(!_line)
    {
        _line = [UIView new];
        _line.backgroundColor = APP_COLOR_WHITEBG;
    }
    return _line;
}
-(UILabel *)textLab
{
    if (!_textLab) {
        _textLab = [UILabel new];
        _textLab.font = [UIFont systemFontOfSize:14.0f];
        _textLab.textColor = APP_COLOR_BLACK_TEXT;
    }
    return _textLab;
}
@end
