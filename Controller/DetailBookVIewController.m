//
//  DetailBookVIewController.m
//  HelloNote
//
//  Created by VicChan on 4/16/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import "DetailBookVIewController.h"
#import "NoteBook.h"
#import "ComposeViewController.h"

#define  MAIN_WIDTH     (self.view.frame.size.width)
#define  MAIN_HEIGHT    (self.view.frame.size.height)
#define DEFAULT_COLOR   [UIColor colorWithRed:50/255.0 green:205/255.0 blue:50/255.0 alpha:0.98]


@interface DetailBookVIewController()<UITableViewDelegate,UITableViewDataSource,ComposeControllerDelegate>

@end


@implementation DetailBookVIewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"笔记";
    self.view.backgroundColor = DEFAULT_COLOR;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.noteList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   static NSString *const cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NoteBook *note =  [self.noteList objectAtIndex:indexPath.row];
    cell.textLabel.text = note.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ComposeViewController *compose = [[ComposeViewController alloc]init];
    compose.delegate = self;
    [compose showCurrentNote:[self.noteList objectAtIndex:indexPath.row]];
    [self showViewController:compose sender:nil];

}





@end
