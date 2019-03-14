//
//  SelectView.h
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/28.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseView.h"

@interface SelectView : BaseView

+(SelectView *)addSelectViewWithEntrys:(NSArray *)entrys WithSelectEntry:(NSString *)entry WithCallback:(void (^)(NSString *))callback;

@end
