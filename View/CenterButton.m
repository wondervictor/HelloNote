//
//  CenterButton.m
//  HelloNote
//
//  Created by VicChan on 3/31/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import "CenterButton.h"

#define VIEW_WIDTH   (self.frame.size.width)
#define VIEW_HEIGHT  (self.frame.size.height)

@interface CenterButton() {
    // birth
    CGPoint birthLocation;
    // two subButtons;
    CGPoint oneButtonLocation;
    CGPoint twoButtonLocation;
    
    // Four subButtons
    CGPoint firstButtonLocation;
    CGPoint secondButtonLocation;
    CGPoint thirfButtonLocation;
    CGPoint fifthButtonLocation;
    
    // final
    CGPoint finalLocation;
    
    
}

@end

@implementation CenterButton

- (id)initWithFrame:(CGRect)frame
        centerPoint:(CGPoint)center
       centerRadius:(CGFloat)centerRadius
        centerImage:(NSString *)image
     withSubButtons:(NSInteger)nums
          backImage:(void (^)(CenterButton *))imageBlock toParentView:(UIView *)parentView{
    if (self = [super initWithFrame:frame]) {
        self.parentView = parentView;
        self.radius = centerRadius;
        self.counter = nums;
        self.center = center;
        self.isExpanded = NO;
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        self.layer.cornerRadius = 10;
        [self configureCenterButtonWithImage:image center:center centerRadius:centerRadius];
        [self configureLocations:nums];
        self.buttons = [[NSMutableArray alloc]initWithCapacity:nums];
        [self configureSubButtons:nums];
        imageBlock(self);
        
        [self.parentView addSubview:self];
    }
    return self;
}

- (void)configureLocations:(NSInteger)num {
    birthLocation = CGPointMake(-100, -500);
    finalLocation = CGPointMake(VIEW_WIDTH/2.0, VIEW_HEIGHT/2.0);
    if (num == 2) {
        oneButtonLocation = CGPointMake(VIEW_WIDTH/4.0-20,VIEW_HEIGHT/2.0);
        twoButtonLocation = CGPointMake(3 * VIEW_WIDTH/4.0+20,VIEW_HEIGHT/2.0);
    }
    else if (num == 4) {
        firstButtonLocation = CGPointMake(VIEW_WIDTH/6.0, VIEW_HEIGHT/2.0);
        secondButtonLocation = CGPointMake(2 * VIEW_WIDTH/6.0, VIEW_HEIGHT/2.0);
        thirfButtonLocation = CGPointMake(4 * VIEW_WIDTH/6.0, VIEW_HEIGHT/2.0);
        fifthButtonLocation = CGPointMake(5 *VIEW_WIDTH/6.0, VIEW_HEIGHT/2.0);
    }
}

- (void)configureCenterButtonWithImage:(NSString *)imageName center:(CGPoint)center centerRadius:(CGFloat)radius {
    UIButton *centerButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 2 * radius, 2 * radius)];
    centerButton.center = CGPointMake(VIEW_WIDTH/2.0, VIEW_HEIGHT/2.0);
    [centerButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    centerButton.layer.cornerRadius = radius;
    centerButton.layer.masksToBounds = YES;
    centerButton.enabled = YES;
    [centerButton addTarget:self action:@selector(centerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:centerButton];
    
}


- (void)centerButtonPressed:(UIButton *)sender {
    if (_isExpanded == YES) {
        _isExpanded = NO;
        if (self.counter == 2) {
            [self button:[self.buttons objectAtIndex:0] disappearAtLocation:oneButtonLocation withDuration:1.0 offsetX:-20 offsetY:0 rotation:1];
            [self button:[self.buttons objectAtIndex:1] disappearAtLocation:twoButtonLocation withDuration:1.0 offsetX:20 offsetY:0 rotation:-1];
        }
        else if (self.counter == 4) {
            [self button:[self.buttons objectAtIndex:0] disappearAtLocation:firstButtonLocation withDuration:1.0 offsetX:-20 offsetY:0 rotation:1];
            [self button:[self.buttons objectAtIndex:1] disappearAtLocation:secondButtonLocation withDuration:1.0 offsetX:-20 offsetY:0 rotation:1];
        
            [self button:[self.buttons objectAtIndex:2] disappearAtLocation:thirfButtonLocation withDuration:1.0 offsetX:20 offsetY:0 rotation:-1];
            [self button:[self.buttons objectAtIndex:3] disappearAtLocation:fifthButtonLocation withDuration:1.0 offsetX:20 offsetY:0 rotation:-1];
        }
        
    }
    else if (_isExpanded == NO) {
        _isExpanded = YES;
        if (self.counter == 2) {
            [self button:[self.buttons objectAtIndex:0] willAppearAtLocation:oneButtonLocation withDuration:1.0 offsetX:-20 offsetY:0];
            [self button:[self.buttons objectAtIndex:1] willAppearAtLocation:twoButtonLocation withDuration:1.0 offsetX:20 offsetY:0];
            
        }
        else if (self.counter == 4) {
            [self button:[self.buttons objectAtIndex:0] willAppearAtLocation:firstButtonLocation withDuration:1.0 offsetX:-20 offsetY:0];
            [self button:[self.buttons objectAtIndex:1] willAppearAtLocation:secondButtonLocation withDuration:1.0 offsetX:-20 offsetY:0];
            [self button:[self.buttons objectAtIndex:2] willAppearAtLocation:thirfButtonLocation withDuration:1.0 offsetX:20 offsetY:0];
            [self button:[self.buttons objectAtIndex:3] willAppearAtLocation:fifthButtonLocation withDuration:1.0 offsetX:20 offsetY:0];
        }
    }
}

- (void)configureSubButtons:(NSInteger)nums {
    for (int i = 0; i < nums  ; i ++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 1.8 * self.radius, 1.8 * self.radius)];
        button.layer.cornerRadius = 0.8 *self.radius;
        button.layer.masksToBounds = YES;
        [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
        button.center = birthLocation;
        [button addTarget:self action:@selector(subButtonPresses:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.buttons addObject:button];
    }
}

- (void)setSubButtonImage:(NSString *)imageName index:(NSInteger)index {
    UIButton *button = (UIButton *)[self.buttons objectAtIndex:index];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)subButtonPresses:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(touchSubButtonAtIndex:)]) {
        if ([[self.buttons objectAtIndex:0]isEqual:sender ]) {
            [_delegate touchSubButtonAtIndex:0];
        } else if ([[self.buttons objectAtIndex:1]isEqual:sender ]) {
            [_delegate touchSubButtonAtIndex:1];

        }
        if (self.counter == 4) {
            if ([[self.buttons objectAtIndex:2]isEqual:sender ]) {
                [_delegate touchSubButtonAtIndex:2];
            } else if ([[self.buttons objectAtIndex:3]isEqual:sender ]) {
                [_delegate touchSubButtonAtIndex:3];
            }
        }

    }
    
}

- (void)button:(UIButton *)button willAppearAtLocation:(CGPoint)location withDuration:(CGFloat)duration offsetX:(CGFloat)offsetx offsetY:(CGFloat)offsety {
    button.center = location;
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.values = @[@0.1,@1.3,@1];
    scaleAnimation.duration = duration;
    CGFloat time = duration/3.0;
    scaleAnimation.keyTimes = @[@0,[NSNumber numberWithFloat:time],[NSNumber numberWithFloat:2 * time]];
    CAKeyframeAnimation *translationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    translationAnimation.duration = duration;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, location.x, location.y);
    CGPathAddLineToPoint(path, NULL, location.x + offsetx, location.y + offsety);
    CGPathAddLineToPoint(path, NULL, location.x, location.y);
    translationAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[translationAnimation,scaleAnimation];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.duration = duration;
    button.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
    [button.layer addAnimation:group forKey:@"buttonAppear"];
    
}

- (void)button:(UIButton *)button disappearAtLocation:(CGPoint)location withDuration:(CGFloat)duration offsetX:(CGFloat)offsetx offsetY:(CGFloat)offsety rotation:(NSInteger)direction {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    animation.values = @[[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:direction * 2*M_PI],[NSNumber numberWithFloat:1.0]];
    CGFloat time = duration/3.0;
    animation.keyTimes = @[@0,[NSNumber numberWithFloat:time],[NSNumber numberWithFloat:2 * time]];
    
    CAKeyframeAnimation *translationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    translationAnimation.duration = duration;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, location.x, location.y);
    CGPathAddLineToPoint(path, NULL, location.x + offsetx, location.y + offsety);
    CGPathAddLineToPoint(path, NULL, finalLocation.x, finalLocation.y);
    translationAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[translationAnimation,animation];
    //group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.duration = duration;
    button.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
    button.center = birthLocation;
    [button.layer addAnimation:group forKey:@"buttonDisAppear"];
    
}







/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
