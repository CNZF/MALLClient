//
//  OrderCenterTabCell.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/12/5.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "OrderCenterTabCell.h"
#import "MGSwipeTableCell.h"
#import "UIImageView+WebCache.h"

@interface OrderCenterTabCell_Header : BaseTableViewCell
@property (nonatomic,strong)UIView * lineVe;
@property (nonatomic,strong)UILabel* orderIDLab;
@property (nonatomic,strong)UILabel* ordetTypeLab;
@end

@implementation OrderCenterTabCell_Header
-(void)loadUIWithmodel:(OrderModel *)model
{
    self.orderIDLab.text = [NSString stringWithFormat:@"订单号:%@",model.orderID];
    
    self.ordetTypeLab.text = model.ordetType;
    
    if([self.ordetTypeLab.text isEqualToString:@"待付款"]||[self.ordetTypeLab.text isEqualToString:@"待发货"]||[self.ordetTypeLab.text isEqualToString:@"待收货"]||[self.ordetTypeLab.text isEqualToString:@"审核未通过"]||[self.ordetTypeLab.text isEqualToString:@"待确认"]||[self.ordetTypeLab.text isEqualToString:@"待退款"])
    {
        self.ordetTypeLab.textColor = APP_COLOR_ORANGE_BTN_TEXT;
    }
    else if([self.ordetTypeLab.text isEqualToString:@"已完成"]||[self.ordetTypeLab.text isEqualToString:@"已取消"])
    {
        self.ordetTypeLab.textColor = APP_COLOR_GRAY2;

    }
}
-(void)bindView
{
    self.lineVe.frame = CGRectMake(0, 0, SCREEN_W, 10);
    [self addSubview:self.lineVe];
    
    self.orderIDLab.frame = CGRectMake(15, self.lineVe.bottom + 15, SCREEN_W * 2.1 / 3 - 15, 17);
    [self addSubview:self.orderIDLab];
    
    self.ordetTypeLab.frame = CGRectMake(self.orderIDLab.right + 15, self.lineVe.bottom + 12, SCREEN_W * 0.9 / 3 - 30, 17);
    [self addSubview:self.ordetTypeLab];
}

-(UIView *)lineVe
{
    if (!_lineVe) {
        _lineVe = [UIView new];
        _lineVe.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        
    }
    return _lineVe;
}
-(UILabel *)orderIDLab
{
    if (!_orderIDLab) {
        _orderIDLab = [UILabel new];
        _orderIDLab.font = [UIFont systemFontOfSize:14.0f];
        _orderIDLab.textAlignment = NSTextAlignmentLeft;
        _orderIDLab.textColor = APP_COLOR_BLACK_TEXT;
    }
    return _orderIDLab;
}
-(UILabel *)ordetTypeLab
{
    if (!_ordetTypeLab) {
        _ordetTypeLab = [UILabel new];
        _ordetTypeLab.font = [UIFont systemFontOfSize:14.0f];
        _ordetTypeLab.textAlignment = NSTextAlignmentRight;
        _ordetTypeLab.textColor = APP_COLOR_ORANGE_BTN_TEXT;
    }
    return _ordetTypeLab;
}
@end

@interface OrderCenterTabCell_Center : MGSwipeTableCell
@property (nonatomic, strong)UIImageView * imageVe;
@property (nonatomic, strong)UILabel * capacityTypeLab;
@property (nonatomic, strong)UILabel * linesLab;
@property (nonatomic, strong)UILabel * goodsLab;
@end

@implementation OrderCenterTabCell_Center
-(void)loadUIWithmodel:(OrderModel *)model
{

    [self.imageVe sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]  placeholderImage:[UIImage imageNamed:@"001.png"]];
    
    self.capacityTypeLab.text = model.capacityType;
    
    self.linesLab.text = [NSString stringWithFormat:@"%@ - %@",model.startPlace,model.endPlace];
    
    
    if ([model.capacityType isEqualToString:@"集装箱运力"]) {
        self.goodsLab.text = [NSString stringWithFormat:@"%@ / %@箱",model.goodsName,model.goodsNum];

    }
    else if ([model.capacityType isEqualToString:@"散堆装运力"]) {
        self.goodsLab.text = [NSString stringWithFormat:@"%@ / %@吨 / %@立方",model.goodsName,model.weight,model.volume];
        
    }
    else if ([model.capacityType isEqualToString:@"三农化肥运力"]) {
        self.goodsLab.text = [NSString stringWithFormat:@"%@ / %@吨",model.goodsName,model.weight];    }
}
-(void)bindView
{
    self.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
    
    self.imageVe.frame = CGRectMake(19, 19, 70, 70);
    [self addSubview:self.imageVe];
    
    self.capacityTypeLab.frame = CGRectMake(self.imageVe.right + 15, 18, SCREEN_W - self.imageVe.right - 30, 15);
    [self addSubview:self.capacityTypeLab];
    
    self.linesLab.frame = CGRectMake(self.imageVe.right + 15, 15 + self.capacityTypeLab.bottom, SCREEN_W - self.imageVe.right - 30, 15);
    [self addSubview:self.linesLab];
    
    self.goodsLab.frame = CGRectMake(self.imageVe.right + 15, 15 + self.linesLab.bottom, SCREEN_W - self.imageVe.right - 30, 15);
    [self addSubview:self.goodsLab];
}

-(UIImageView *)imageVe
{
    if (!_imageVe) {
        _imageVe = [UIImageView new];
    }
    return _imageVe;
}
-(UILabel *)capacityTypeLab
{
    if (!_capacityTypeLab) {
        _capacityTypeLab = [UILabel new];
        _capacityTypeLab.font = [UIFont systemFontOfSize:16.0f];
        _capacityTypeLab.textAlignment = NSTextAlignmentLeft;
        _capacityTypeLab.textColor = APP_COLOR_BLACK_TEXT;
    }
    return _capacityTypeLab;
}
-(UILabel *)linesLab
{
    if (!_linesLab) {
        _linesLab = [UILabel new];
        _linesLab.font = [UIFont systemFontOfSize:14.0f];
        _linesLab.textAlignment = NSTextAlignmentLeft;
        _linesLab.textColor = APP_COLOR_GRAY2;
    }
    return _linesLab;
}
-(UILabel *)goodsLab
{
    if (!_goodsLab) {
        _goodsLab = [UILabel new];
        _goodsLab.font = [UIFont systemFontOfSize:14.0f];
        _goodsLab.textAlignment = NSTextAlignmentLeft;
        _goodsLab.textColor = APP_COLOR_GRAY2;
    }
    return _goodsLab;
}
@end

@interface OrderCenterTabCell_Footer : BaseTableViewCell
@property (nonatomic, strong)UILabel * priceLab;
@end

@implementation OrderCenterTabCell_Footer

-(void)loadUIWithmodel:(OrderModel *)model
{
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"价格: ¥%@",[model.price NumberStringToMoneyString]]];
    //设置字体
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f]
                       range:NSMakeRange(0, 4)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f]
                       range:NSMakeRange(4,attrString.length - 7)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f]
                       range:NSMakeRange(attrString.length - 3, 3)];
    
    // 设置颜色
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:APP_COLOR_GRAY_TEXT_1
                       range:NSMakeRange(0, 3)];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:APP_COLOR_BLACK_TEXT
                       range:NSMakeRange(4, attrString.length - 4)];
    
    self.priceLab.attributedText = attrString;
}
-(void)bindView
{
    self.priceLab.frame = CGRectMake(15, 14, SCREEN_W - 30, 16);
    [self addSubview:self.priceLab];
}
-(UILabel *)priceLab
{
    if (!_priceLab) {
        _priceLab = [UILabel new];
        _priceLab.font = [UIFont systemFontOfSize:14.0f];
        _priceLab.textAlignment = NSTextAlignmentRight;
        _priceLab.textColor = APP_COLOR_GRAY2;
    }
    return _priceLab;
}
@end


@interface OrderCenterTabCell()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate>

@property (nonatomic, strong)UITableView * tbv;
@property (nonatomic,strong)OrderModel * model;

@end

@implementation OrderCenterTabCell
-(void)loadUIWithmodel:(id)model
{
    self.model = model;
    [self.tbv reloadData];
}
-(void)bindView
{
    self.tbv.frame = CGRectMake(0, 0, SCREEN_W, 210);
    [self addSubview:self.tbv];
}
-(UITableView *)tbv
{
    if (!_tbv) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.scrollEnabled = NO;
        tableView.backgroundColor = APP_COLOR_WHITE;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[OrderCenterTabCell_Header class] forCellReuseIdentifier:NSStringFromClass([OrderCenterTabCell_Header class])];
        [tableView registerClass:[OrderCenterTabCell_Center class] forCellReuseIdentifier:NSStringFromClass([OrderCenterTabCell_Center class])];
        [tableView registerClass:[OrderCenterTabCell_Footer class] forCellReuseIdentifier:NSStringFromClass([OrderCenterTabCell_Footer class])];
        _tbv = tableView;
    }
    return _tbv;
}
-(OrderModel *)model
{
    if (!_model) {
        _model = [OrderModel new];
    }
    return _model;
}
#pragma mark - Tabview Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseTableViewCell * cell;
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderCenterTabCell_Header class]) forIndexPath:indexPath];
            
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderCenterTabCell_Center class]) forIndexPath:indexPath];
            ((OrderCenterTabCell_Center *)cell).delegate = self;
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderCenterTabCell_Footer class]) forIndexPath:indexPath];
            
            break;
            
        default:
            break;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell loadUIWithmodel:self.model];
    return cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (indexPath.row) {
        case 0:
            height = 56;
            break;
        case 1:
            height = 112;
            break;
        case 2:
            height = 44;
            break;
        default:
            break;
    }
    return height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.cellDelegate getCellClick:self.cellIndexPath];
}
#pragma mark - MGSwipeTableCellDelegate
//决定是否可以使用划动手势。
- (BOOL)swipeTableCell:(MGSwipeTableCell*)cell canSwipe:(MGSwipeDirection)direction
{
//    if (direction == MGSwipeDirectionLeftToRight) {
//        return NO;
//    }
//    else if (direction == MGSwipeDirectionRightToLeft)
//    {
//        return YES;
//    }

    return NO;
}
//当前swipe state状态改变时使用。
- (void)swipeTableCell:(MGSwipeTableCell*)cell
   didChangeSwipeState:(MGSwipeState)state
       gestureIsActive:(BOOL) gestureIsActive
{
    if ([cell isKindOfClass:[OrderCenterTabCell_Center class]]) {
        OrderCenterTabCell_Center * orderCell = (OrderCenterTabCell_Center*)cell;
        orderCell.imageVe.hidden = !orderCell.imageVe.hidden;
        orderCell.capacityTypeLab.hidden = !orderCell.capacityTypeLab.hidden;
        orderCell.linesLab.hidden = !orderCell.linesLab.hidden;
        orderCell.goodsLab.hidden = !orderCell.goodsLab.hidden;
    }
}
//用户点击按钮时回调。
- (BOOL)swipeTableCell:(MGSwipeTableCell*)cell
   tappedButtonAtIndex:(NSInteger)index
             direction:(MGSwipeDirection)direction
         fromExpansion:(BOOL) fromExpansion
{
    return YES;
}
//设置swipe button 和 swipe/expansion 的设置。
- (NSArray*)swipeTableCell:(MGSwipeTableCell*)cell
  swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*)swipeSettings
         expansionSettings:(MGSwipeExpansionSettings*)expansionSettings
{
    WS(ws);
    if(self.beenPlacedAtTheTop)
    {
        return @[[MGSwipeButton buttonWithTitle:@"取消置顶"
                            backgroundColor:APP_COLOR_GRAY1
                                   callback:^BOOL(MGSwipeTableCell *sender){
                                       [ws.cellDelegate getTheTopCancelButtonClickWithCellIndexPath:ws.cellIndexPath];
                                       return YES;
                                   }]
             ];
    }
    else
    {
        return @[[MGSwipeButton buttonWithTitle:@"置顶"
                                backgroundColor:APP_COLOR_BLUE_BTN
                                       callback:^BOOL(MGSwipeTableCell *sender){
                                           [ws.cellDelegate getTheTopButtonClickWithCellIndexPath:ws.cellIndexPath];
                                           return YES;
                                       }]
                 ];
    }
}
@end
