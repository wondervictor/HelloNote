//
//  NoteManager.h
//  HelloNote
//
//  Created by VicChan on 3/31/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
#import "Note.h"
#import "CoreDataManager.h"
#import "UserInfo.h"

@class NoteBook;

typedef void (^CompletionHandler) (BOOL finished,NSString *error);


@protocol NoteManagerDelegate <NSObject>

@optional
- (void)getAllNotes:(NSArray *)notes;
- (void)getNoteOfaBook:(NSArray *)notes;
- (void)getNoteBookList:(NSArray *)books;
- (void)finishSyncingNoteWithCompletitonHandler:(CompletionHandler)block;


- (void)syncWithError:(NSString *)error;


@end

static NSString *className;

@interface NoteManager : NSObject

@property (nonatomic, weak) id <NoteManagerDelegate> delegate;
@property (nonatomic, weak) UserInfo *userInfo;

@property (nonatomic, strong) CoreDataManager *coreDataManager;

/* 单例 */

+ (NoteManager *)sharedManager;
/* 获取所有笔记 － Bmob */
- (void)getAllNote;
/* 创建新笔记 － Bmob */
- (void)createNewNote:(Note *)note;
/* 删除一条笔记 － Bmob */
- (void)deleteNote:(Note *)note;
/* 设置Bmob class 名 */
- (void)setClassName:(NSString *)name;
/* 获取某一本笔记本的笔记 */
- (NSArray *)getNoteOfBook:(NSString *)bookName;
/* 获取当前用户的信息 */
- (void)getCurrentUserInfo:(UserInfo *)user;
/* 修改一篇笔记 */
- (void)modifyNote:(Note *)note;
/* 把BmobObject变为Note类型 */
- (Note *)getNoteFromBmobObject:(BmobObject *)object;
/* 获取所有笔记本名 */
- (void)getBookList;
// 搜索内部实现
/* 远程同步to remote */
- (void)syncNoteToRemote;
/*  远程同步to home */
- (void)syncNoteToHome;

/*简化cell工作*/
- (BOOL)setDataForCellWithNote:(NoteBook *)note Handler:(void (^)(NSString *title,NSString *content,NSString *date))block;

- (void)deleteAllNotes;

/*  */
- (NSArray *)getTitlesFromNoteArray:(NSArray *)array;
/* */
- (NSArray *)returnBackWithArray:(NSArray *)array baseArray:(NSArray *)baseArray;


@end
