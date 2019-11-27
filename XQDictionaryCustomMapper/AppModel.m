//
//  AppModel.m
//  ObjcDemo
//
//  Created by ticsmatic on 2019/11/18.
//  Copyright © 2019 ticsmatic. All rights reserved.
//

#import "AppModel.h"
#import "NSMutableDictionary+XQAdd.h"

@implementation AppModel

#pragma mark - XQDictionaryCustomMapper

+ (NSDictionary *)dictionaryCustomMapper {
    return @{
        @"name" : @"real_name",
        @"stu" : @[@"stu", @"student.name"],
        @"best_friend" : @"relationship.friends[0]",
        @"profile.nose.size" : @"nose_size",
        @"relationship.friends[1].name" : @"student.name",
    };
}

#pragma mark - YYModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"rc_user_id": @"rc.rc_user_id",
        @"rc_token": @"rc.rc_token",
    };
}

#pragma mark - MJExtension

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"page" : @"myp.p",
        @"name" : @[@"myp.p[0].name", @"p", @"school.name"],
    };
}

@end


@implementation Relationship
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"friends" : [Person class],
    };
}

@end


@implementation Person

@end


@implementation School

@end
