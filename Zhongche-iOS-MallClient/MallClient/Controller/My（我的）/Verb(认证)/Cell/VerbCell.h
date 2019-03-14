//
//  VerbCell.h
//  MallClient
//
//  Created by lxy on 2018/6/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerbCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UserInfoModel * info;

- (void)setInfo:(UserInfoModel *)info WithIndex:(NSInteger) index;

@end
