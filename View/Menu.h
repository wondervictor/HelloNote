//
//  Menu.h
//  aNote
//
//  Created by VicChan on 3/30/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Menu;

@protocol MenuViewDelegate <NSObject>

- (void)menuView:(Menu *)view touchAtIndex:(NSInteger)index;
- (void)titleTouched:(id)sender;

@end

@interface Menu : UIView

@property (nonatomic, weak) id <MenuViewDelegate> delegate;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;


- (id)initWithTitleArray:(NSArray *)titleArray image:(NSArray *)imageArray mainTitle:(NSString *)title withWidth:(CGFloat)width backgroundColor:(UIColor *)backColor;

- (void)setMainTitle:(NSString *)title;

@end
