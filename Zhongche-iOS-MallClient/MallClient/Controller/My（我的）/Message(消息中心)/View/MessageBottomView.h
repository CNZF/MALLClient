//
//  MessageBottomView.h
//  MallClient
//
//  Created by lxy on 2018/7/2.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^BottomViewSelectBlock)(BOOL ret);
typedef  void(^BottomViewDeleteBlock)(NSString * state);
@interface MessageBottomView : UIView
@property (weak, nonatomic) IBOutlet UIButton *readBtn;

@property (nonatomic, copy) BottomViewSelectBlock  block;
@property (nonatomic, copy) BottomViewDeleteBlock  deleteBlock;
- (void)setSelectBtnState;

@end
