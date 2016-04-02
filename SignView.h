//
//  SignView.h
//  aNote
//
//  Created by VicChan on 3/29/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignViewDelegate <NSObject>

- (void)finishSignUpWithData:(NSDictionary *)dictData;

@end


@interface SignView : UIView

@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, weak) id <SignViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withCenter:(CGPoint)center toParentView:(UIView *)view;
- (void)viewAppear;
- (void)viewDisappear;

@end
