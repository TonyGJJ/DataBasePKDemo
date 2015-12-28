//
//  CoreDataProvider.h
//  CoreDataPPT
//
//  Created by 刘杨 on 15/11/11.
//  Copyright © 2015年 TY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataProvider : NSObject
+ (instancetype)sharedInstance;

- (NSManagedObjectContext *)managedObjectContext;
- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSFetchRequest *)fetchRequest;

@end
