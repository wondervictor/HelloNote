//
//  NoteManager.m
//  HelloNote
//
//  Created by VicChan on 3/31/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import "NoteManager.h"

#import "CoreDataManager.h"
#import "NoteBook.h"
#import "User.h"


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


- (CoreDataManager *)coreDataManager {
    if (_coreDataManager == nil) {
        _coreDataManager = [CoreDataManager new];
        [_coreDataManager setCoreData];
    }
    return _coreDataManager;
}



- (void)createNewNote:(Note *)note {
    UserInfo *useInfo = [UserInfo sharedManager];
    NoteBook *noteBook = [NSEntityDescription insertNewObjectForEntityForName:@"NoteBook" inManagedObjectContext:[self coreDataManager].context];
    noteBook.content = note.noteContent;
    noteBook.date = note.noteDate;
    noteBook.title = note.noteTitle;
    noteBook.bookname = note.bookName;
    noteBook.userclass = [useInfo getClassName];
    [[self coreDataManager]saveContext];
    
}


- (void)modifyNote:(Note *)note {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NoteBook"];
    NSArray *fetchObject = [[self coreDataManager].context executeFetchRequest:request error:nil];
    for (NoteBook *item in fetchObject) {

        if ([item.title isEqualToString:note.noteTitle] ) {
            [[self coreDataManager].context deleteObject:item];

            [self createNewNote:note];
            break;
        }
    }

}

- (void)getAllNote {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NoteBook"];
    NSArray *array = [[self coreDataManager].context executeFetchRequest:request error:nil];
    [_delegate getAllNotes:array];
}

- (void)deleteNote:(NoteBook *)note {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NoteBook"];
    NSArray *fetchObjects = [[self coreDataManager].context executeFetchRequest:request error:nil];
    for (NoteBook *item in fetchObjects) {
        if ([note.title isEqual:item.title] && [note.content isEqual:item.content]) {
            [[self coreDataManager].context deleteObject:item];
            break;
        }
    }
    [[self coreDataManager]saveContext];
}

- (void)getBookList {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSArray *array = [[self coreDataManager].context executeFetchRequest:request error:nil];
    User *user = [array lastObject];
    NSArray *bookList = [NSArray  new];
    bookList = [NSKeyedUnarchiver unarchiveObjectWithData:user.books];
    if ([bookList count] == 0) {
        bookList = @[@"默认笔记本"];
    }
    
    [_delegate getNoteBookList:bookList];
}

- (NSArray *) getNoteOfBook:(NSString *)bookName {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NoteBook"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bookname=%@",bookName];
    [request setPredicate:predicate];
    NSArray *fetchObjects = [[self coreDataManager].context executeFetchRequest:request error:nil];
    return fetchObjects;
    
}


- (void)getCurrentUserInfo:(UserInfo *)user {
    self.userInfo = user;
    className = [self.userInfo getClassName];//self.userInfo.className;
}

- (void)deleteAllNotes {
    int i = 0;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NoteBook"];
    NSArray *fetchObject = [[self coreDataManager].context executeFetchRequest:request error:nil];
    for (NoteBook *item in fetchObject) {
        [[self coreDataManager].context deleteObject:item];
        NSLog(@"%d",++i);
    }
}

- (BOOL)setDataForCellWithNote:(NoteBook *)note Handler:(void (^)(NSString *, NSString *, NSString *))block {
    NSString *title = note.title;
    NSString *content = note.content;
    NSString *date = note.date;
    if (note!=nil) {
        block(title,content,date);
        return YES;
    }
    else {
        return NO;
    }
    
}


- (BmobObject *)convertNoteToBmobObject:(NoteBook *)note {
    BmobObject *obj = [BmobObject objectWithClassName:className];
    [obj setObject:note.content forKey:@"content"];
    NSString * title = [note.title mutableCopy];
    [obj setObject:title forKey:@"title"];
    [obj setObject:note.bookname forKey:@"notebook"];
    [obj setObject:note.date forKey:@"date"];
    return obj;
}


- (void)syncNoteToRemote {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BmobQuery *query = [[BmobQuery alloc]initWithClassName:className];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (error) {
                [_delegate syncWithError:@"同步失败"];
                return;
            }
            else {
                [self getRemoteNoteList:array];
            }
        }];
        UserInfo *userinfo = [UserInfo sharedManager];
        BmobQuery *bookQuery = [[BmobQuery alloc]initWithClassName:@"USER"];
        [query whereKey:@"username" equalTo:userinfo.userName];
        [bookQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            [self getBookListFromRemote:array];
        }];
        
    });
    
    
}



- (void)syncNoteToHome {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BmobQuery *query = [[BmobQuery alloc]initWithClassName:className];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            
            if (error&&error.code != 101) {
                NSLog(@"%@",error);
                [_delegate syncWithError:@"同步失败"];
                return ;
            }
            else {
                [self setRemoteNoteList:array];
            }
        }];
        
        UserInfo *userinfo = [UserInfo sharedManager];
        BmobQuery *bookQuery = [[BmobQuery alloc]initWithClassName:@"USER"];
        [query whereKey:@"username" equalTo:userinfo.userName];
        [bookQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            [self setBookListToRemote:array];
        }];
        
    });
    
    
}
- (void)setRemoteNoteList:(NSArray *)list {
    
    NSFetchRequest *request  = [NSFetchRequest fetchRequestWithEntityName:@"NoteBook"];
    NSArray *localNotes = [[self coreDataManager].context executeFetchRequest:request error:nil];
    NSMutableArray *syncedArray = [[NSMutableArray alloc]init];
    for (NoteBook *note in localNotes) {
        [syncedArray addObject:[self convertNoteToBmobObject:note]];
    }
    NSLog(@"--set - sync %lu",[syncedArray count]);

    NSInteger number = 0;
    NSLog(@"--set - list %lu",[list count]);
    
    
    for (BmobObject *item in syncedArray) {
        int counter = 0;
        
        for (BmobObject *note in list) {
            NSLog(@" in list %@",[note objectForKey:@"title"]);
            if ([[note objectForKey:@"title"]isEqual:[item objectForKey:@"title"]] &&[[item objectForKey:@"content"]isEqual:[note objectForKey:@"content"]] ) {
                counter = 1;
                break;
            }
            
        }
        if (counter == 0) {
            number ++;
            BmobObject *object = [[BmobObject alloc]initWithClassName:className];
            object = item;
            [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (error) {
                    [_delegate syncWithError:@"同步失败"];
                    
                }
            }];
        }
    }
    
    if (number + [list count] > [syncedArray count]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BmobQuery *query = [[BmobQuery alloc]initWithClassName:className];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                [self deleteNoteAtRemoteWithArray:array localList:syncedArray];
            }];

        });
    }
    
    [_delegate syncWithError:nil];
    
}

- (void)deleteNoteAtRemoteWithArray:(NSArray *)remoteList localList:(NSArray *)localList {
    for (BmobObject *obejct in remoteList ) {
        int counter = 0;
        for (BmobObject *note in localList) {
            if ([[note objectForKey:@"title"]isEqual:[obejct objectForKey:@"title"]] &&[[obejct objectForKey:@"content"]isEqual:[note objectForKey:@"content"]]) {
                counter = 0;
                break;
            }
            else {
                counter = 1;
            }
        }
        
        if (counter == 1) {
            [obejct deleteInBackground];
        }
    }
    
}


- (void)getRemoteNoteList:(NSArray *)list {
    NSFetchRequest *request  = [NSFetchRequest fetchRequestWithEntityName:@"NoteBook"];
    NSArray *localNotes = [[self coreDataManager].context executeFetchRequest:request error:nil];
    NSMutableArray *syncedArray = [[NSMutableArray alloc]init];
    for (NoteBook *note in localNotes) {
        [syncedArray addObject:[self convertNoteToBmobObject:note]];
    }
    
    if ([list count] == 0) {
        return;
    }

    for (BmobObject *item in list) {
        
        int counter = 0;
        
        for (BmobObject *note in syncedArray) {
            if ([[note objectForKey:@"title"]isEqual:[item objectForKey:@"title"]] &&[[item objectForKey:@"content"]isEqual:[note objectForKey:@"content"]] ) {
                counter = 1;
                break;
            }
        }
        
        if (counter == 0) {
            Note *note = [Note new];
            note.noteDate = [item objectForKey:@"date"];
            note.noteTitle = [item objectForKey:@"title"];
            note.noteContent = [item objectForKey:@"content"];
            note.bookName = [item objectForKey:@"notebook"];
            [self createNewNote:note];
        }

    }
    
    
    [_delegate syncWithError:nil];
}


// 处理笔记本

- (void)getBookListFromRemote:(NSArray *)array {
    BmobObject *object = [array lastObject];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSArray *fetchObjecs = [[self coreDataManager].context executeFetchRequest:request error:nil];
    User *user = [fetchObjecs lastObject];
    NSArray *bookList = [NSArray  new];
    bookList = [NSKeyedUnarchiver unarchiveObjectWithData:user.books];
    NSMutableArray *books = [[NSMutableArray alloc]initWithArray:bookList];
    [books removeAllObjects];
    [books addObjectsFromArray:[object objectForKey:@"booklist"]];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:books];
    user.books = data;
    [[self coreDataManager]saveContext];
    
}

- (void)setBookListToRemote:(NSArray *)array {
    
    BmobObject *object = [array lastObject];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSArray *fetchObjecs = [[self coreDataManager].context executeFetchRequest:request error:nil];
    User *user = [fetchObjecs lastObject];
    NSArray *bookList = [NSArray  new];
    bookList = [NSKeyedUnarchiver unarchiveObjectWithData:user.books];
    
    [object setObject:bookList forKey:@"booklist"];
    [object updateInBackground];
    
}



- (NSArray *)getTitlesFromNoteArray:(NSArray *)array {
    return  nil;
}
/* */
- (NSArray *)returnBackWithArray:(NSArray *)array baseArray:(NSArray *)baseArray {
    return nil;
}

- (Note *)getNoteFromBmobObject:(BmobObject *)object {
    return nil;
}





@end
