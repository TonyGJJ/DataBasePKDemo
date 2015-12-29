//
//  TestDataBase.m
//  DataBasePKDemo
//
//  Created by 刘杨 on 15/12/28.
//  Copyright © 2015年 TY. All rights reserved.
//

#import "RTestDataBase.h"

@implementation RTestDataBase

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

- (NSArray *)selectDataBase
{
    NSMutableArray *array = [NSMutableArray array];
    RLMResults *results = [RTestDataBase allObjects];
    for (int i = 0; i < results.count; i ++) {
        RTestDataBase *rTestDataBase = [results objectAtIndex:i];
        [array addObject:rTestDataBase];
        [array addObject:rTestDataBase];
    }
    return array;
}
@end
