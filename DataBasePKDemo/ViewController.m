//
//  ViewController.m
//  DataBasePKDemo
//
//  Created by 刘杨 on 15/12/23.
//  Copyright © 2015年 TY. All rights reserved.
//

#import "ViewController.h"
#import "GFMDataBase.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    GFMDataBase *fmDataBase = [GFMDataBase sharedInstance];
    [fmDataBase dataBasePath];
    NSDate *oldDate = [NSDate date];
    NSTimeInterval oldInterval = [oldDate timeIntervalSince1970];
    for (int i = 0; i < 10000; i++) {
        
        [fmDataBase insertData:@"嘿嘿"];
    }
    NSDate *nowDate = [NSDate date];
    NSTimeInterval nowInterval = [nowDate timeIntervalSince1970];
    NSInteger timer = nowInterval - oldInterval;
    
    NSLog(@"插入完成");
//    [fmDataBase deleteData:@"嘿嘿"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
