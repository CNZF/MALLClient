//
//  StatrAndCell.h
//  MallClient
//
//  Created by lxy on 2018/10/29.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^fieldBlock)(int tag);

@interface StatrAndCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *startCityField;
@property (weak, nonatomic) IBOutlet UITextField *endCityField;

@property (weak, nonatomic) IBOutlet UIButton *statrBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;

@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@property (nonatomic, copy)fieldBlock fildBlock;

@end
