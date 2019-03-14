//
//  DetailZeroHeadView.h
//  MallClient
//
//  Created by lxy on 2018/11/7.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModelForCapacity.h"

@interface DetailZeroHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *OutView;
@property (weak, nonatomic) IBOutlet UIView *inView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inViewWidth;

@property (nonatomic, strong) OrderModelForCapacity * model;

@end
