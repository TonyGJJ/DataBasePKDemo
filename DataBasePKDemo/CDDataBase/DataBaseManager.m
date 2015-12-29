//
//  DataBaseManager.m
//  CoreDataPPT
//
//  Created by 刘杨 on 15/11/11.
//  Copyright © 2015年 TY. All rights reserved.
//

#import "DataBaseManager.h"
#import "CoreDataProvider.h"
#import "Entity+CoreDataProperties.h"

@interface DataBaseManager ()
@property (strong, nonatomic) CoreDataProvider *provider;
@end

@implementation DataBaseManager

+ (instancetype)sharedInstance
{
    static DataBaseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataBaseManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.provider = [CoreDataProvider sharedInstance];
    }
    return self;
}
#pragma mark - public Function
- (void)insertManagedObject:(id)data
{
    Entity *entity = [NSEntityDescription insertNewObjectForEntityForName:@"Entity"
                                                   inManagedObjectContext:[self.provider managedObjectContext]];
    entity.test = data;
//    [entity setValue:data forKey:@"title"];
//    [entity setValue:[NSDate date] forKey:@"date"];
}

- (NSArray *)selectAllManagedObject
{
    NSError *error = nil;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entity"
                                              inManagedObjectContext:[self.provider managedObjectContext]];
    [[self.provider fetchRequest] setEntity:entity];
    NSArray *array = [[self.provider managedObjectContext] executeFetchRequest:[self.provider fetchRequest]
                                                                         error:&error];
    if (error) {
        NSLog(@"读取失败");
        abort();
    }
    return array;
}

- (NSInteger)selectManagedObjectCount
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entity"
                                              inManagedObjectContext:[self.provider managedObjectContext]];
    [[self.provider fetchRequest] setEntity:entity];
    NSError *error = nil;
    NSInteger count = [[self.provider managedObjectContext] countForFetchRequest:[self.provider fetchRequest]
                                                                           error:&error];
    return count;
}

- (void)deleteManagedObject:(id)data
{
    [[self.provider managedObjectContext] deleteObject:data];
}

- (void)deleteAllManagedObject
{
    NSArray *array = [self selectAllManagedObject];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[self.provider managedObjectContext] deleteObject:obj];
    }];
}

- (void)saveManaged
{
    __block NSError *error = nil;
    [[self.provider managedObjectContext] performBlockAndWait:^{
        if (![[self.provider managedObjectContext] save:&error]) {
            NSLog(@"操作失败%@",error);
            abort();
        }
    }];
}

@end