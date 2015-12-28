//
//  TestDataBase.h
//  DataBasePKDemo
//
//  Created by 刘杨 on 15/12/28.
//  Copyright © 2015年 TY. All rights reserved.
//

#import <Realm/Realm.h>

@interface RTestDataBase : RLMObject
@property NSString *text;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<TestDataBase>
RLM_ARRAY_TYPE(TestDataBase)
