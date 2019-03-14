//
//  ProView.h
//  MallClient
//
//  Created by lxy on 2018/9/13.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProView : UIView

- (void)drawProRect:(long)curttenTime all:(long)allTime Model:(OrderModelForCapacity *)model;

- (void)drawProRectModel:(OrderModelForCapacity *)model;
@property (nonatomic, strong)OrderModelForCapacity * model;
@end
