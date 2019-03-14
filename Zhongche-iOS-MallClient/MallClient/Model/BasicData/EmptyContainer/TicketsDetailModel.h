//
//  TicketsDetailModel.h
//  MallClient
//
//  Created by Tim on 2018/5/2.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"
#import "EntrepotModel.h"
#import "ContainerModel.h"
@class ContainerModel;
@class EntrepotModel;

@interface TicketsDetailModel : BaseModel
@property (nonatomic, copy) NSString *startName;
@property (nonatomic, copy) NSString *endName;

@property (nonatomic, strong) EntrepotModel *startEntrepotName;

@property (nonatomic, strong) EntrepotModel *endEntrepotName;

@property (nonatomic, strong) NSArray <ContainerModel *>*simpleTransportList;

@property (nonatomic, copy) NSString * containerName;//集装箱类型
@property (nonatomic, copy) NSString * containerId; //集装箱id
@property (nonatomic, copy) NSString * ID; //运力票ID
@property (nonatomic, assign) BOOL flagContainer;  // false 解析 simpleTransportList true 不解析
@property (nonatomic, assign) double  oneTicketTotal;
@property (nonatomic, assign) int transportMinimum;
@end
