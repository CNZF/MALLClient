//
//  IdeaFeedbackVC.m
//  MallClient
//
//  Created by lxy on 2017/3/13.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "IdeaFeedbackVC.h"
#import "UserViewModel.h"

@interface IdeaFeedbackVC ()<UITextViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView  *textViewIdea;
@property (weak, nonatomic) IBOutlet UILabel     *lbPlaceholder;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UIButton    *btnSubmit;
@property (weak, nonatomic) IBOutlet UILabel     *lbServicePhone;

@end

@implementation IdeaFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)bindView {

    self.title = @"意见反馈";
    self.view.backgroundColor = [HelperUtil colorWithHexString:@"f8f8f8"];

    self.btnSubmit.layer.masksToBounds = YES;
    self.btnSubmit.layer.cornerRadius = 5;

    self.textViewIdea.delegate = self;

    self.lbServicePhone.text = APP_CUSTOMER_SERVICE_NO_;

}

//打电话
- (IBAction)callActionForService:(id)sender {

    [self callAction];
}

//提交
- (IBAction)submitAction:(id)sender {

    NSString *searchText = self.tfPhone.text;
    NSError *error = NULL;

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"1\\d{10}$" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];

    if([self.textViewIdea.text isEqualToString:@""]){

        [[Toast shareToast]makeText:@"意见不能为空" aDuration:1];
    }else if ([self.tfPhone.text isEqualToString:@""]){

        [[Toast shareToast]makeText:@"电话号码不能为空" aDuration:1];

    }else if (!result) {

        [[Toast shareToast]makeText:@"手机号码错误" aDuration:1];

    }else{


        if(self.textViewIdea.text.length >95){

            [[Toast shareToast]makeText:@"超出字数限制" aDuration:1];
        }else{

            UserViewModel *vm = [UserViewModel new];
            [vm submitIdeaWithIdeaText:self.textViewIdea.text WithPhone:self.tfPhone.text callback:^(NSString *st) {

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提交成功" message:@"感谢您的意见与建议" delegate:self cancelButtonTitle:nil otherButtonTitles:@"关闭", nil];
                alert.tag = 11;
                [alert show];
                
            }];

        }



    }
}


/**
 *  UITextViewDelegate
 */

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {

    self.lbPlaceholder.hidden = YES;

    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {

    if ([textView.text isEqualToString:@""]) {

        self.lbPlaceholder.hidden = NO;
    }

    return YES;
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//
//    if (alertView.tag == 11) {
//
//        [self.navigationController popViewControllerAnimated:YES];
//    }else {
//
//        if (buttonIndex == 1) {
//
//            UIWebView * callWebview = [[UIWebView alloc]init];
//
//            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.stTelephone]]]];
//
//            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
//            
//        }
//    }
//
//
//}


@end
