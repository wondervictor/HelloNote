//
//  ComposeViewController.m
//  HelloNote
//
//  Created by VicChan on 3/31/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import "ComposeViewController.h"


#import "TableMenu.h"

#import "NoteManager.h"

#import "Note.h"

#define  MAIN_WIDTH     self.view.frame.size.width
#define  MAIN_HEIGHT    self.view.frame.size.height
#define DEFAULT_COLOR   [UIColor colorWithRed:50/255.0 green:205/255.0 blue:50/255.0 alpha:0.98]


static NSInteger counter = 0;

@interface ComposeViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    UIToolbar *toolBar;
    UIButton *bookButton;
    TableMenu *menu;
}

@property (nonatomic, strong) NSString *bookName;
@property (nonatomic, strong) NSArray *bookList;

@end

@implementation ComposeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DEFAULT_COLOR;
    self.title = @"新建笔记";

    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNote)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    
    
    
    //self.bookList = @[@"one",@"two",@"three",@"four"];
    self.bookList = [NSArray new];
    NSUserDefaults *userDafault = [NSUserDefaults standardUserDefaults];
    self.bookList = [userDafault objectForKey:@"booklist"];
    if (self.bookList == nil) {
        self.bookList = @[@"默认笔记本"];
    }
    
   // NSLog(@"%lu",[array count]);
    menu = [[TableMenu alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, [self.bookList count]*40 + 10) withArray:self.bookList topLocation:CGPointMake(MAIN_WIDTH/2.0,154) parentView:self.view];


    // Do any additional setup after loading the view.
}
/*
- (void)setBookListWithArray:(NSArray *)bookArray {
    self.bookList = bookArray;
}
*/

- (void)congfigureLeftButton {
    if (counter == 0) {
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 50, 40)];
        backButton.backgroundColor = [UIColor clearColor];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(dismissCurrentController) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:backButton];
        
    }
    else {
        return;
    }
}

- (void)configureViews {
    
// 2016-04-05 17:11:34.180 HelloNote[2226:70434] *** Assertion failure in -[UITextView _firstBaselineOffsetFromTop], /BuildRoot/Library/Caches/com.apple.xbs/Sources/UIKit_Sim/UIKit-3512.60.7/UITextView.m:1683
    self.noteContent = [[UITextView alloc]initWithFrame:CGRectMake(0, 154, MAIN_WIDTH, MAIN_HEIGHT - 154)];
   
    self.noteContent.backgroundColor = [UIColor whiteColor];
    
    self.noteContent.layer.borderWidth = 0.2;
    self.noteContent.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.noteContent.font = [UIFont fontWithName:@"Georgia" size:14.0f];
    self.noteContent.inputAccessoryView = [self accesoryView];
    [self.view addSubview:self.noteContent];

    
    
    self.noteTitle = [[UITextField alloc]initWithFrame:CGRectMake(0, 64,MAIN_WIDTH,40)];
    self.noteTitle.center = CGPointMake(MAIN_WIDTH/2.0, 84);
    self.noteTitle.textAlignment = NSTextAlignmentCenter;
    self.noteTitle.placeholder = @"请输入标题";
    self.noteTitle.delegate = self;
    [self.view addSubview:self.noteTitle];
    
    
    bookButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 104, MAIN_WIDTH, 40)];
    bookButton.center = CGPointMake(MAIN_WIDTH/2.0,124);
    bookButton.backgroundColor = [UIColor whiteColor];
    [bookButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    CALayer *buttonLayer = bookButton.layer;
    buttonLayer.shadowColor = [UIColor lightGrayColor].CGColor;
    buttonLayer.shadowRadius = 5;
    buttonLayer.borderWidth = 0.3;
    [bookButton addTarget:self action:@selector(popBookListView:) forControlEvents:UIControlEventTouchUpInside];
    
    [bookButton setTitle:@"请选择笔记本" forState:UIControlStateNormal];
    
    [self.view addSubview:bookButton];
    
    

}

- (void)popBookListView:(UIButton *)sender {
    if (menu.showed == YES) {
        [menu viewDisappearFinishWithBlock:^(NSInteger index) {
            self.bookName = [self.bookList objectAtIndex:index];
            [bookButton setTitle:self.bookName forState:UIControlStateNormal];
           // self.bookName = [self.bookList objectAtIndex:index];
        }];
    }
    else if (menu.showed == NO) {
        [menu viewAppear];
    }
}



- (void)setTextColor {
    
}


- (void)dismissCurrentController {
    [self.noteTitle resignFirstResponder];
    [self dismissKeyBoard];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"你还未保存" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        [self saveNote];
    }];
        
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [alert addAction:saveAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}



- (void)loadTextView {
    
}



// save
- (void)saveNote {
    
    
    
    [self.noteContent resignFirstResponder];
    [self.noteTitle resignFirstResponder];
    
    NSString *content = self.noteContent.text;
    NSString *title = self.noteTitle.text;

    NoteManager *manager = [NoteManager sharedManager];
    Note *note = [Note new];
    note.noteContent = content;
    note.noteTitle = title;
    note.bookName = self.bookName;
    
    if (counter == 1) {
        [manager modifyNote:note];
    }
    else if (counter == 0)  {
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        note.noteDate = dateString;
        [manager createNewNote:note];
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ComposeControllerDidAddNewNoteNotification" object:nil userInfo:nil];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)dismissKeyBoard {
    [self.noteContent resignFirstResponder];
}

- (void)clearText {
    self.noteContent.text = @"";
}

- (UIToolbar *)accesoryView {
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 44.0)];
    [toolBar setTintColor:[UIColor darkGrayColor]];
    
    NSMutableArray *items = [NSMutableArray array];
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc]initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearText)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyBoard)];
    UIBarButtonItem *colorButton = [[UIBarButtonItem alloc]initWithTitle:@"Color" style:UIBarButtonItemStylePlain target:self action:@selector(setTextColor)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [items addObject:clearButton];
    [items addObject:space];
    [items addObject:colorButton];
    [items addObject:space];
    [items addObject:doneButton];
    
    toolBar.items = items;
    return toolBar;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)showCurrentNote:(Note *)currentNote {
    counter = 1;
    [self configureViews];
    if (currentNote == nil) {
        counter = 0;
        [self congfigureLeftButton];
        return;
    }
    else {
        
        self.noteTitle.text = currentNote.noteTitle;
        self.noteContent.text = currentNote.noteContent;
        [bookButton setTitle:currentNote.bookName forState:UIControlStateNormal];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
