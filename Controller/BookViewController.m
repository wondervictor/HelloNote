//
//  BookViewController.m
//  HelloNote
//
//  Created by VicChan on 4/2/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import "BookViewController.h"


#define  MAIN_WIDTH     self.view.frame.size.width
#define  MAIN_HEIGHT    self.view.frame.size.height
#define DEFAULT_COLOR   [UIColor colorWithRed:50/255.0 green:205/255.0 blue:50/255.0 alpha:0.98]



@interface BookViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"笔记本";
    NSUserDefaults *userDafault = [NSUserDefaults standardUserDefaults];
    self.bookList = [NSMutableArray new];

    [self.bookList addObjectsFromArray: [userDafault objectForKey:@"booklist"]];
    
    self.view.backgroundColor = DEFAULT_COLOR;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 130, MAIN_WIDTH, MAIN_HEIGHT - 130) style:UITableViewStylePlain];;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    
    
    
    // Do any additional setup after loading the view.
}

/*
- (void)getBookListArray {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [self.bookList addObjectsFromArray:[userDefaults objectForKey:@"booklist"]];
    if ([self.bookList count] == 0) {
        [self.bookList addObject:@"默认笔记本"];
    }
    
    
}
*/

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.bookList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const identifier = @"BookCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self.bookList objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)setBookListWithArray:(NSArray *)array {
    [self.bookList removeAllObjects];
    [self.bookList addObjectsFromArray:array];
    [self.tableView reloadData];
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
