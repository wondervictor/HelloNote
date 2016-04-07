//
//  CenterButton.h
//  HelloNote
//
//  Created by VicChan on 3/31/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CenterButtonDelegate <NSObject>

- (void)touchSubButtonAtIndex:(NSInteger)index;

@end

@interface CenterButton : UIView

@property (nonatomic, strong) UIButton *centerButton;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIView *parentView;
@property (nonatomic) BOOL isExpanded;
@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSInteger counter;

@property (nonatomic, weak) id<CenterButtonDelegate> delegate;

/**
 @param
 @param
 
 */

- (id)initWithFrame:(CGRect)frame centerPoint:(CGPoint)center centerRadius:(CGFloat)centerRadius centerImage:(NSString *)image withSubButtons:(NSInteger)nums backImage:(void(^)(CenterButton *))imageBlock toParentView:(UIView *)parentView;

- (void)setSubButtonImage:(NSString *)imageName index:(NSInteger)index;



@end
