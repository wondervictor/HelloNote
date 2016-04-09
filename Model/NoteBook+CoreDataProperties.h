//
//  NoteBook+CoreDataProperties.h
//  HelloNote
//
//  Created by VicChan on 4/9/16.
//  Copyright © 2016 VicChan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NoteBook.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoteBook (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *bookname;
@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSString *userclass;

@end

NS_ASSUME_NONNULL_END
