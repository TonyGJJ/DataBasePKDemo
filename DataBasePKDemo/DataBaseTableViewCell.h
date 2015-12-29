//
//  DataBaseTableViewCell.h
//  DataBasePKDemo
//
//  Created by 刘杨 on 15/12/29.
//  Copyright © 2015年 TY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataBaseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end
