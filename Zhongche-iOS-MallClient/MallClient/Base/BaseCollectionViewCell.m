//
//  BaseCollectionViewCell.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2016/12/29.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self bindModel];
        [self bindView];
        [self bindAction];
    }
    return self;
}

/**
 *  加载视图
 */
- (void)bindView {}

/**
 *  加载模型
 */
- (void)bindModel {}

/**
 *  加载方法
 */
- (void)bindAction {}

-(void)loadUIWithmodel:(id)model {}

@end
