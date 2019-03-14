//
//  UserInfoVC.m
//  MallClient
//
//  Created by iOS_Developers_LL on 07/02/2017.
//  Copyright © 2017 com.zhongche.cn. All rights reserved.
//

#import "UserInfoVC.h"
#import "UserInfoCell.h"
#import "UserInfoVCHaveNotCell.h"
#import "UserInfoTitleCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UserViewModel.h"
#import "PersonalAuthenticationVC.h"
#import "EnterpriseNameAuthenticationVC.h"
#import "EnterpriseValueAuthenticationVC.h"
#import "ChangePassWordVC.h"
#import "ValidationPasswordVC.h"

#import "EnterpriseNameAuthenticationManagerVC.h"



@interface UserInfoVC ()<UITableViewDelegate,UITableViewDataSource,UserInfoVCHaveNotCellDeleGate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController * imagePickerController;//相机,相册

@property (nonatomic, strong) UITableView             * tbv;

@end

@implementation UserInfoVC

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"needUpdataUserData" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的账号";
    self.btnRight.hidden = YES;
    self.userInfo = USER_INFO;
    [self addHeadPortrait];
    [self addAccount];
    [self addManagers];
    [self addEnterpriseInformation];
    [self addEnterpriseQualification];
    [self addQuit];
    [self.tbv reloadData];
    self.view.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
    //注册监听数据更新需求
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataUserData) name:@"needUpdataUserData" object:nil];
    
}

- (void)bindView {
    
    self.tbv.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64);
    [self.view addSubview:self.tbv];
}

- (void)bindModel {
    [self updataUserData];
}

//更新用户数据
-(void)updataUserData {
    
//    WS(ws);
//    UserViewModel *vm = [UserViewModel new];
//    [vm getUserInfoWithUserId:^(UserInfoModel *userInfo) {
//        ws.userInfo = userInfo;
//        [ws.dataArray removeAllObjects];
//        [self addHeadPortrait];
//        [self addAccount];
//        [self addManagers];
//        [self addEnterpriseInformation];
//        [self addEnterpriseQualification];
//        [self addQuit];
//        [ws.tbv reloadData];
//    }];
}

//添加用户头像
-(void)addHeadPortrait {
    UserInfoCellModel * model;
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",BASEIMGURL,self.userInfo.icon]);
    model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoTitleCell class])
                                        withCellHeight:8
                                     withAccessoryType:UITableViewCellAccessoryNone
                                          withTitleStr:nil
                                            withImgStr:nil
                                        withDetailsStr:nil
                                    withCellLineHidden:NO];
    [self.dataArray addObject:model];
    model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoCell class])
                                        withCellHeight:70
                                     withAccessoryType:UITableViewCellAccessoryDisclosureIndicator
                                          withTitleStr:@"头像"
                                            withImgStr:[NSString stringWithFormat:@"%@%@",BASEIMGURL,self.userInfo.icon]
                                        withDetailsStr:nil
                                    withCellLineHidden:YES];
    [self.dataArray addObject:model];
}

//添加账户
-(void)addAccount {
    UserInfoCellModel * model;
    model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoTitleCell class])
                                        withCellHeight:36
                                     withAccessoryType:UITableViewCellAccessoryNone
                                          withTitleStr:@"账号信息"
                                            withImgStr:nil
                                        withDetailsStr:nil
                                    withCellLineHidden:NO];
    [self.dataArray addObject:model];
    model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoCell class])
                                        withCellHeight:44
                                     withAccessoryType:UITableViewCellAccessoryNone
                                          withTitleStr:@"账号"
                                            withImgStr:nil
                                        withDetailsStr:self.userInfo.loginName
                                    withCellLineHidden:NO];
    [self.dataArray addObject:model];
    model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoCell class])
                                        withCellHeight:44
                                     withAccessoryType:UITableViewCellAccessoryDisclosureIndicator
                                          withTitleStr:@"登录密码"
                                            withImgStr:nil
                                        withDetailsStr:@""
                                    withCellLineHidden:YES];
    [self.dataArray addObject:model];
}

//用户认证
-(void)addManagers {
    UserInfoCellModel * model;
    if(self.userInfo.email)//账号管理者信息存在
    {
        model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoTitleCell class])
                                            withCellHeight:36
                                         withAccessoryType:UITableViewCellAccessoryNone
                                              withTitleStr:@"账号管理者"
                                                withImgStr:nil
                                            withDetailsStr:@"已完善"
                                        withCellLineHidden:NO];
        model.btnHidden = NO;
        [self.dataArray addObject:model];
        model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoCell class])
                                            withCellHeight:44
                                         withAccessoryType:UITableViewCellAccessoryNone
                                              withTitleStr:@"姓名"
                                                withImgStr:nil
                                            withDetailsStr:self.userInfo.userName
                                        withCellLineHidden:NO];
        [self.dataArray addObject:model];
        model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoCell class])
                                            withCellHeight:44
                                         withAccessoryType:UITableViewCellAccessoryNone
                                              withTitleStr:@"电话"
                                                withImgStr:nil
                                            withDetailsStr:self.userInfo.phone
                                        withCellLineHidden:NO];
        [self.dataArray addObject:model];
        model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoCell class])
                                            withCellHeight:44
                                         withAccessoryType:UITableViewCellAccessoryNone
                                              withTitleStr:@"邮箱"
                                                withImgStr:nil
                                            withDetailsStr:self.userInfo.email
                                        withCellLineHidden:YES];
        [self.dataArray addObject:model];
    }
    else
    {
        model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoTitleCell class])
                                            withCellHeight:12
                                         withAccessoryType:UITableViewCellAccessoryNone
                                              withTitleStr:nil
                                                withImgStr:nil
                                            withDetailsStr:nil
                                        withCellLineHidden:NO];
        [self.dataArray addObject:model];
        model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoVCHaveNotCell class])
                                            withCellHeight:50
                                         withAccessoryType:UITableViewCellAccessoryNone
                                              withTitleStr:@"账号管理者"
                                                withImgStr:nil
                                            withDetailsStr:@"待完善-去完善"
                                        withCellLineHidden:YES];
        [self.dataArray addObject:model];
    }
}

//公司实名认证
-(void)addEnterpriseInformation {
    UserInfoCellModel * model;
    if (([self.userInfo.authStatus isEqualToString:@"0"]||[self.userInfo.authStatus isEqualToString:@"3"]))
    {


        NSString * detilStr = @"";
        if ([self.userInfo.authStatus isEqualToString:@"0"]) {
            detilStr = @"未认证-前往认证";
        }
        else if ([self.userInfo.authStatus isEqualToString:@"3"])
        {
            detilStr = [NSString stringWithFormat:@"%@-前往认证",self.userInfo.authStatusDesc];
        }
        model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoTitleCell class])
                                            withCellHeight:12
                                         withAccessoryType:UITableViewCellAccessoryNone
                                              withTitleStr:nil
                                                withImgStr:nil
                                            withDetailsStr:nil
                                        withCellLineHidden:NO];
        [self.dataArray addObject:model];
        model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoVCHaveNotCell class])
                                            withCellHeight:50
                                         withAccessoryType:UITableViewCellAccessoryNone
                                              withTitleStr:@"企业信息"
                                                withImgStr:nil
                                            withDetailsStr:detilStr
                                        withCellLineHidden:YES];
        [self.dataArray addObject:model];
    }
    else
    {



        //====
        model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoTitleCell class])
                                            withCellHeight:36
                                         withAccessoryType:UITableViewCellAccessoryNone
                                              withTitleStr:@"企业信息"
                                                withImgStr:nil
                                            withDetailsStr:self.userInfo.authStatusDesc
                                        withCellLineHidden:YES];
        [self.dataArray addObject:model];
        model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoCell class])
                                            withCellHeight:44
                                         withAccessoryType:UITableViewCellAccessoryNone
                                              withTitleStr:@"企业全称"
                                                withImgStr:nil
                                            withDetailsStr:self.userInfo.companyName
                                        withCellLineHidden:NO];
        [self.dataArray addObject:model];
        model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoCell class])
                                            withCellHeight:44
                                         withAccessoryType:UITableViewCellAccessoryNone
                                              withTitleStr:@"营业执照注册号"
                                                withImgStr:nil
                                            withDetailsStr:self.userInfo.businessLicenseCode
                                        withCellLineHidden:NO];
        [self.dataArray addObject:model];
        model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoCell class])
                                            withCellHeight:44
                                         withAccessoryType:UITableViewCellAccessoryNone
                                              withTitleStr:@"组织机构代码"
                                                withImgStr:nil
                                            withDetailsStr:self.userInfo.organizationCodeCode
                                        withCellLineHidden:NO];
        [self.dataArray addObject:model];
        model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoCell class])
                                            withCellHeight:44
                                         withAccessoryType:UITableViewCellAccessoryNone
                                              withTitleStr:@"税务登记证"
                                                withImgStr:nil
                                            withDetailsStr:self.userInfo.taxCertificateCode
                                        withCellLineHidden:YES];
        [self.dataArray addObject:model];
    }
}

//公司资质认证
-(void)addEnterpriseQualification {
    UserInfoCellModel * model;
    if ([self.userInfo.quaAuthStatus isEqualToString:@"0"]||[self.userInfo.quaAuthStatus isEqualToString:@"3"])
    {


        NSString * detilStr = @"";
        if ([self.userInfo.quaAuthStatus isEqualToString:@"0"]) {
            detilStr = @"未认证-前往认证";
        }
        else if ([self.userInfo.quaAuthStatus isEqualToString:@"3"]){
            detilStr = [NSString stringWithFormat:@"%@-前往认证",self.userInfo.quaAuthStatusDesc];
        }
        model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoTitleCell class])
                                            withCellHeight:12
                                         withAccessoryType:UITableViewCellAccessoryNone
                                              withTitleStr:nil
                                                withImgStr:nil
                                            withDetailsStr:nil
                                        withCellLineHidden:NO];
        [self.dataArray addObject:model];
        model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoVCHaveNotCell class])
                                            withCellHeight:50
                                         withAccessoryType:UITableViewCellAccessoryNone
                                              withTitleStr:@"企业资质"
                                                withImgStr:nil
                                            withDetailsStr:detilStr
                                        withCellLineHidden:YES];
        [self.dataArray addObject:model];

    }
    else
    {

        model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoTitleCell class])
                                            withCellHeight:36
                                         withAccessoryType:UITableViewCellAccessoryNone
                                              withTitleStr:@"企业资质"
                                                withImgStr:nil
                                            withDetailsStr:self.userInfo.quaAuthStatusDesc
                                        withCellLineHidden:YES];
        [self.dataArray addObject:model];
        model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoCell class])
                                            withCellHeight:44
                                         withAccessoryType:UITableViewCellAccessoryNone
                                              withTitleStr:@"道路运输经营许可证"
                                                withImgStr:nil
                                            withDetailsStr:self.userInfo.certificateCode
                                        withCellLineHidden:YES];
        [self.dataArray addObject:model];


    }
}

//退出登录
-(void)addQuit {
    UserInfoCellModel * model;
    model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoTitleCell class])
                                        withCellHeight:15
                                     withAccessoryType:UITableViewCellAccessoryNone
                                          withTitleStr:nil
                                            withImgStr:nil
                                        withDetailsStr:nil
                                    withCellLineHidden:NO];
    [self.dataArray addObject:model];
    model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UITableViewCell class])
                                        withCellHeight:44
                                     withAccessoryType:UITableViewCellAccessoryNone
                                          withTitleStr:@"退出登录"
                                            withImgStr:nil
                                        withDetailsStr:nil
                                    withCellLineHidden:NO];
    [self.dataArray addObject:model];
    model = [[UserInfoCellModel alloc]initWithClassStr:NSStringFromClass([UserInfoTitleCell class])
                                        withCellHeight:15
                                     withAccessoryType:UITableViewCellAccessoryNone
                                          withTitleStr:nil
                                            withImgStr:nil
                                        withDetailsStr:nil
                                    withCellLineHidden:NO];
    [self.dataArray addObject:model];
}

/**
 *  懒加载
 *
 */
- (UITableView *)tbv {
    if (!_tbv) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = APP_COLOR_WHITEBG;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[UserInfoCell class] forCellReuseIdentifier:NSStringFromClass([UserInfoCell class])];
        [tableView registerClass:[UserInfoVCHaveNotCell class] forCellReuseIdentifier:NSStringFromClass([UserInfoVCHaveNotCell class])];
        [tableView registerClass:[UserInfoTitleCell class] forCellReuseIdentifier:NSStringFromClass([UserInfoTitleCell class])];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];

        _tbv = tableView;
    }
    return _tbv;
}

-(UIImagePickerController *)imagePickerController {
    if (!_imagePickerController)
    {
        UIImagePickerController * imgC = [[UIImagePickerController alloc] init];
        imgC.delegate = self;
        imgC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imgC.allowsEditing = NO;
        _imagePickerController = imgC;
    }
    return _imagePickerController;
}

#pragma mark -从摄像头获取图片或视频
- (void)selectImageFromCamera {
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    self.imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    
    self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark -从相册获取图片或视频
- (void)selectImageFromAlbum {
    //NSLog(@"相册");
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark - Tabview Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserInfoCellModel * model = self.dataArray[indexPath.row];
    BaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:model.classStr forIndexPath:indexPath];
    if ([model.classStr isEqualToString:NSStringFromClass([UITableViewCell class])]) {
        cell.textLabel.text = model.titleStr;
        cell.textLabel.textColor = APP_COLOR_RED1;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        if([model.classStr isEqualToString:NSStringFromClass([UserInfoVCHaveNotCell class])])
        {
            ((UserInfoVCHaveNotCell*)cell).cellIndexPath = indexPath;
            ((UserInfoVCHaveNotCell*)cell).cellDelegate = self;
        }
        if ([model.classStr isEqualToString:NSStringFromClass([UserInfoTitleCell class])] && (model.btnHidden ==  NO)) {
            [((UserInfoTitleCell*)cell).modifyBtn addTarget:self action:@selector(modifyBtnAction) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.accessoryType = model.accessoryType;
        [cell loadUIWithmodel:model];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataArray[indexPath.row] cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserInfoCellModel * model = self.dataArray[indexPath.row];
    if ([model.titleStr isEqualToString:@"头像"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [actionSheet showInView:self.view];
    }
    else if ([model.titleStr isEqualToString:@"登录密码"]) {
        [self.navigationController pushViewController:[ChangePassWordVC new] animated:YES];
        
    }
    else if ([model.titleStr isEqualToString:@"退出登录"]) {
        UserInfoModel *us = nil;
        [NSKeyedArchiver archiveRootObject:us toFile:[MyFilePlist documentFilePathStr:@"UserInfo.archive"]];
        [[Toast shareToast]makeText:@"注销成功" aDuration:1];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)cellButtonDidSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserInfoCellModel * model = self.dataArray[indexPath.row];
    if ([model.titleStr isEqualToString:@"账号管理者"]){
        PersonalAuthenticationVC *vc = [PersonalAuthenticationVC new];


        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([model.titleStr isEqualToString:@"企业信息"]){

        if(self.userInfo.email)//账号管理者信息存在
        {

            EnterpriseNameAuthenticationManagerVC *vc = [EnterpriseNameAuthenticationManagerVC new];
            vc.status = 1;
            [self.navigationController pushViewController:vc animated:YES];

        }else{

            [[Toast shareToast]makeText:@"请先进行实名认证" aDuration:1];

        }

    }
    else if ([model.titleStr isEqualToString:@"企业资质"]) {

        if ([self.userInfo.authStatus isEqualToString:@"1"]||[self.userInfo.authStatus isEqualToString:@"2"])
        {

            EnterpriseValueAuthenticationVC *vc = [EnterpriseValueAuthenticationVC new];
            vc.status = 1;
            [self.navigationController pushViewController:vc animated:YES];

        }else{

            [[Toast shareToast]makeText:@"请先通过企业实名认证" aDuration:1];
            
        }

    }
}

-(void)modifyBtnAction {
    
    [self.navigationController pushViewController:[ValidationPasswordVC new] animated:YES];
    
}

#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //按照按钮的顺序0-N；
    switch (buttonIndex) {
        case 0:
            [self selectImageFromCamera];
            break;
            
        case 1:
            [self selectImageFromAlbum];
            break;
            
        default:
            break;
    }
}

#pragma mark -UIImagePickerControllerDelegate
//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
//        info[UIImagePickerControllerOriginalImage];//获得图片并处理

        UIImage *img = info[UIImagePickerControllerOriginalImage];

        UserViewModel *vm = [UserViewModel new];

        WS(ws);
        [vm submitUserAvatarwithId:[self.userInfo.iden intValue] withAvatar:img callback:^(NSString *st) {

            ws.userInfo.icon = st;
            for ( UserInfoCellModel * model in ws.dataArray) {
                if ([model.titleStr isEqualToString:@"头像"]) {
                    model.imgStr = [NSString stringWithFormat:@"%@%@",BASEIMGURL,st];
                    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",BASEIMGURL,st]);
                    [ws.tbv reloadData];
                    break;
                }
            }

        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
