//
//  UserViewController.m
//  HelloNote
//
//  Created by VicChan on 4/2/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import "LoginViewController.h"
#import "UserViewController.h"

#define  MAIN_WIDTH     (self.view.frame.size.width)
#define  MAIN_HEIGHT    (self.view.frame.size.height)


#define DEFAULT_COLOR   [UIColor colorWithRed:50/255.0 green:205/255.0 blue:50/255.0 alpha:0.98]

NSString *const UserDidChangedNotification = @"UserDidChangedNotification";



@interface UserViewController ()

@end


@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"个人信息";
    self.view.backgroundColor = DEFAULT_COLOR;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"username"];
    
    UILabel *nameTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
    nameTitle.textAlignment = NSTextAlignmentCenter;
    nameTitle.center = CGPointMake(MAIN_WIDTH/2.0, MAIN_HEIGHT/2.0-100);
    nameTitle.backgroundColor = [UIColor clearColor];
    nameTitle.text = name;
    nameTitle.tag = 1001;
    nameTitle.textColor = [UIColor whiteColor];
    nameTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:30];
    [self.view addSubview:nameTitle];
    
    
    UIButton *logoutButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
    logoutButton.center = CGPointMake(MAIN_WIDTH/2.0, MAIN_HEIGHT/2.0 + 200);
    logoutButton.backgroundColor = [UIColor whiteColor];
    logoutButton.layer.cornerRadius = 20;
    
    [logoutButton setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
    [logoutButton setTitle:@"退出" forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutButton];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTitle) name:UserDidChangedNotification object:nil];
    
    
    
    // Do any additional setup after loading the view.
}


- (void)changeTitle {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"username"];
    UILabel *label = [self.view viewWithTag:1001];
    
    label.text = name;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (void)logOut {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];

    LoginViewController *loginViewController = [[LoginViewController alloc]init] ;
    [self presentViewController:loginViewController animated:YES completion:^{
        [userDefault setObject:@"" forKey:@"booklist"];
        
    }];
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
