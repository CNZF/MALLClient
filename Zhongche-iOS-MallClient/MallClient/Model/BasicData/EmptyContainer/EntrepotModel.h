//
//  EntrepotModel.h
//  MallClient
//
//  Created by Tim on 2018/5/2.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"

@interface EntrepotModel : BaseModel

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *contacts;
@property (nonatomic, copy) NSString *contactsPhone;

@end
