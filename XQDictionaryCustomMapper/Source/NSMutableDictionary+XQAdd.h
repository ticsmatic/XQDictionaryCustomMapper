//
//  NSMutableDictionary+HHAdd.h
//  ticsmatic
//
//  Created by ticsmatic on 2019/11/20.
//  Copyright © 2019 ticsmatic. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XQDictionaryCustomMapper <NSObject>
@optional
/**
 Custom dictionary mapper
 
 @discussion If the key in JSON/Dictionary does not match to the model's property name,
 and if your model framework are not support nesting mapper style, you need this.
 implements this method and returns the additional mapper..
 
 Example:
    
    json:
        {
            "name": "王易烊",
            "real_name": "ticsmatic",
            "stu": null,
            "relationship": {
                "friends": [{
                        "name": "小红",
                        "age": 5
                    },
                    {
                        "name": "小明",
                        "age": 7
                    }
                ]
            },
            "student": {
                "name": "好孩子"
            },
            "profile": {
                "nose":{
                    "size": "big"
                }
            },
            "nose_size": "j",
            "ID": 100010
        }
 
    model:
 
        @implementation Appmodel
        + (NSDictionary *)dictionaryCustomMapper {
            return @{@"name" : @"real_name",                                             // 'real_name' ->  'name'
                   @"stu" : @[@"stu", @"student.name"],                         // select first nonull value -> 'stu'
                   @"best_friend" : @"releationship.friends[0]",                // arrays object 'name' -> 'friend_first'
                   @"profile.nose.size" : @"nose_size",                            // 'nose_size' -> exit value and replace
                   @"releationship.friends[1].name" : @"student.name",  // 'student.name' -> array object at index 1 'name'
            };
        }
        @end
 
 */
+ (nullable NSDictionary<NSString *, id> *)dictionaryCustomMapper;

@end


@interface NSObject (XQAdd)

/**
Creates and returns a new instance of the receiver from a json.

@param json  A json object in `NSDictionary`, `NSString` or `NSData`.

@return A dictionary instance created and custom mapper from the json,  or nil if an error occurs.
*/
+ (NSDictionary *)xq_customMapperWithJSON:(id)json;

@end


@interface NSMutableDictionary (XQAdd)

/**
 Custom  mapper.
 
 @discussion If the key in customMapper contain '.' or '[]', ths code will alter dictionary's all collection type values  to mutable
 in order to make sure the values are changeable
 
 @param customMapper mapper
 
 Example:
  
 [mDict xq_customMapper:@{
        @"name" : @"real_name",                                             // 'real_name' ->  'name'
        @"stu" : @[@"stu", @"student.name"],                         // select first nonull value -> 'stu'
        @"best_friend" : @"releationship.friends[0]",                // arrays object 'name' -> 'friend_first'
        @"profile.nose.size" : @"nose_size",                            // 'nose_size' -> exit value and replace
        @"releationship.friends[1].name" : @"student.name",  // 'student.name' -> array object at index 1 'name'
 };
 */
- (void)xq_customMapper:(NSDictionary *)customMapper;

@end

NS_ASSUME_NONNULL_END
