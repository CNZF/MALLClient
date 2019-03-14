//
//  OrderProgressWaitConfirmCell.m
//  MallClient
//
//  Created by lxy on 2018/6/7.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "OrderProgressWaitConfirmCell.h"
#import "NSString+Money.h"

@interface OrderProgressWaitConfirmCell ()
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstDate;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;


@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *seconddate;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;


@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeDate;
@property (weak, nonatomic) IBOutlet UIImageView *threeImageView;


@property (weak, nonatomic) IBOutlet UILabel *fourLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourDate;
@property (weak, nonatomic) IBOutlet UIImageView *fourImageView;


@property (weak, nonatomic) IBOutlet UILabel *fiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveDate;
@property (weak, nonatomic) IBOutlet UIImageView *fiveImageview;

@end


@implementation OrderProgressWaitConfirmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(OrderModelForCapacity *)model
{
    if (model.orderProgress.count ==1) {
        OrderProgressModel * progressModel = model.orderProgress[0];
        self.firstLabel.text = progressModel.name;
        self.firstDate.text = [NSString TimeGetDateHHmmDD:progressModel.time];
    }
    
    if (model.orderProgress.count ==2) {
        OrderProgressModel * progressModel1 = model.orderProgress[0];
        self.firstLabel.text = progressModel1.name;
        self.firstDate.text = [NSString TimeGetDateHHmmDD:progressModel1.time];
        
        OrderProgressModel * progressModel2 = model.orderProgress[1];
        self.secondLabel.text = progressModel2.name;
        self.seconddate.text = [NSString TimeGetDateHHmmDD:progressModel2.time];
    }
    
    if (model.orderProgress.count ==3) {
        OrderProgressModel * progressModel1 = model.orderProgress[0];
        self.firstLabel.text = progressModel1.name;
        self.firstDate.text = [NSString TimeGetDateHHmmDD:progressModel1.time];
        
        OrderProgressModel * progressModel2 = model.orderProgress[1];
        self.secondLabel.text = progressModel2.name;
        self.seconddate.text = [NSString TimeGetDateHHmmDD:progressModel2.time];
        
        OrderProgressModel * progressModel3 = model.orderProgress[2];
        self.threeLabel.text = progressModel3.name;
        self.threeDate.text = [NSString TimeGetDateHHmmDD:progressModel3.time];
    }

    if (model.orderProgress.count ==4) {
        OrderProgressModel * progressModel1 = model.orderProgress[0];
        self.firstLabel.text = progressModel1.name;
        self.firstDate.text = [NSString TimeGetDateHHmmDD:progressModel1.time];

        OrderProgressModel * progressModel2 = model.orderProgress[1];
        self.secondLabel.text = progressModel2.name;
        self.seconddate.text = [NSString TimeGetDateHHmmDD:progressModel2.time];

        OrderProgressModel * progressModel3 = model.orderProgress[2];
        self.threeLabel.text = progressModel3.name;
        self.threeDate.text = [NSString TimeGetDateHHmmDD:progressModel3.time];

        OrderProgressModel * progressModel4 = model.orderProgress[3];
        self.fourLabel.text = progressModel4.name;
        self.fourDate.text = [NSString TimeGetDateHHmmDD:progressModel4.time];
        
    }
    
    
    if (model.orderProgress.count ==5) {
        OrderProgressModel * progressModel1 = model.orderProgress[0];
        self.firstLabel.text = progressModel1.name;
        self.firstDate.text = [NSString TimeGetDateHHmmDD:progressModel1.time];
        
        OrderProgressModel * progressModel2 = model.orderProgress[1];
        self.secondLabel.text = progressModel2.name;
        self.seconddate.text = [NSString TimeGetDateHHmmDD:progressModel2.time];
        
        OrderProgressModel * progressModel3 = model.orderProgress[2];
        self.threeLabel.text = progressModel3.name;
        self.threeDate.text = [NSString TimeGetDateHHmmDD:progressModel3.time];
        
        OrderProgressModel * progressModel4 = model.orderProgress[3];
        self.fourLabel.text = progressModel4.name;
        self.fourDate.text = [NSString TimeGetDateHHmmDD:progressModel4.time];
        
        OrderProgressModel * progressModel5 = model.orderProgress[4];
        self.fiveLabel.text = progressModel5.name;
        self.fiveDate.text = [NSString TimeGetDateHHmmDD:progressModel5.time];
        
    }
    
}

@end
