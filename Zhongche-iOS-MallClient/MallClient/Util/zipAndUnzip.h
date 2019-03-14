//
//  zipAndUnzip.h
//  zipdemo
//
//  Created by lxy on 16/8/16.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface zipAndUnzip : NSObject

- (NSData *)gzipInflate:(NSData*)data;
- (NSData *)gzipDeflate:(NSData*)data;

@end
