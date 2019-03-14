//
//  SelectNormalMenuView.h
//  Paggy-Sloth
//
//  Created by 张熔冰 on 2017/12/6.
//  Copyright © 2017年 Lovcreate. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    ShowRed,
    SHowClear,
} ShowType;

@interface SelectNormalMenuView : UIView

@property(nonatomic, strong) UIColor* sliderColor;
@property(nonatomic, strong) UIColor* textColor;
@property(nonatomic, strong) UIColor* selectedTextColor;
@property(nonatomic, assign) ShowType showType;

@property(nonatomic, strong) void(^selectBlock)(NSInteger index);

+(instancetype)viewForFrame:(CGRect)frame titles:(NSArray*)titles index:(NSInteger)index;

-(void)setTitles:(NSArray*)titles selectedBlock:(void(^)(NSInteger index)) selectedBlock;

-(void)refreshRedStaus:(ShowType)showType;

@end
