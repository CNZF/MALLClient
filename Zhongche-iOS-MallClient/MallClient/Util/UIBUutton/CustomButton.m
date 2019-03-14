//
//  CustomButton.m
//  Sloth
//
//  Created by 张熔冰 on 2017/9/5.
//  Copyright © 2017年 Lovcreate. All rights reserved.
//

#import "CustomButton.h"
#import "UIView+Addition.h"
#import "UIColor+Addition.h"
#import "NSString+Addition.h"OrderDetailFootView
#import "UIImage+Addition.h"

@interface CustomButton()

@property(nonatomic, strong) UILabel* badgeLabel;

@end

@implementation CustomButton

-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.styleLeft) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.image.size.width, 0, self.imageView.image.size.width)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width+4.5f, 0, -self.titleLabel.bounds.size.width-4.5f)];
    }
    
    if (self.styleBottom) {
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self setTitleEdgeInsets:UIEdgeInsetsMake(self.imageView.frame.size.height+6.f, -self.imageView.frame.size.width, -6.f, 0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(-6, 0, 6.f, -self.titleLabel.bounds.size.width)];
    }
}

-(UILabel*)badgeLabel{
    if (!_badgeLabel) {
        NSString* text;
        if ([_badgeValue integerValue] > 99) {
            text = @"99+";
        }else{
            text = _badgeValue;
        }
        _badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAX([text lc_sizeForSpecialWidth:NSIntegerMax fontSize:10.f].width+6.f, 14.f), 14.f)];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.font = [UIFont systemFontOfSize:10.f];
        _badgeLabel.backgroundColor = RGBA(0x983079, 1);
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.text = text;
        [_badgeLabel.layer setMasksToBounds:YES];
        [_badgeLabel.layer setCornerRadius:_badgeLabel.lc_h/2];
        _badgeLabel.lc_center = CGPointMake(self.imageView.lc_x+self.imageView.lc_w, self.imageView.lc_y);
        
    }
    return _badgeLabel;
}

-(void)setBadgeValue:(NSString *)badgeValue{
    _badgeValue = badgeValue;
    if (badgeValue == nil || [badgeValue isEqualToString:@""] || [badgeValue integerValue] == 0) {
        if (_badgeLabel && _badgeLabel.superview) {
            [_badgeLabel removeFromSuperview];
        }
    }else{
        [self addSubview:self.badgeLabel];
    }
}


-(void)setIsMainStyleButton:(BOOL)isMainStyleButton{
    _isMainStyleButton = isMainStyleButton;
    if (isMainStyleButton) {
        //配置按钮
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage lc_imageWithColor:RGBA(0x775F9F, 1)] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage lc_imageWithColor:RGBA(0x51406B, 1)] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage lc_imageWithColor:RGBA(0xCCCCCC, 1)] forState:UIControlStateDisabled];
        self.adjustsImageWhenHighlighted = NO;
    }
}

@end
