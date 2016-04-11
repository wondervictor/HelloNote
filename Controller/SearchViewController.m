//
//  SearchViewController.m
//  HelloNote
//
//  Created by VicChan on 4/2/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import "SearchViewController.h"
#import "ComposeViewController.h"

#import "NoteCell.h"
#import "Note.h"
#import "NoteManager.h"

#define DEFAULT_COLOR   [UIColor colorWithRed:50/255.0 green:205/255.0 blue:50/255.0 alpha:0.98]
#define  MAIN_WIDTH     (self.view.frame.size.width)
#define  MAIN_HEIGHT    (self.view.frame.size.height)


@interface SearchViewController ()<UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource,NoteManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchNotes;

@property (nonatomic, strong) NSMutableArray *filterNotes;


@end

static NSString *const cellIdentifier = @"NoteCell";

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NoteManager *manager = [NoteManager sharedManager];
    manager.delegate = self;
    [manager getAllNote];
    
    
    self.view.backgroundColor = DEFAULT_COLOR;
    self.title = @"搜索";
    self.filterNotes = [NSMutableArray new];
    self.searchNotes = [NSMutableArray new];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NoteCell class]) bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.searchController.searchBar sizeToFit];
    self.searchController.dimsBackgroundDuringPresentation = YES;
    // Do any additional setup after loading the view.
}




#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self.filterNotes removeAllObjects];
    
    NoteManager *manager = [NoteManager sharedManager];
    NSArray *noteTitles = [manager getTitlesFromNoteArray:self.searchNotes];
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", self.searchController.searchBar.text];
    

    NSMutableArray *array = [[noteTitles filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    [self.filterNotes addObjectsFromArray: [manager returnBackWithArray:array baseArray:self.searchNotes]];
    NSLog(@"%lu",[self.filterNotes count]);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });

    
    
}


- (void)getAllNotes:(NSArray *)notes {
    [self.searchNotes removeAllObjects];
    [self.searchNotes addObjectsFromArray:notes];
    
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filterNotes count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NoteManager *manager = [NoteManager sharedManager];
    if (self.searchController.active == YES) {
        Note *note = [manager getNoteFromBmobObject:[self.filterNotes objectAtIndex:indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = note.noteTitle;
        cell.contentLabel.text = note.noteContent;
        cell.dateLabel.text = note.noteDate;
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteManager *manager = [NoteManager sharedManager];
    NSLog(@"%lu",indexPath.row);
    // 有一个错误 show 有作用，present无作用
    Note *note = [manager getNoteFromBmobObject:[self.filterNotes objectAtIndex:indexPath.row]];
    ComposeViewController *compose = [[ComposeViewController alloc]init];
    [compose showCurrentNote:note];
    // [self presentViewController:navigationController animated:YES completion:nil];
    [self showViewController:compose sender:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
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
