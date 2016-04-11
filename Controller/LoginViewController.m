//
//  LoginViewController.m
//  aNote
//
//  Created by VicChan on 3/29/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import "LoginViewController.h"
#import "NavigationController.h"
#import "MainViewController.h"

#import "UserInfo.h"
#import "NoteManager.h"


#import "SignView.h"

#define  MAIN_WIDTH   (self.view.frame.size.width)
#define  MAIN_HEIGHT  (self.view.frame.size.height)

@interface LoginViewController ()<UITextFieldDelegate,SignViewDelegate,UserInfoDelegate>

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *signButton;
@property (nonatomic, strong) UITapGestureRecognizer *recognizer;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    [self configureViews];
    self.recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shutKeyBoard:)];
    self.recognizer.numberOfTapsRequired = 1;
    self.recognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:self.recognizer];
    // Do any additional setup after loading the view.
}


- (void)configureViews {
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH*0.8, 50)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.center = CGPointMake(MAIN_WIDTH/2.0,MAIN_HEIGHT/2.0 - 180);
    titleLabel.text = @"HELLO NOTE";
    titleLabel.font = [UIFont systemFontOfSize:40];
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH*0.8 + 10, 120)];
    backgroundView.layer.cornerRadius = 10;
    backgroundView.center = self.view.center;
    backgroundView.layer.masksToBounds = YES;
    self.nameText = [[UITextField alloc]initWithFrame:CGRectMake(5, 10, MAIN_WIDTH * 0.8, 50)];

    self.nameText.backgroundColor = [UIColor whiteColor];
    self.nameText.placeholder = @"账号";
    self.nameText.tintColor = [UIColor orangeColor];
    self.nameText.delegate = self;
    
    self.nameText.textAlignment = NSTextAlignmentCenter;
    self.pwdText = [[UITextField alloc]initWithFrame:CGRectMake(5, 60, MAIN_WIDTH * 0.8, 50)];
    self.pwdText.secureTextEntry = YES;
    self.pwdText.placeholder = @"密码";
    self.pwdText.tintColor = [UIColor orangeColor];
    self.pwdText.textAlignment = NSTextAlignmentCenter;
    self.pwdText.backgroundColor = [UIColor whiteColor];
    self.pwdText.delegate = self;
    
    backgroundView.backgroundColor = [UIColor whiteColor];
    [backgroundView addSubview:self.pwdText];
    [backgroundView addSubview:self.nameText];
    [self.view addSubview:backgroundView];
    
    
    self.confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH *0.8, 50)];
    self.confirmButton.center = CGPointMake(MAIN_WIDTH/2.0,MAIN_HEIGHT/2.0 + 100);
    [self.confirmButton setTitle:@"登录" forState:UIControlStateNormal];
    self.confirmButton.backgroundColor = [UIColor greenColor];
    self.confirmButton.layer.cornerRadius = 25;
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmButton];
    
    self.signButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    self.signButton.center = CGPointMake(MAIN_WIDTH/2.0,MAIN_HEIGHT/2.0 + 160);
    self.signButton.backgroundColor = [UIColor clearColor];
    [self.signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.signButton addTarget:self action:@selector(signupForNew:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.signButton];
    
}

- (void)signupForNew:(UIButton *)sender {
    sender.enabled = NO;
    SignView *signView = [[SignView alloc]initWithFrame:CGRectMake(0,0, MAIN_WIDTH*0.9, 260) withCenter:self.view.center toParentView:self.view];
    signView.delegate = self;
    [signView viewAppear];

}

- (void)finishSignUpWithData:(NSDictionary *)dictData {
    NSString *name = [dictData objectForKey:@"name"];
    NSString *pwd = [dictData objectForKey:@"pwd"];
    
    self.nameText.text = name;
    self.pwdText.text = pwd;
    
    [self login:nil];
    
}

- (void)login:(UIButton *)sender {
    [self shutKeyBoard:nil];
    [self checkUsers];
    //[UIApplication sharedApplication].keyWindow.rootViewController = nv;
}

- (void)shutKeyBoard:(UITapGestureRecognizer *)recognizer {
    [self.pwdText resignFirstResponder];
    [self.nameText resignFirstResponder];
    
}


- (void)checkUsers {
    NSString *userName = self.nameText.text;
    NSString *userPwd = self.pwdText.text;
    NSLog(@"%@",userPwd);
    UserInfo *userInfo = [UserInfo sharedManager];
    [userInfo setInfoWithName:userName password:userPwd];
    userInfo.delegate = self;
    [userInfo checkAvailable];
}

- (void)checkInfo:(BOOL)isCorrect withErrorInfo:(NSString *)string {
    UserInfo *userInfo = [UserInfo sharedManager];
    
    if (isCorrect) {
        NoteManager *manager = [NoteManager sharedManager];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [manager getCurrentUserInfo:userInfo];
        if ([userDefault objectForKey:@"username"] == nil) {
            [userDefault setObject:userInfo.userName forKey:@"username"];
            [userDefault setObject:userInfo.userPwd forKey:@"pwd"];
            [userDefault synchronize];
            MainViewController *mainViewController = [[MainViewController alloc]init];
            NavigationController *nv = [[NavigationController alloc]initWithRootViewController:mainViewController];
            [self showViewController:nv sender:nil];
        } else {
            [self dismissViewControllerAnimated:YES completion:^{
                [userDefault setObject:userInfo.userName forKey:@"username"];
                [userDefault setObject:userInfo.userPwd forKey:@"pwd"];
                [userDefault synchronize];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"UserDidChangedNotification" object:nil];

            }];
        }
        

        
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:string preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
