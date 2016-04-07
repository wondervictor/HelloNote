//
//  ComposeViewController.h
//  HelloNote
//
//  Created by VicChan on 3/31/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Note;


@interface ComposeViewController : UIViewController

@property (nonatomic, strong) UITextView *noteContent;

@property (nonatomic, strong) UITextField *noteTitle;


- (void)showCurrentNote:(Note *)currentNote;


@end
