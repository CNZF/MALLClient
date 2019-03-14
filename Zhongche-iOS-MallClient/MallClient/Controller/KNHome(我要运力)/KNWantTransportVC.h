//
//  KNWantTransportVC.h
//  MallClient
//
//  Created by dushenke on 2018/4/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "MryScrollPageVC.h"
typedef NS_ENUM(NSUInteger, LineState) {
    JZXXL = 0,
    SDZXL,
};

@interface KNWantTransportVC : BaseViewController

@property (nonatomic, assign)LineState lineState;

@end
