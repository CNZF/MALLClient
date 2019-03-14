//
//  SubmitOrderSuccessViewController.h
//  MallClient
//
//  Created by lxy on 2016/11/28.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//



#import "BaseViewController.h"


typedef enum{
    capacity,
    emptyContainer,
    emptyCar,
    coal
}OrderTypeEnum;

@interface SubmitOrderSuccessViewController : BaseViewController
@property (nonatomic, assign) OrderTypeEnum type;

@property (nonatomic, strong) NSString *stOrderNo;

@end
