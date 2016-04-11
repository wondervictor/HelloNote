//
//  Menu.m
//  aNote
//
//  Created by VicChan on 3/30/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import "Menu.h"
#define MAIN_WIDTH   ([UIScreen mainScreen].bounds.size.width)
#define MAIN_HEIGHT  ([UIScreen mainScreen].bounds.size.height)

@interface Menu()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end


@implementation Menu

- (id)initWithTitleArray:(NSArray *)titleArray image:(NSArray *)imageArray mainTitle:(NSString *)title withWidth:(CGFloat)width backgroundColor:(UIColor *)backColor{
    if (self = [super initWithFrame:CGRectMake(0, 0, width, MAIN_HEIGHT)]) {
        self.titles = titleArray;
        self.images = imageArray;
        self.layer.backgroundColor = backColor.CGColor;//= [UIColor orangeColor].CGColor;
        [self configureMainTitle:title withWidth:width];
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(10,90 , width-20,MAIN_HEIGHT - 80 ) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 60;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor clearColor];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self addSubview:self.tableView];
        
    
    }
    return self;
}

- (void)setMainTitle:(NSString *)title {
    UIButton *titleButton = (UIButton *)[self viewWithTag:1011];
    [titleButton setTitle:title forState:UIControlStateNormal];
}

- (void)configureMainTitle:(NSString *)title withWidth:(CGFloat)width {
    UIButton *titleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 30, width, 50)];
    [titleButton setTitle:title forState:UIControlStateNormal];
    titleButton.tag = 1011;
    CALayer *layer = titleButton.layer;
    layer.shadowOffset = CGSizeMake(0.5,0.5 );
    layer.cornerRadius = 3.0f;
    layer.borderColor = [UIColor lightGrayColor].CGColor;
    layer.borderWidth = 0.4f;
    layer.shadowColor = [UIColor lightGrayColor].CGColor;
    layer.shadowOpacity = 0.9;
    
    
    titleButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(mainTitleTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:titleButton];
}

- (void)mainTitleTouched:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(titleTouched:)]) {
        [_delegate titleTouched:self];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    NSInteger row = indexPath.row;
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.bounds];
    cell.selectedBackgroundView.layer.cornerRadius = 30.0f;
    cell.autoresizesSubviews = YES;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    cell.imageView.image = [UIImage imageNamed:[self.images objectAtIndex:row]];
    cell.textLabel.text = [self.titles objectAtIndex:row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(menuView:touchAtIndex:)]) {
        [_delegate menuView:self touchAtIndex:indexPath.row];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
