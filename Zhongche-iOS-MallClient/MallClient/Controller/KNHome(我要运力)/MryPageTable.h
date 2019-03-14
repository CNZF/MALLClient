//
//  MainTableView.h
//  MryNewsFrameWork
//
//  Created by mryun11 on 16/6/7.
//  Copyright © 2016年 mryun11. All rights reserved.
//

#import <UIKit/UIKit.h>
 typedef void(^ScrollBlcok)(CGFloat conY);

@interface MryPageTable : UITableView

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) ScrollBlcok scrollBlcok;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style Code:(NSString *)code;

@end
