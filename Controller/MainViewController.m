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


#define  MAIN_WIDTH     self.view.frame.size.width
#define  MAIN_HEIGHT    self.view.frame.size.height
#define DEFAULT_COLOR   [UIColor colorWithRed:50/255.0 green:205/255.0 blue:50/255.0 alpha:0.98]


@interface MainViewController ()<CenterButtonDelegate,UserInfoDelegate,NoteManagerDelegate,UITableViewDelegate,UITableViewDataSource>

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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NoteCell class]) bundle:nil] forCellReuseIdentifier:@"NoteCell"];
    
    [self.view addSubview:self.tableView];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(menuViewTouchedAt:) name:@"MenuViewTouchedNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(menuTitleTouched:) name:@"TitleTouchedNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshNotes) name:@"ComposeControllerDidAddNewNoteNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userChanged) name:@"UserDidChangedNotification" object:nil];
   
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshNotes)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    UIRefreshControl *rc = [[UIRefreshControl alloc]init];
    rc.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [rc addTarget:self action:@selector(refreshControlRefreshed:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:rc];
    
    // Do any additional setup after loading the view.
}

- (void)refreshControlRefreshed:(UIRefreshControl *)refreshControl {
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"更新数据中..."];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"上次更新日期 %@",
                             [formatter stringFromDate:[NSDate date]]];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [self refreshNotes];
    [refreshControl endRefreshing];
}

- (void)userChanged {
    NoteManager *manager = [NoteManager sharedManager];
    manager.delegate = self;

    [manager getAllNote];
    [manager getBookList];
}


- (void)touchSubButtonAtIndex:(NSInteger)index {
    NoteManager *manager = [NoteManager sharedManager];
    manager.delegate = self;
    [manager getAllNote];
    [manager getBookList];
    
    
    if (index == 0) {
        ComposeViewController *compose = [ComposeViewController new];
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:compose];
        [compose showCurrentNote:nil];
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
    NSLog(@"%lu",[books count]);
    self.bookList = books;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:books forKey:@"booklist"];
    [userDefaults synchronize];
    
}

- (void)test {
    NoteManager *manager = [NoteManager sharedManager];
    Note *note = [Note new];
    note.noteDate = @"2016-04-07";
    note.noteTitle = @"TEST2";
    note.noteContent = @"测试notebook";
    note.bookName = @"haha";
    
    [manager createNewNote:note];
    
    
}

- (void)refreshNotes {
    NoteManager *manager = [NoteManager sharedManager];
    manager.delegate = self;
    [manager getAllNote];
    [manager getBookList];

}


#pragma mark - NoteManagerDelegate
- (void)getAllNotes:(NSArray *)notes {
    [self.noteList removeAllObjects];
    [self.noteList addObjectsFromArray:notes];
    NSLog(@"%lu",[self.noteList count]);
    [self.tableView reloadData];
}


#pragma mark - UserInfoDelegate
- (void)checkInfo:(BOOL)isCorrect withErrorInfo:(NSString *)string {
    if (isCorrect) {
        NSLog(@"correct");
    }
    else {
        NSLog(@"Failed");
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
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.noteList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"NoteCell" forIndexPath:indexPath];
    //Note *note = [self.noteList objectAtIndex:indexPath.row];
    NoteManager *manager = [NoteManager sharedManager];
    Note *note = [manager getNoteFromBmobObject:[self.noteList objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = note.noteTitle;
    cell.contentLabel.text = note.noteContent;
    cell.dateLabel.text = note.noteDate;
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
        Note *note = [manager getNoteFromBmobObject:[self.noteList objectAtIndex:indexPath.row]];
        [manager deleteNote:note];
        [self.noteList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    }
    [self.tableView reloadData];
    
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteManager *manager = [NoteManager sharedManager];
    NSLog(@"%lu",indexPath.row);
    // 有一个错误 show 有作用，present无作用
    Note *note = [manager getNoteFromBmobObject:[self.noteList objectAtIndex:indexPath.row]];
    ComposeViewController *compose = [[ComposeViewController alloc]init];
    [compose showCurrentNote:note];
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
