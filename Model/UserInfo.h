//
//  UserInfo.h
//  HelloNote
//
//  Created by VicChan on 4/2/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CoreDataManager.h"

@protocol UserInfoDelegate <NSObject>

@optional
- (void)checkInfo:(BOOL)isCorrect withErrorInfo:(NSString *)string;
- (void)checkSameUserResult:(BOOL)isExist;


@end

@interface UserInfo : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userPwd;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSArray *bookList;

@property (nonatomic, strong) CoreDataManager *coreDataManager;


@property (nonatomic, weak) id<UserInfoDelegate> delegate;

+ (UserInfo *)sharedManager;
- (void)setInfoWithName:(NSString *)name password:(NSString *)pwd;
- (BOOL)checkAvailable;
- (void)createNewWithName:(NSString *)name password:(NSString *)pwd;
- (NSString *)getClassName;
- (void)checkSameUser:(NSString *)userName;
- (NSString *)getUserName;
- (NSArray *)getBookList;
- (void)addNewBookWithName:(NSString *)bookName;
- (void)updateUsers:(UserInfo *)user;
@end
