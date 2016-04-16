//
//  ComposeViewController.h
//  HelloNote
//
//  Created by VicChan on 3/31/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoteBook;

@protocol ComposeControllerDelegate <NSObject>
@optional
- (void)finishComposeNote;

@end

@interface ComposeViewController : UIViewController

@property (nonatomic, strong) UITextView *noteContent;

@property (nonatomic, strong) UITextField *noteTitle;

@property (nonatomic, weak) id <ComposeControllerDelegate> delegate;

- (void)showCurrentNote:(NoteBook *)currentNote;


@end
