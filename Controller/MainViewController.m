//
//  MainViewController.m
//  HelloNote
//
//  Created by VicChan on 3/31/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import "MainViewController.h"

#import "LoginViewController.h"
#import "BookViewController.h"
#import "ComposeViewController.h"
#import "SettingViewController.h"
#import "UserViewController.h"
#import "SearchViewController.h"

#import "CenterButton.h"
#import "NoteCell.h"

#import "UserInfo.h"
#import "NoteManager.h"
#import "Note.h"

#import "NoteBook.h"



#define  MAIN_WIDTH     (self.view.frame.size.width)
#define  MAIN_HEIGHT    (self.view.frame.size.height)
#define DEFAULT_COLOR   [UIColor colorWithRed:50/255.0 green:205/255.0 blue:50/255.0 alpha:0.98]


@interface MainViewController ()<ComposeControllerDelegate,BookControllerDelegate,CenterButtonDelegate,UserInfoDelegate,NoteManagerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *noteList;

@property (nonatomic, strong) NSArray *bookList;

@property (nonatomic, strong) SettingViewController  *settingViewController;
@property (nonatomic, strong) BookViewController *bookViewController;
@property (nonatomic, strong) UserViewController *userViewController;
@property (nonatomic, strong) ComposeViewController *composeViewController;
@property (nonatomic, strong) SearchViewController *searchViewController;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DEFAULT_COLOR;
    self.title = @"笔记";
    self.noteList = [NSMutableArray new];
    self.bookList = [NSArray new];
    [self refreshNotes];
    
    CenterButton *centerButton = [[CenterButton alloc]initWithFrame:CGRectMake(0, 0,MAIN_WIDTH , 60) centerPoint:CGPointMake(MAIN_WIDTH/2.0,94) centerRadius:25 centerImage:@"new" withSubButtons:2 backImage:^(CenterButton *cb) {
        [cb setSubButtonImage:@"write" index:0];
        [cb setSubButtonImage:@"book" index:1];
    } toParentView:self.view];
    centerButton.delegate = self;
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 130, MAIN_WIDTH, MAIN_HEIGHT - 130) style:UITableViewStylePlain];;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizesSubviews = YES;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.view addSubview:self.tableView];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(menuViewTouchedAt:) name:@"MenuViewTouchedNotification" object:nil];
    

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userChanged) name:UserDidChangedNotification
 object:nil];
    
    UIBarButtonItem *syncRemoteButton = [[UIBarButtonItem alloc]initWithTitle:@"同步到云" style:UIBarButtonItemStylePlain target:self action:@selector(syncNoteToRemoteDB)];
    
    self.navigationItem.leftBarButtonItem = syncRemoteButton;
    UIBarButtonItem *syncLocalButton = [[UIBarButtonItem alloc]initWithTitle:@"同步到本地" style:UIBarButtonItemStylePlain target:self action:@selector(syncNoteToLocal)];
    
    self.navigationItem.rightBarButtonItem = syncLocalButton;
    
    
    UIRefreshControl *rc = [[UIRefreshControl alloc]init];
    rc.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [rc addTarget:self action:@selector(refreshControlRefreshed:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:rc];
    
    // Do any additional setup after loading the view.
}

- (void)refreshControlRefreshed:(UIRefreshControl *)refreshControl {
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"更新数据中..."];
    [self refreshNotes];
    [refreshControl endRefreshing];
}

- (void)userChanged {
    [self refreshNotes];

}

#pragma mark - ComposeControllerDelegate
- (void)finishComposeNote {
    [self refreshNotes];
}

#pragma mark bookcontroller

- (void)finishedAddNewBook {
    [self refreshNotes];
}


- (void)touchSubButtonAtIndex:(NSInteger)index {
    NoteManager *manager = [NoteManager sharedManager];
    manager.delegate = self;
    [manager getAllNote];
    [manager getBookList];
    
    
    if (index == 0) {
        ComposeViewController *compose = [ComposeViewController new];
        compose.delegate = self;
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:compose];
        [compose showCurrentNote:nil];
        navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:navigationController animated:YES completion:^{
            
        }];
    }
    else if (index == 1) {

        [self showViewController:[self bookViewController] sender:nil];
    }
}

- (void)menuViewTouchedAt:(NSNotification *)notification {
    NSInteger index = [(NSNumber*)[notification object]integerValue];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MenuDidTouchedNotification" object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        switch (index) {
            case 0:[self showViewController:[self userViewController] sender:nil];break;
            case 1:[self showViewController:[self settingViewController] sender:nil];break;
            case 2: break;
            case 3:[self showViewController:[self searchViewController] sender:nil];break;
            default:
                break;
        }
    });

}

- (void)getNoteBookList:(NSArray *)books {
    self.bookList = books;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:books forKey:@"booklist"];
    [userDefaults synchronize];
    
}


#pragma mark - 同步
/*
- (void)syncNote {
    NoteManager *manager = [NoteManager sharedManager];
    manager.delegate = self;
    [manager syncNoteToHome];
    [manager syncNoteToRemote];
}
*/

- (void)syncNoteToLocal {
    NoteManager *manager = [NoteManager sharedManager];
    manager.delegate = self;
    [manager syncNoteToRemote];
}

- (void)syncNoteToRemoteDB {
    NoteManager *manager = [NoteManager sharedManager];
    manager.delegate = self;
    [manager syncNoteToHome];
}


- (void)refreshNotes {
    NoteManager *manager = [NoteManager sharedManager];
    manager.delegate = self;
    [manager getAllNote];
    [manager getBookList];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - NoteManagerDelegate
- (void)getAllNotes:(NSArray *)notes {
    [self.noteList removeAllObjects];
    [self.noteList addObjectsFromArray:notes];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];

    });
}


- (void)getNoteOfaBook:(NSArray *)notes {
    NSLog(@"dafghj");
}


- (void)syncWithError:(NSString *)error {
    if (error != nil) {
        NSLog(@"wrong sync");
    }
    else {
        NSLog(@"finish");
        [self refreshNotes];
    }
}


#pragma mark - UserInfoDelegate
- (void)checkInfo:(BOOL)isCorrect withErrorInfo:(NSString *)string {
    if (isCorrect) {
        NSLog(@"correct");
    }
    else {
        NSLog(@"%@",string);
    }
}

//  Lazy Load

- (SettingViewController *)settingViewController {
    if (_settingViewController == nil) {
       _settingViewController = [SettingViewController new];
    }
    return _settingViewController;
}

- (BookViewController *)bookViewController {
    if (_bookViewController == nil) {
        _bookViewController = [BookViewController new];
    }
    _bookViewController.delegate = self;
    [_bookViewController setBookListWithArray:self.bookList];
    return _bookViewController;
}

- (SearchViewController *)searchViewController {
    if (_searchViewController == nil) {
        _searchViewController = [SearchViewController new];
    }
    //[_searchViewController setNoteAttay:self.noteList];
    return _searchViewController;
}

- (UserViewController *)userViewController {
    if (_userViewController == nil) {
        _userViewController = [UserViewController new];
    }
    return _userViewController;
}


- (void)menuTitleTouched:(NSNotification *)notification {
    NSLog(@"title touched");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.noteList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const reuseIdentifier = @"NoteCell";
    NoteCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[NoteCell alloc]initWithStyle:0 reuseIdentifier:reuseIdentifier];
        
    }

    //Note *note = [self.noteList objectAtIndex:indexPath.row];
    NoteManager *manager = [NoteManager sharedManager];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BOOL isSuccess = [manager setDataForCellWithNote:[self.noteList objectAtIndex:indexPath.row] Handler:^(NSString *title, NSString *content, NSString *date) {
        [cell setCellWithTitle:title content:content date:date];
    }];
    if (isSuccess == NO) {
        return nil;
    }
    /*
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = note.noteTitle;
    cell.contentLabel.text = note.noteContent;
    cell.dateLabel.text = note.noteDate;
     
     */
    return cell;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NoteManager *manager = [NoteManager sharedManager];
        [manager deleteNote:[self.noteList objectAtIndex:indexPath.row]];
        [self.noteList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    }
    [self.tableView reloadData];
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   // NoteManager *manager = [NoteManager sharedManager];
    // 有一个错误 show 有作用，present无作用
    //Note *note = [manager getNoteFromBmobObject:[self.noteList objectAtIndex:indexPath.row]];
    
    
    ComposeViewController *compose = [[ComposeViewController alloc]init];
    compose.delegate = self;
    [compose showCurrentNote:[self.noteList objectAtIndex:indexPath.row]];
   // [self presentViewController:navigationController animated:YES completion:nil];
    [self showViewController:compose sender:nil];
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
