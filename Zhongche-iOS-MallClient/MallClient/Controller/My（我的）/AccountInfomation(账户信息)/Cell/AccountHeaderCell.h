//
//  AccountHeaderCell.h
//  MallClient
//
//  Created by lxy on 2018/6/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountHeaderCell : UITableViewCell

@property (nonatomic, strong) UserInfoModel * info;

- (void) setsection:(NSInteger)section row:(NSInteger)row info:(UserInfoModel *)info;

@end
