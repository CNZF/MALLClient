//
//  EntryCollectionCell.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/28.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "EntryCollectionCell.h"

@implementation EntryCollectionCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        _bg = [UIView new];
        _bg.backgroundColor = [UIColor whiteColor];
        [_bg.layer setMasksToBounds:YES];
        [_bg.layer setCornerRadius:12];//设置矩形四个圆角半径
        _bg.layer.borderColor = [APP_COLOR_GRAY_CAPACITY_LINE CGColor];
        _bg.layer.borderWidth = 1;
        [self addSubview:_bg];
        
        _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = APP_COLOR_GRAY_TEXT_1;
        _textLabel.font = ENTRY_SELECT_FONT;
        [self addSubview:_textLabel];
    }
    return self;
}

-(void)setBright:(BOOL)bright
{
    _bright = bright;
    if (bright) {
        self.textLabel.textColor = APP_COLOR_ORANGE_BTN_TEXT;
        self.bg.layer.borderColor = [APP_COLOR_ORANGE_BTN_TEXT CGColor];
    }
    else
    {
        self.textLabel.textColor = APP_COLOR_GRAY_TEXT_1;
        self.bg.layer.borderColor = [APP_COLOR_GRAY_CAPACITY_LINE CGColor];
    }

}
@end

@implementation EntryCollectionCellForConditionsForRetrievalVC

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self.bg.layer setCornerRadius:16];//设置矩形四个圆角半径
    }
    return self;
}

-(void)setBright:(BOOL)bright {
    [super setBright:bright];
    if (bright) {
        self.textLabel.textColor = APP_COLOR_ORANGE_BTN_TEXT;
        self.bg.layer.borderColor = [APP_COLOR_ORANGE_BTN_TEXT CGColor];
    }
    else
    {
        self.textLabel.textColor = APP_COLOR_BLACK_TEXT;
        self.bg.layer.borderColor = [APP_COLOR_GRAY_CAPACITY_LINE CGColor];
    }
    
}

@end
