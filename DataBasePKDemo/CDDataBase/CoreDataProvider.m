//
//  CoreDataProvider.m
//  CoreDataPPT
//
//  Created by 刘杨 on 15/11/11.
//  Copyright © 2015年 TY. All rights reserved.
//

#import "CoreDataProvider.h"

@interface CoreDataProvider ()

@property (strong, nonatomic) NSManagedObjectContext       *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel         *managedObjectModel;
@property (strong, nonatomic) NSFetchRequest               *fetchRequest;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation CoreDataProvider

+ (instancetype)sharedInstance
{
    CoreDataProvider *provider = [[CoreDataProvider alloc] init];
    return provider;
}

#pragma mark - 属性设置
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    
    // 在主线程做
    _managedObjectContext = [[NSManagedObjectContext alloc]
                             initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@"YES",
                              NSInferMappingModelAutomaticallyOption:@"YES"};
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory]
                       URLByAppendingPathComponent:@"CoreDataModel.sqlite"];
    NSError *error = nil;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:options
                                                           error:&error]) {
        //NSLog(@"协调员创建失败");
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSDocumentDirectory
             inDomains:NSUserDomainMask]
            lastObject];
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle]
                       URLForResource:@"CoreDataModel"
                       withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSFetchRequest *)fetchRequest
{
    if (_fetchRequest) {
        return _fetchRequest;
    }
    _fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"test"
                                                                   ascending:YES];
    [_fetchRequest setSortDescriptors:@[sortDescriptor]];
    return _fetchRequest;
}
@end
