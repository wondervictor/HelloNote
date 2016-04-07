//
//  NavigationController.m
//  HelloNote
//
//  Created by VicChan on 3/31/16.
//  Copyright © 2016 VicChan. All rights reserved.
//


#define MAIN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define MAIN_HEIGHT  [UIScreen mainScreen].bounds.size.height

#import "NavigationController.h"
#import "UserInfo.h"


@interface NavigationController ()<MenuViewDelegate,UINavigationControllerDelegate>
{
    UISwipeGestureRecognizer *rightSwipeGesture;
    UISwipeGestureRecognizer *leftSwipeGesture;
    UITapGestureRecognizer *tapGesture;
}
@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (UIView *view_ in self.view.subviews) {
        if ([NSStringFromClass([view_ class])isEqualToString:@"UINavigationTransitionView"]) {
            self.transitionView = view_;
        }
    }
    
    self.delegate = self;
    self.transitionView.frame = [UIScreen mainScreen].bounds;
    self.transitionView.backgroundColor = [UIColor whiteColor];
    
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewController:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    
    rightSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureHandler:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.transitionView addGestureRecognizer:rightSwipeGesture];
    leftSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureHandler:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.transitionView addGestureRecognizer:rightSwipeGesture];
    
    UserInfo *userInfo = [UserInfo sharedManager];
    NSString *userName = [userInfo getUserName];
    NSLog(@"%@",userName);
    UIColor *defaultColor = [UIColor colorWithRed:224/255.0 green:238/255.0 blue:238/255.0 alpha:0.9];
    self.menu = [[Menu alloc]initWithTitleArray:@[@"个人信息",@"设置",@"分享",@"搜索"]
                                          image:@[@"profile_1",@"setting",@"posts",@"discover"] mainTitle:userName withWidth:200 backgroundColor:defaultColor];
    self.menu.delegate = self;
    [self.view insertSubview:self.menu atIndex:0];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(menuDidTouched:) name:@"MenuDidTouchedNotification" object:nil];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)menuDidTouched:(NSNotification *)notification {
    [self tapViewController:nil];
}

- (void)tapViewController:(UITapGestureRecognizer *)recognizer {
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transitionView.frame = CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT);
        self.navigationBar.frame = CGRectMake(0, 20, MAIN_WIDTH, 44);

    } completion:nil];
}

- (void)swipeGestureHandler:(UISwipeGestureRecognizer *)recognizer {
    [self.view addGestureRecognizer:leftSwipeGesture];
    [self.transitionView addGestureRecognizer:tapGesture];
    float x = self.transitionView.frame.origin.x;
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft && x>0 ) {
        x = 0;
        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.transitionView.frame = CGRectMake(x, 0, MAIN_WIDTH, MAIN_HEIGHT);
            self.navigationBar.frame = CGRectMake(x, 20, MAIN_WIDTH, 44);
        } completion:nil];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight && x == 0) {
        x = 200;
        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.transitionView.frame = CGRectMake(x, 0, MAIN_WIDTH, MAIN_HEIGHT);
            self.navigationBar.frame = CGRectMake(x, 20, MAIN_WIDTH, 44);

        } completion:nil];
    }
}

- (void)titleTouched:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"TitleTouchedNotification" object:nil];
}

- (void)menuView:(Menu *)view touchAtIndex:(NSInteger)index {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MenuViewTouchedNotification" object:[NSNumber numberWithInteger:index]];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController.title isEqualToString:@"笔记"]) {
        rightSwipeGesture.enabled = YES;
    }
    else {
        rightSwipeGesture.enabled = NO;
    }
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