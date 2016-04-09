//
//  User+CoreDataProperties.h
//  HelloNote
//
//  Created by VicChan on 4/9/16.
//  Copyright © 2016 VicChan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSData *books;
@property (nullable, nonatomic, retain) NSString *classname;

@end

NS_ASSUME_NONNULL_END
