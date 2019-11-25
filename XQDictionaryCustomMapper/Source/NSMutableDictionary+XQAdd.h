//
//  NSMutableDictionary+HHAdd.h
//  ticsmatic
//
//  Created by ticsmatic on 2019/11/20.
//  Copyright © 2019 ticsmatic. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (XQAdd)

/**
 Custom  mapper.
 
 @discussion If the key in customMapper contain '.' or '[]', ths code will alter dictionary's all collection type values  to mutable
 in order to make sure the values are changeable
 
 @param customMapper mapper
 
 Example:
  
 [mDict xq_customMapper:@{
     @"name" : @"real_name",                                                               // 'real_name' ->  'name'
     @"stu" : @[@"stu", @"student.name", @"school.classs.name"],    // select first nonull value -> 'stu'
     @"friend_first" : @"releationship.friends[0].name",                          // arrays object 'name' -> 'friend_first'
     @"profile.nose.size" : @"nose_size",                                               // 'nose_size' -> exit value and replace
     @"profile.eye.size" : @"eye_size",                                                   // 'eye_size' -> create 'eye' and 'size' at 'profile'
     @"releationship.friends[1].name" : @"student.name",                     // 'student.name' -> array object at index 1 'name'
 }];
 */
- (void)xq_customMapper:(NSDictionary *)customMapper;

@end

NS_ASSUME_NONNULL_END
