//
//  MessageViewModel.h
//  MallClient
//
//  Created by lxy on 2018/6/28.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewModel.h"
#import "MessageModel.h"
#import "MyNeedModel.h"

@interface MessageViewModel : BaseViewModel

//获取列表
- (void)getUserMessageListWithType:(int)status WithCurrentPage:(int)currentPage WithPageSize:(int)pageSize callback:(void(^)(NSArray *arr,BOOL isLastPage))callback;

//删除信息
- (void)detailWithMessageStatus:(int)status MessageArray:(NSArray <MessageModel *> *)messageVArray callback:(void(^)(BOOL result))callback;

//请求是否有新消息
- (void) asyncNotReadMessage;

@end
