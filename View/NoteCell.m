//
//  NoteCell.m
//  HelloNote
//
//  Created by VicChan on 4/5/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import "NoteCell.h"

@implementation NoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setCellWithTitle:(NSString *)title content:(NSString *)content date:(NSString *)date {
    
    self.titleLabel.text = title;
    self.contentLabel.text = content;
    self.dateLabel.text =date;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGRect rect = self.frame;
        rect.size.width = [UIScreen mainScreen].bounds.size.width;
        self.frame = rect;
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,0, 180, 30)];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:19];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, self.frame.size.width-20,30)];
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contentLabel];
        
        
        
        
        self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 120 , 0, 110, 21)];
        
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.font = [UIFont systemFontOfSize:13];
        self.dateLabel.textColor = [UIColor darkGrayColor];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.dateLabel];
        
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 0.3;
        
        
    }
    
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
