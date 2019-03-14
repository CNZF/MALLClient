//
//  CalculatorBottomView.h
//  MallClient
//
//  Created by lxy on 2018/6/13.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CapacityEntryModel.h"
#import "BoxModel.h"

typedef void(^SelectBlock)(NSInteger index);
typedef void(^FinishBlock)(NSInteger index);
@interface CalculatorBottomView : UIView

@property (nonatomic, copy)SelectBlock block;
@property (nonatomic, copy)FinishBlock finishbBlock;
@property (nonatomic, strong)CapacityEntryModel * ticketModel;
@property (nonatomic, strong)BoxModel * boxModel;
@end
