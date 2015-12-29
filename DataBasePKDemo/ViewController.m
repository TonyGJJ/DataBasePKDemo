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
#import "DataBaseTableViewCell.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"程序启动");
    
    self.dataArray = @[@"FMDB插入数据",
                       @"FMDB删除数据",
                       @"CoreData一条一条插入数据",
                       @"CoreData一条一条删除数据",
                       @"CoreData一次性插入全部数据",
                       @"CoreData一次性删除全部数据",
                       @"Realm一条一条插入数据",
                       @"Realm一条一条删除数据",
                       @"Realm一次性插入全部数据",
                       @"Realm一次性删除全部数据"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DataBaseTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.titleLabel.text = self.dataArray[indexPath.row];
    cell.timeLabel.tag = indexPath.row + 1000;
    cell.activityView.tag = indexPath.row + 2000;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataBaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self process:cell atIndexPath:indexPath];
}

- (void)process:(DataBaseTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger activitTag = 2000 + indexPath.row;
    NSInteger timeLabelTag = 1000 + indexPath.row;
    
    if (activitTag == cell.activityView.tag) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView setUserInteractionEnabled:NO];
            [cell.activityView setHidden:NO];
            [cell.activityView startAnimating];
            [cell.timeLabel setHidden:YES];
        });
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *str;
        switch (indexPath.row) {
            case 0:
                str = [self insertFMDB:cell atIndexPath:indexPath];
                break;
            case 1:
                str = [self deleteFMDB:cell atIndexPath:indexPath];
                break;
            case 2:
                str =  [self insertCDDB:cell atIndexPath:indexPath];
                break;
            case 3:
                str = [self deleteCDDB:cell atIndexPath:indexPath];
                break;
            case 4:
                str = [self insertCDDBALL:cell atIndexPath:indexPath];
                break;
            case 5:
                str = [self deleteCDDBALL:cell atIndexPath:indexPath];
                break;
            case 6:
                str = [self insertRDB:cell atIndexPath:indexPath];
                break;
            case 7:
                str = [self deleteRDB:cell atIndexPath:indexPath];
                break;
            case 8:
                str = [self insertRDBALL:cell atIndexPath:indexPath];
                break;
            case 9:
                str = [self deleteRDBALL:cell atIndexPath:indexPath];
                break;
            default:
                break;
        }
        
        if (activitTag == cell.activityView.tag) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.activityView setHidden:YES];
                [cell.activityView stopAnimating];
            });
        }
        if (timeLabelTag == cell.timeLabel.tag) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.timeLabel setHidden:NO];
                cell.timeLabel.text = str;
            });
        }
        [self.tableView setUserInteractionEnabled:YES];
    });
}

- (NSString *)insertFMDB:(DataBaseTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDate *date = [NSDate date];
    GFMDataBase *fmDataBase = [GFMDataBase sharedInstance];
    [fmDataBase dataBasePath];
    [self printWillFuncTime];
    for (int i = 0; i < 1000; i++) {
        NSString *str = [NSString stringWithFormat:@"数据%d",i+1];
        [fmDataBase insertData:str];
        NSLog(@"插入第%d条数据",i+1);
    }
    
   return [self printFuncDidTime:date];
}

- (NSString *)deleteFMDB:(DataBaseTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    GFMDataBase *fmDataBase = [GFMDataBase sharedInstance];
    NSArray *array = [fmDataBase selectData];
    NSDate *date = [NSDate date];
    [self printWillFuncTime];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [fmDataBase deleteData:obj];
        NSLog(@"删除第%@条数据",obj);
    }];
    return [self printFuncDidTime:date];
}

- (NSString *)insertCDDB:(DataBaseTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDate *date = [NSDate date];
    DataBaseManager *cdDataBase = [DataBaseManager sharedInstance];
    [self printWillFuncTime];
    for (int i = 0; i < 1000; i++) {
        NSString *str = [NSString stringWithFormat:@"数据%d",i+1];
        // CoreData插入数据
        [cdDataBase insertManagedObject:str];
        [cdDataBase saveManaged];
        NSLog(@"插入第%d条数据",i+1);
    }
    return [self printFuncDidTime:date];
}

- (NSString *)deleteCDDB:(DataBaseTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    DataBaseManager *cdDataBase = [DataBaseManager sharedInstance];
    NSArray *array = [cdDataBase selectAllManagedObject];
    NSDate *date = [NSDate date];
    [self printWillFuncTime];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [cdDataBase deleteManagedObject:obj];
        NSLog(@"插入第%@条数据",obj);
    }];
    return [self printFuncDidTime:date];
}

- (NSString *)insertCDDBALL:(DataBaseTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDate *date = [NSDate date];
    DataBaseManager *cdDataBase = [DataBaseManager sharedInstance];
    [self printWillFuncTime];
    for (int i = 0; i < 1000; i++) {
        NSString *str = [NSString stringWithFormat:@"数据%d",i+1];
        // CoreData插入数据
        [cdDataBase insertManagedObject:str];
        NSLog(@"插入第%d条数据",i+1);
    }
    [cdDataBase saveManaged];
    return [self printFuncDidTime:date];
}

- (NSString *)deleteCDDBALL:(DataBaseTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    DataBaseManager *cdDataBase = [DataBaseManager sharedInstance];
    NSDate *date = [NSDate date];
    [self printWillFuncTime];
    [cdDataBase deleteAllManagedObject];
    
    return [self printFuncDidTime:date];
}

- (NSString *)insertRDB:(DataBaseTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDate *date = [NSDate date];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [self printWillFuncTime];
    for (int i = 0; i < 1000; i ++) {
        NSString *str = [NSString stringWithFormat:@"数据%d",i+1];
        [realm beginWriteTransaction];
        RTestDataBase *rDataBase = [[RTestDataBase alloc] init];
        rDataBase.text = str;
        [realm addObject:rDataBase];
        [realm commitWriteTransaction];
        NSLog(@"插入第%d条数据",i+1);
    }
    
    return [self printFuncDidTime:date];
}

- (NSString *)deleteRDB:(DataBaseTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDate *date = [NSDate date];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [self printWillFuncTime];
    RLMResults *results = [RTestDataBase allObjects];
    
    int i = 0;
    while (results.count) {
        [realm beginWriteTransaction];
        [realm deleteObject:[results firstObject]];
        NSLog(@"删除第%d条数据",i + 1);
        i++;
        [realm commitWriteTransaction];
    }
    NSLog(@"删除后还有%ld条数据",results.count);
    
    return [self printFuncDidTime:date];
}

- (NSString *)insertRDBALL:(DataBaseTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDate *date = [NSDate date];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [self printWillFuncTime];
    // Realm 插入数据
    [realm transactionWithBlock:^{
        for (int i = 0; i < 1000; i ++) {
            NSString *str = [NSString stringWithFormat:@"数据%d",i+1];
            RTestDataBase *rDataBase = [[RTestDataBase alloc] init];
            rDataBase.text = str;
            [realm addObject:rDataBase];
            NSLog(@"插入第%d条数据",i+1);
        }
    }];
    
    return [self printFuncDidTime:date];
}

- (NSString *)deleteRDBALL:(DataBaseTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    NSDate *date = [NSDate date];
    [self printWillFuncTime];
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
    RLMResults *results = [RTestDataBase allObjects];
    NSLog(@"删除后还有%ld条数据",results.count);
    return [self printFuncDidTime:date];
}

- (void)printWillFuncTime
{
    NSLog(@"开始执行");
}

- (NSString *)printFuncDidTime:(NSDate *)date
{
    NSInteger oldInterval = [date timeIntervalSince1970];
    NSDate *nowDate = [NSDate date];
    NSInteger nowInterval = [nowDate timeIntervalSince1970];
    NSInteger timer = nowInterval - oldInterval;
    NSString *str = [NSString stringWithFormat:@"耗时:%ldms",timer];
    
    return str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
