//
//  NoTransDataView.h
//  MallClient
//
//  Created by lxy on 2018/7/18.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectBlock)(NSInteger index);

@interface NoTransDataView : UIView
@property (nonatomic, copy) SelectBlock block;
@end
