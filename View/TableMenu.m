//
//  TableMenu.m
//  HelloNote
//
//  Created by VicChan on 4/5/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import "TableMenu.h"
#define DEFAULT_COLOR   [UIColor colorWithRed:50/255.0 green:205/255.0 blue:50/255.0 alpha:0.98]



@interface TableMenu()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger current;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) NSArray *bookList;

@property (nonatomic, strong) UIView *parentView;

@property (nonatomic) CGPoint topLocation;

@end


@implementation TableMenu


- (id)initWithFrame:(CGRect)frame withArray:(NSArray *)array topLocation:(CGPoint)location parentView:(__weak UIView *)parentView{
    
    if (self = [super initWithFrame:frame]) {
        self.topLocation = location;
        self.bookList = array;
        self.backgroundColor = DEFAULT_COLOR;
        self.parentView = parentView;
        _showed = NO;
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, self.frame.size.width, 40 * [array count]) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
    }
    return self;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    current = indexPath.row;
    [self.tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

/*
- (UITableViewCellAccessoryType )tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {

    if(current==indexPath.row)
    {
        return UITableViewCellAccessoryCheckmark;
    }
    else
    {
        return UITableViewCellAccessoryNone;
    }
}
 */

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor =  [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == current) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    cell.textLabel.text = [self.bookList objectAtIndex:indexPath.row];
    return cell;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.bookList count];
}

- (void)viewDisappearFinishWithBlock:(ComplitionBlock)block {
    NSInteger index = current;
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectMake(0, self.topLocation.y, self.frame.size.width, 0);
        self.alpha = 0.1;
    } completion:^(BOOL finished) {
        _showed = NO;
        [self removeFromSuperview];
        block(index);
    }];

}



- (void)viewAppear {
    self.frame = CGRectMake(0, self.topLocation.y,self.frame.size.width , 0);
    self.alpha = 0.1;
    [self.parentView addSubview:self];
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake(0, self.topLocation.y, self.frame.size.width, [self.bookList count] * 40 + 10);
        self.alpha = 0.80;
    } completion:^(BOOL finished) {
        _showed = YES;
    }];
    
}



- (BOOL)isShowed {
    return _showed;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
