//
//  KNOrderCompleteDatePicker.h
//  MallClient
//
//  Created by 沙漠 on 2018/5/4.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseView.h"

typedef void (^KNOrderCompleteDatePickerDateBlock)(NSString *dateStr);

@interface KNOrderCompleteDatePicker : BaseView

@property (nonatomic, copy) KNOrderCompleteDatePickerDateBlock dateBlock;

- (void)show;

@end
