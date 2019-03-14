//
//  paymentFlowModel.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/21.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "PaymentFlowModel.h"

@implementation PaymentFlowModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"updateTime":@"time"};
}

-(void)setStatus:(NSString *)status {
    switch ([status intValue]) {
//            WAIT_SEND(0, "待发起"), SUCCESS(1, "成功"), FAIL(2, "失败"), PAY_IN(3, "支付中"), REVOKE(4, "已撤销"), REFUND(5, "已退款"), WAIT_CONFIRM(6, "待确认"),DELETE(-1,"删除");
        case 0:
            self.statusStr = @"待发起";
            break;
        case 1:
            self.statusStr = @"成功";

            break;
        case 2:
            self.statusStr = @"失败";

            break;
        case 3:
            self.statusStr = @"支付中";

            break;
        case 4:
            self.statusStr = @"已撤销";

            break;
        case 5:
            self.statusStr = @"已退款";

            break;
        case 6:
            self.statusStr = @"待确认";

            break;
        case -1:
            self.statusStr = @"删除";

            break;
        default:
            break;
    }
}
@end
