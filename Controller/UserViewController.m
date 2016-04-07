//
//  UserViewController.m
//  HelloNote
//
//  Created by VicChan on 4/2/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import "LoginViewController.h"
#import "UserViewController.h"

#define  MAIN_WIDTH     self.view.frame.size.width
#define  MAIN_HEIGHT    self.view.frame.size.height


#define DEFAULT_COLOR   [UIColor colorWithRed:50/255.0 green:205/255.0 blue:50/255.0 alpha:0.98]


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
    nameTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:30];
    [self.view addSubview:nameTitle];
    
    
    UIButton *logoutButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150, 50)];
    logoutButton.center = CGPointMake(MAIN_WIDTH/2.0, MAIN_HEIGHT/2.0 + 100);
    logoutButton.backgroundColor = [UIColor redColor];
    logoutButton.layer.cornerRadius = 20;
    
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutButton setTitle:@"退出" forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutButton];
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (void)logOut {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@"" forKey:@"username"];
    [userDefault setObject:@"" forKey:@"pwd"];
    [userDefault setObject:nil forKey:@"booklist"];
    LoginViewController *loginViewController = [[LoginViewController alloc]init] ;
    [self showViewController:loginViewController sender:nil];
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
