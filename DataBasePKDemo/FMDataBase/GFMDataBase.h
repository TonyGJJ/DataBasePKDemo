//
//  GFMDataBase.h
//  DataBasePKDemo
//
//  Created by 刘杨 on 15/12/23.
//  Copyright © 2015年 TY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GFMDataBase : NSObject

+ (instancetype)sharedInstance;
- (void)dataBasePath;
- (void)insertData:(NSString *)str;
- (void)deleteData:(NSString *)str;
- (NSArray *)selectData;
@end
