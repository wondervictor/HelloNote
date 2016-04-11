//
//  CoreDataManager.m
//  HelloNote
//
//  Created by VicChan on 4/9/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import "CoreDataManager.h"


static NSString *const storeFileName = @"note.sqlite";

@implementation CoreDataManager

@synthesize context = _context;
@synthesize model = _model;
@synthesize coordinator = _coordinator;
@synthesize store = _store;

- (NSURL *)applicationStoreDirectory {
    NSString *fileStorePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *storeDirectory = [NSURL fileURLWithPath:[fileStorePath stringByAppendingPathComponent:@"store"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:storeDirectory.path]) {
        NSError *error = nil;
        [fileManager createDirectoryAtURL:storeDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return storeDirectory;
}


- (NSURL *)getDataStoreFilePath {
    return [[self applicationStoreDirectory]URLByAppendingPathComponent:storeFileName];
}

- (id)init {
    if (self = [super init]) {
        _context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        _coordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:_model];
        [_context setPersistentStoreCoordinator:_coordinator];
    }
    return self;
}

- (void)loadStore {
    if (_store) {
        return;
    }
    
    NSError *error = nil;
    _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self getDataStoreFilePath] options:nil error:&error];
    
}

- (void)setCoreData {
    [self loadStore];
}

- (void)saveContext {
    NSLog(@"%@", [self getDataStoreFilePath].absoluteString);
    if ([_context hasChanges]) {
        NSError *error = nil;
        if ([_context save:&error]) {
            NSLog(@"saved to context");
        }
        else {
            NSLog(@"failed to save to context %@ ",error);
        }
    }
    else {
        NSLog(@"skipped ");
    }

}

@end
