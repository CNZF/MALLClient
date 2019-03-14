//
//  BaseCollectionViewCell.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2016/12/29.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionViewCell : UICollectionViewCell
- (void)bindView;
- (void)bindModel;
- (void)bindAction;
- (void)loadUIWithmodel:(id)model;
@end
