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
#import "UserInfo.h"

@protocol NoteManagerDelegate <NSObject>

@optional
- (void)getAllNotes:(NSArray *)notes;
- (void)getNoteOfABook:(NSArray *)notes;
- (void)getNoteBookList:(NSArray *)books;


@end

static NSString *className;

@interface NoteManager : NSObject

@property (nonatomic, weak) id <NoteManagerDelegate> delegate;
@property (nonatomic, weak) UserInfo *userInfo;


+ (NoteManager *)sharedManager;
- (void)getAllNote;
- (void)createNewNote:(Note *)note;
- (void)deleteNote:(Note *)note;
- (void)setClassName:(NSString *)name;
- (void)getNoteOfBook:(NSString *)bookName;
- (void)getCurrentUserInfo:(UserInfo *)user;
- (void)modifyNote:(Note *)note;
- (Note *)getNoteFromBmobObject:(BmobObject *)object;
- (void)getBookList;
- (NSArray *)getTitlesFromNoteArray:(NSArray *)array;
- (NSArray *)returnBackWithArray:(NSArray *)array baseArray:(NSArray *)baseArray;


@end
