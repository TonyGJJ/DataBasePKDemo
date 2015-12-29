//
//  DataBaseTableViewCell.m
//  DataBasePKDemo
//
//  Created by 刘杨 on 15/12/29.
//  Copyright © 2015年 TY. All rights reserved.
//

#import "DataBaseTableViewCell.h"

@implementation DataBaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.activityView setHidden:YES];
    [self.timeLabel setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
