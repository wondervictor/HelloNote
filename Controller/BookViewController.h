//
//  BookViewController.h
//  HelloNote
//
//  Created by VicChan on 4/2/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BookControllerDelegate <NSObject>

- (void)finishedAddNewBook;

@end


@interface BookViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, weak) id<BookControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *bookList;

- (void)setBookListWithArray:(NSArray *)array;

@end
