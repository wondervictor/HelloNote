//
//  SignView.m
//  aNote
//
//  Created by VicChan on 3/29/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#define VIEW_WIDTH   self.frame.size.width
#define VIEW_HEIGHT  self.frame.size.height

#import "SignView.h"

@interface SignView()

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *pwdField;
@property (nonatomic, strong) UITextField *pwdFieldAgain;
@property (nonatomic, strong) UITapGestureRecognizer *recognizer;
@end

@implementation SignView

- (id)initWithFrame:(CGRect)frame withCenter:(CGPoint)center toParentView:(UIView *)view{
    if (self = [super initWithFrame:frame]) {
        self.parentView = view;
        self.center = center;
        self.layer.cornerRadius = 20;
        self.recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shutKeyBoard:)];
        self.recognizer.numberOfTapsRequired = 1;
        self.recognizer.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:self.recognizer];
        self.backgroundColor = [UIColor whiteColor];
        [self configureViews];
        
    }
    return self;
}

- (void)configureViews {
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,10, VIEW_WIDTH-20, 20)];
    nameLabel.text = @"请输入用户名";
    nameLabel.tag = 1001;
    
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:nameLabel];
    
    self.nameField = [[UITextField alloc]initWithFrame:CGRectMake(10, 35, VIEW_WIDTH-20, 30)];
    self.nameField.backgroundColor = [UIColor whiteColor];
    self.nameField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameField.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.nameField];
    
    UILabel *pwdLabel_1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, VIEW_WIDTH-20, 20)];
    pwdLabel_1.text = @"输入密码";
    pwdLabel_1.font = [UIFont systemFontOfSize:15];

    pwdLabel_1.textAlignment = NSTextAlignmentCenter;
    pwdLabel_1.backgroundColor = [UIColor clearColor];
    [self addSubview:pwdLabel_1];
    
    self.pwdField = [[UITextField alloc]initWithFrame:CGRectMake(10, 95, VIEW_WIDTH-20, 30)];
    self.pwdField.backgroundColor = [UIColor whiteColor];
    self.pwdField.secureTextEntry = YES;
    self.pwdField.borderStyle = UITextBorderStyleRoundedRect;

    self.pwdField.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.pwdField];
    
    UILabel *pwdLabel_2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 130, VIEW_WIDTH-20, 20)];
    pwdLabel_2.text = @"再次输入密码";
    pwdLabel_2.font = [UIFont systemFontOfSize:15];

    pwdLabel_2.textAlignment = NSTextAlignmentCenter;
    pwdLabel_2.backgroundColor = [UIColor clearColor];
    [self addSubview:pwdLabel_2];
    self.pwdFieldAgain = [[UITextField alloc]initWithFrame:CGRectMake(10, 155, VIEW_WIDTH-20, 30)];
    self.pwdFieldAgain.backgroundColor = [UIColor whiteColor];
    self.pwdFieldAgain.secureTextEntry = YES;
    self.pwdFieldAgain.borderStyle = UITextBorderStyleRoundedRect;

    self.pwdFieldAgain.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.pwdFieldAgain];

    
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(30,210 , VIEW_WIDTH-60, 40)];
    confirmButton.layer.cornerRadius = 15;
    [confirmButton setTitle:@"注册" forState:UIControlStateNormal];
    confirmButton.backgroundColor = [UIColor orangeColor];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmButton];
    
}


- (void)shutKeyBoard:(UITapGestureRecognizer *)recognizer {
    [self.nameField resignFirstResponder];
    [self.pwdFieldAgain resignFirstResponder];
    [self.pwdField resignFirstResponder];
}
- (void)signup:(UIButton *)sender {
    
    [self shutKeyBoard:nil];
    UILabel *label = [self viewWithTag:1001];
    label.text = @"请输入用户名";
    label.textColor = [UIColor blackColor];

    NSString *name = self.nameField.text;
    NSString *pwd_1 = self.pwdField.text;
    NSString *pwd_2 = self.pwdFieldAgain.text;
    
    if ([pwd_1 isEqualToString:pwd_2]==NO) {
        label.text = @"两次密码不同，请重新输入";
        label.textColor = [UIColor redColor];
        return;
    }
    
    NSDictionary *dict = [[NSDictionary alloc]initWithObjects:@[name,pwd_1] forKeys:@[@"name",@"pwd"]];
    [_delegate finishSignUpWithData:dict];
}

- (void)viewAppear {
    [self.parentView addSubview:self];
}

- (void)viewDisappear {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
