//
//  NavigationController.h
//  HelloNote
//
//  Created by VicChan on 3/31/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"



@interface NavigationController : UINavigationController

@property (nonatomic, strong) Menu *menu;

@property (nonatomic, strong) UIView *transitionView;

@end
