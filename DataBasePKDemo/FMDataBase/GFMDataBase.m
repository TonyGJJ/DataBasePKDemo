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
            NSLog(@"打开成功");
            [self creatTable];
        } else {
            NSLog(@"打开失败");
        }
     }
    return self;
}

- (void)creatTable
{
    NSString *creatTable = @"CREATE TABLE IF NOT EXISTS Test (id INTEGER PRIMARY KEY,text TEXT)";
    [self.dataBase executeUpdate:creatTable];
}

- (void)dataBasePath
{
    NSLog(@"%@",self.dataBase.databasePath);
}

- (void)insertData:(NSString *)str
{
    NSString *insertStr = @"INSERT INTO Test (text)VALUES(?)";
    [self.dataBase executeUpdate:insertStr,str];
}

- (void)deleteData:(NSString *)str
{
    NSString *deleteStr = @"DELETE FROM Test WHERE text = ?";
    [self.dataBase executeUpdate:deleteStr,str];
}
@end
