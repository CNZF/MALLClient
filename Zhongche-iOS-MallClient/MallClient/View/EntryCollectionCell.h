//
//  EntryCollectionCell.h
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/28.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntryCollectionCell : UICollectionViewCell
@property (nonatomic, strong) UILabel * textLabel;

@property (nonatomic, assign) BOOL bright;

@property (nonatomic, strong) UIView * bg;
@end

@interface EntryCollectionCellForConditionsForRetrievalVC : EntryCollectionCell

@end
