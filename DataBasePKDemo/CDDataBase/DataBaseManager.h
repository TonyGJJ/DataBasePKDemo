//
//  DataBaseManager.h
//  CoreDataPPT
//
//  Created by 刘杨 on 15/11/11.
//  Copyright © 2015年 TY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseManager : NSObject

/**
 *  初始化
 *
 *  @return DataBaseManager
 */
+ (instancetype)sharedInstance;

/**
 *  插入数据
 *
 *  @param data 需要保存的数据
 */
- (void)insertManagedObject:(id)data;

/**
 *  查询数据
 *
 *  @return 查询到的数据
 */
- (NSArray *)selectAllManagedObject;

/**
 *  查询本地数据条数
 *
 *  @return 总条数
 */
- (NSInteger)selectManagedObjectCount;
/**
 *  删除数据
 *
 *  @param data 需要删除的数据
 */
- (void)deleteManagedObject:(id)data;
- (void)deleteAllManagedObject;
/**
 *  保存插入和删除的数据
 */
- (void)saveManaged;
@end
