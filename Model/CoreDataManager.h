//
//  CoreDataManager.h
//  HelloNote
//
//  Created by VicChan on 4/9/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CoreDataManager : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *context;
@property (nonatomic, readonly) NSManagedObjectModel *model;
@property (nonatomic, readonly) NSPersistentStore *store;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *coordinator;

- (void)setCoreData;

- (void)saveContext;

@end
