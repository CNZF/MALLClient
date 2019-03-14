//
//  KNWantTransportSectionHeader.h
//  MallClient
//
//  Created by dushenke on 2018/4/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HeadBlock)(NSString * title);

@interface KNWantTransportSectionHeader : UITableViewHeaderFooterView
@property (nonatomic, copy) HeadBlock headBlock;

@end
