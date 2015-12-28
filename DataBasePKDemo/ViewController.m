//
//  ViewController.m
//  DataBasePKDemo
//
//  Created by 刘杨 on 15/12/23.
//  Copyright © 2015年 TY. All rights reserved.
//

#import "ViewController.h"
#import "GFMDataBase.h"
#import "RTestDataBase.h"
#import "DataBaseManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDate *oldDate = [NSDate date];

    [self insertFMDB:oldDate];
//    [self insertCDDB:oldDate];
//    [self insertRDB:oldDate];
}

- (void)insertFMDB:(NSDate *)date
{
    GFMDataBase *fmDataBase = [GFMDataBase sharedInstance];
    [fmDataBase dataBasePath];
    [self printWillFuncTime];
    for (int i = 0; i < 10000; i++) {
        NSString *str = [NSString stringWithFormat:@"数据%d",i+1];
        [fmDataBase insertData:str];
        NSLog(@"插入第%d条数据",i+1);
    }
    [self printFuncDidTime:date];
}

- (void)insertCDDB:(NSDate *)date
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [self printWillFuncTime];
    // Realm 插入数据
    [realm transactionWithBlock:^{
        for (int i = 0; i < 10000; i ++) {
            NSString *str = [NSString stringWithFormat:@"数据%d",i+1];
            RTestDataBase *rDataBase = [[RTestDataBase alloc] init];
            rDataBase.text = str;
            [realm addObject:rDataBase];
        }
    }];
    [self printFuncDidTime:date];
}

- (void)insertRDB:(NSDate *)date
{
    DataBaseManager *cdDataBase = [DataBaseManager sharedInstance];
    [self printWillFuncTime];
    for (int i = 0; i < 10000; i++) {
        NSString *str = [NSString stringWithFormat:@"数据%d",i+1];
        // CoreData插入数据
        [cdDataBase insertManagedObject:str];
        [cdDataBase saveManaged];
        NSLog(@"插入第%d条数据",i+1);
    }
    [self printFuncDidTime:date];
}

- (void)printWillFuncTime
{
    NSLog(@"开始执行");
}

- (void)printFuncDidTime:(NSDate *)date
{
    NSInteger oldInterval = [date timeIntervalSince1970];
    NSDate *nowDate = [NSDate date];
    NSInteger nowInterval = [nowDate timeIntervalSince1970];
    NSInteger timer = nowInterval - oldInterval;
    
    NSLog(@"插入完成,耗时 %ldms",timer);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
