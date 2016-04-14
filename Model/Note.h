//
//  Note.h
//  HelloNote
//
//  Created by VicChan on 3/31/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject

@property (nonatomic, strong) NSString *noteTitle;
@property (nonatomic, strong) NSString *noteContent;
@property (nonatomic, strong) NSString *noteDate;
@property (nonatomic, strong) NSString *bookName;   // 笔记本名

@end
