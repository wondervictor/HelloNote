//
//  UserInfo.m
//  HelloNote
//
//  Created by VicChan on 4/2/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import "UserInfo.h"
#import <BmobSDK/Bmob.h>


@implementation UserInfo

+ (UserInfo *)sharedManager {
    static UserInfo *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc]init];
    });
    return sharedManager;
}


- (void)setInfoWithName:(NSString *)name password:(NSString *)pwd {
    self.userPwd = pwd;
    self.userName = name;
}

- (void)checkSameUser:(NSString *)userName {
    BmobQuery *query = [[BmobQuery alloc]initWithClassName:@"USER"];
    [query whereKey:@"username" equalTo:userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if ([array count] == 0) {
            [_delegate checkSameUserResult:NO];
        }
        else if ([array count] > 0) {
            [_delegate checkSameUserResult:YES];
        }
    }];
}


- (NSString *)getUserName {
    return self.userName != nil ? self.userName : @"Hello World";
}

- (BOOL)checkAvailable {
    BmobQuery *query = [[BmobQuery alloc]initWithClassName:@"USER"];
    [query whereKey:@"username" equalTo:self.userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if ([array count]==0) {
            [_delegate checkInfo:NO withErrorInfo:@"该用户未注册"];
        }
        else if ([array count]!=0) {
            BmobObject *objct = [array lastObject];
            NSString *password = [objct objectForKey:@"password"];
            if (![self.userPwd isEqualToString:password]) {
                [_delegate checkInfo:NO withErrorInfo:@"用户名或者密码错误"];
            }
            
            else {
                [_delegate checkInfo:YES withErrorInfo:nil];
            }
        }
        
    }];
    return YES;
}

- (void)createNewWithName:(NSString *)name password:(NSString *)pwd {
    self.userName = name;
    self.userPwd = pwd;
    self.className = [self getClassName];
    self.bookList = @[@"默认笔记本"];
    BmobObject *object = [BmobObject objectWithClassName:@"USER"];
    [object setObject:self.userName forKey:@"username"];
    [object setObject:self.userPwd forKey:@"password"];
    [object setObject:self.className forKey:@"classname"];
    [object setObject:self.bookList forKey:@"booklist"];
    [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful == YES) {
            NSLog(@"success");
        }
    }];
}


- (void)addNewBookWithName:(NSString *)bookName {
    BmobQuery *query = [[BmobQuery alloc]initWithClassName:@"USER"];
    [query whereKey:@"username" equalTo:self.userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BmobObject *objct = [array lastObject];
        NSMutableArray *list = [objct objectForKey:@"booklist"];
        if ([list containsObject:bookName] == NO && bookName != nil) {
            [list addObject:bookName];
            [objct setObject:list forKey:@"booklist"];
            [objct updateInBackground];
       }
    
    }];
}

- (NSString *)getClassName{
    NSLog(@"%@",self.userName);
    NSString *className = [NSString stringWithFormat:@"%@--note_class_name",self.userName];
    return className;
}

- (NSArray *)getBookList {
    return nil;
}

@end