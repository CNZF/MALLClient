//
//  DemoViewController.h
//  MallClient
//
//  Created by lxy on 2017/2/16.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"

@interface DemoViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_rowArray;
    NSArray *_sectionArray;

    NSMutableDictionary *_showDic;//用来判断分组展开与收缩的
}


@end
