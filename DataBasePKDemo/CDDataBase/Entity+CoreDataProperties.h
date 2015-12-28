//
//  Entity+CoreDataProperties.h
//  DataBasePKDemo
//
//  Created by 刘杨 on 15/12/28.
//  Copyright © 2015年 TY. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Entity.h"

NS_ASSUME_NONNULL_BEGIN

@interface Entity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *test;

@end

NS_ASSUME_NONNULL_END
