//
//  Note.h
//  HelloNote
//
//  Created by VicChan on 3/31/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject

@property (nonatomic, assign) NSString *noteTitle;
@property (nonatomic, assign) NSString *noteContent;
@property (nonatomic, assign) NSString *noteDate;
@property (nonatomic, assign) NSString *bookName;   // 笔记本名

@end
