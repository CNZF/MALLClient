//
//  KNResultFilterPopCell.m
//  MallClient
//
//  Created by 沙漠 on 2018/4/26.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNResultFilterPopCell.h"

@implementation KNResultFilterPopCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.mainLabel];
        WS(weakSelf)
        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(weakSelf.contentView);
        }];
    }
    return self;
}

#pragma mark — 实现自适应文字宽度的关键步骤:item的layoutAttributes
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    
    CGRect frame = [self.mainLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.mainLabel.frame.size.height) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.mainLabel.font,NSFontAttributeName, nil] context:nil];
    frame.size.height = 28;
    frame.size.width += 20;
    attributes.frame = frame;

    return attributes;
}


#pragma mark -- Getter
- (void)setItemSelected:(BOOL)itemSelected{
    _itemSelected = itemSelected;
    self.mainLabel.layer.borderColor = itemSelected ? APP_COLOR_BLUE_BTN.CGColor : APP_COLOR_GRAY_BTN_1.CGColor;
    self.mainLabel.textColor = itemSelected ? APP_COLOR_BLUE_BTN : APP_COLOR_GRAY999;
}

- (UILabel *)mainLabel{
    if (!_mainLabel) {
        _mainLabel = [[UILabel alloc] init];
        _mainLabel.layer.borderColor = APP_COLOR_GRAY_BTN_1.CGColor;
        _mainLabel.layer.borderWidth = 1.0;
        _mainLabel.layer.cornerRadius = 3.0;
        _mainLabel.layer.masksToBounds = YES;
        _mainLabel.textAlignment = NSTextAlignmentCenter;
        _mainLabel.font = [UIFont systemFontOfSize:10];
        _mainLabel.textColor = APP_COLOR_GRAY999;
    }
    return _mainLabel;
}

@end
