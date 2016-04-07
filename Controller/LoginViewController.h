//
//  LoginViewController.h
//  aNote
//
//  Created by VicChan on 3/29/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewControllerDelegate <NSObject>

- (void)finishLogin;

@end

@interface LoginViewController : UIViewController

@property (nonatomic, strong) UITextField *nameText;
@property (nonatomic, strong) UITextField *pwdText;
@property (nonatomic, weak) id <LoginViewControllerDelegate> delegate;


@end
