//
//  NoteManager.m
//  HelloNote
//
//  Created by VicChan on 3/31/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import "NoteManager.h"
 

@implementation NoteManager


- (void)setClassName:(NSString *)name {
    className = name;
}

+ (NoteManager *)sharedManager {
    static NoteManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc]init];
    });
    return sharedManager;
}

- (void)createNewNote:(Note *)note {
    BmobObject *noteObject = [[BmobObject alloc]initWithClassName:className];
    [noteObject setObject:note.noteTitle forKey:@"title"];
    [noteObject setObject:note.noteContent forKey:@"content"];
    [noteObject setObject:note.noteDate forKey:@"date"];
    [noteObject setObject:note.bookName forKey:@"notebook"];
    
    UserInfo *userInfo = [UserInfo sharedManager];
    [userInfo addNewBookWithName:note.bookName];
    [self getBookList];
    
    [noteObject saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        NSLog(@"success");
    }];
    
}

- (void)modifyNote:(Note *)note {
    BmobQuery *query = [[BmobQuery alloc]initWithClassName:className];
    [query whereKey:@"title" equalTo:note.noteTitle];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BmobObject *object = [array lastObject];
        [object deleteInBackground];
    }];
    
    [self createNewNote:note];
    
}

- (void)getAllNote {

    BmobQuery *query = [[BmobQuery alloc]initWithClassName:className];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        // error
        [_delegate getAllNotes:array];
    }];
    
}

- (void)deleteNote:(Note *)note {
    NSString *title = note.noteTitle;
    NSString *content = note.noteContent;
    BmobQuery *query = [[BmobQuery alloc]initWithClassName:className];
    [query whereKey:@"title" equalTo:title];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        // error
        for (BmobObject *object in array) {
            if ([[object objectForKey:@"title"]isEqualToString:title] && [[object objectForKey:@"content"]isEqualToString:content]) {
                [object deleteInBackground];
            }
        }
    }];
    
}


- (void)getBookList {
    BmobQuery *query = [[BmobQuery alloc]initWithClassName:@"USER"];
    [query whereKey:@"username" equalTo:[self.userInfo getUserName]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BmobObject *object = [array lastObject];
         NSArray *bookList = [object objectForKey:@"booklist"];
        [_delegate getNoteBookList:bookList];
    }];
}

- (void)getNoteOfBook:(NSString *)bookName {
    BmobQuery *query = [[BmobQuery alloc]initWithClassName:className];
    [query whereKey:@"notebook" equalTo:bookName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            [_delegate getNoteOfABook:array];
        }
    }];
}


- (void)getCurrentUserInfo:(UserInfo *)user {
    self.userInfo = user;
    className = [self.userInfo getClassName];//self.userInfo.className;
    NSLog(@"%@",className);
}


- (Note *)getNoteFromBmobObject:(BmobObject *)object {
    Note *note = [Note new];
    note.noteTitle = [object objectForKey:@"title"];
    note.noteContent = [object objectForKey:@"content"];
    note.noteDate = [object objectForKey:@"date"];
    note.bookName = [object objectForKey:@"notebook"];
    
    
    return note;
}

- (NSArray *)getTitlesFromNoteArray:(NSArray *)array {
    NSMutableArray *tempArray  = [NSMutableArray new];
    for (BmobObject *item in array) {
        NSString *title = [item objectForKey:@"title"];
        [tempArray addObject:title];
    }
    NSArray *titles = [[NSArray alloc]initWithArray:tempArray];
    return titles;
}


// 这里使用冒泡法真的好么

- (NSArray *)returnBackWithArray:(NSArray *)array baseArray:(NSArray *)baseArray{
    NSMutableArray *tempArray = [NSMutableArray new];
    for (BmobObject *item in baseArray) {
        for (NSString *title in array) {
            if ([title isEqualToString:[item objectForKey:@"title"]]) {
                [tempArray addObject:item];
            }
        }
    }
    NSArray *returnArray = [[NSArray alloc]initWithArray:tempArray];
    
    return returnArray;

}



@end
