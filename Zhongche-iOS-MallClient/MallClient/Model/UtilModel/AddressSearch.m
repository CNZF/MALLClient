//
//  AddressSearch.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/12/2.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "AddressSearch.h"

@interface AddressSearch()<AMapSearchDelegate>
@property (nonatomic, strong)AMapSearchAPI* search;

@property (nonatomic, copy)void (^callback)(NSArray *,NSString *);
@end

@implementation AddressSearch
//定义一个静态变量用于接收实例对象，初始化为nil
static AddressSearch *addressSearch=nil;


+(AddressSearch *)shareAddressSearch{
    @synchronized(self){//线程保护，增加同步锁
        if (addressSearch==nil) {
            addressSearch=[[self alloc] init];
        }
    }
    return addressSearch;
}
-(instancetype)init
{
    if (self = [super init])
    {
        [AMapServices sharedServices].apiKey = GAODE_MAP_KEY;
        
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
    }
    return self;
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    
    if (response.pois.count == 0) {

        return;
    }
    NSMutableArray * addressArr = [NSMutableArray array];

    for (AMapPOI * address in response.pois) {

        [addressArr addObject:address];

//        [addressArr addObject:[NSString stringWithFormat:@"%@ %@",address.name,address.address]];
    }
    if ([request isKindOfClass:[AMapPOIKeywordsSearchRequest class]])
    {
        self.callback(addressArr,((AMapPOIKeywordsSearchRequest *)request).keywords);

    }
}

/**
 *  地理位置检索
 *
 *  @param keyword  检索关键字（不可空）
 *  @param city     在city内检索，传空位全国检索
 *  @param callback 回调，传回地址列表
 */

- (void)searchKeyword:(NSString *__nonnull)keyword withCity:(NSString *__nullable)city withCallback:(void (^__nullable)(NSArray<AMapPOI*>*__nullable,NSString *__nullable searchStr))callback {

    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];

    request.keywords = keyword;
    if(city) {
        request.city = city;
        request.cityLimit = YES;
    }
    else {
        request.cityLimit = NO;
    }
   request.requireExtension = YES;
   request.requireSubPOIs = YES;
   self.callback = callback;
    [self.search AMapPOIKeywordsSearch:request];
}


@end
