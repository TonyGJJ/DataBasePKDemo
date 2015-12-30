//
//  GFMDataBase.m
//  DataBasePKDemo
//
//  Created by 刘杨 on 15/12/23.
//  Copyright © 2015年 TY. All rights reserved.
//

#import "GFMDataBase.h"
#import "FMDB.h"

@interface GFMDataBase ()
@property (strong, nonatomic) FMDatabase *dataBase;
@property (strong, nonatomic) FMDatabaseQueue *queue;
@end

@implementation GFMDataBase

+ (instancetype)sharedInstance
{
    GFMDataBase *dataBase = [[GFMDataBase alloc] init];
    return dataBase;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask,
                                                             YES);
        NSString *path = [array lastObject];
        
        NSString *dataPath = [path stringByAppendingPathComponent:@"FMDataBase.db"];
        
        self.dataBase = [FMDatabase databaseWithPath:dataPath];
        if ([self.dataBase open]) {
            //NSLog(@"打开成功");
            self.queue = [FMDatabaseQueue databaseQueueWithPath:self.dataBase.databasePath];
            [self creatTable];
        } else {
            //NSLog(@"打开失败");
        }
     }
    return self;
}

- (void)creatTable
{
    NSString *creatTable = @"CREATE TABLE IF NOT EXISTS Test (id INTEGER PRIMARY KEY,text TEXT)";
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:creatTable];
    }];
}

- (void)dataBasePath
{
    NSLog(@"%@",self.dataBase.databasePath);
}

- (void)insertData:(NSString *)str
{
    NSString *insertStr = @"INSERT INTO Test (text)VALUES(?)";
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:insertStr,str];
    }];
}

- (NSArray *)selectData
{
    NSMutableArray *array = [NSMutableArray array];
    NSString *selectSQL = [NSString stringWithFormat:@"SELECT * FROM Test"];
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *ressuSet = [db executeQuery:selectSQL];
        while ([ressuSet next]) {
            NSString *str = [ressuSet stringForColumn:@"text"];
            [array addObject:str];
        }
    }];
    return array;
}

- (void)deleteData:(NSString *)str
{
    NSString *deleteStr = @"DELETE FROM Test WHERE text = ?";
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:deleteStr,str];
    }];
}
@end
