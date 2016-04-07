//
//  TableMenu.h
//  HelloNote
//
//  Created by VicChan on 4/5/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableMenu : UIView

typedef void (^ComplitionBlock)(NSInteger);


@property (nonatomic, getter=isShowed) BOOL showed;

- (id)initWithFrame:(CGRect)frame
          withArray:(NSArray *)array
        topLocation:(CGPoint)location
         parentView:(__weak UIView *)parentView;


- (void)viewAppear;

- (void)viewDisappearFinishWithBlock:(ComplitionBlock)block;


@end
