//
//  NoteCell.h
//  HelloNote
//
//  Created by VicChan on 4/5/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteCell : UITableViewCell

@property (strong, nonatomic)  UILabel *titleLabel;

@property (nonatomic, strong)  UILabel *contentLabel;

@property (nonatomic, strong)  UILabel *dateLabel;


- (void)setCellWithTitle:(NSString *)title content:(NSString *)content date:(NSString *)date;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


@end
