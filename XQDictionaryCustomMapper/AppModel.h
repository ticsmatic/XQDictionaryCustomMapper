//
//  AppModel.h
//  ObjcDemo
//
//  Created by ticsmatic on 2019/11/18.
//  Copyright © 2019 ticsmatic. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class School, Relationship;

@interface AppModel : NSObject

@property (nonatomic, copy) NSString *user_id;                                  ///< 用户ID
@property (nonatomic, copy) NSString *name;                                     ///< 用户名
@property (nonatomic, copy) NSString *avatar;                                   ///< 头像url xxx_d.png 代表使用的是默认头像
@property(nonatomic, copy) NSString *token;                                     ///< 用户token
@property(nonatomic, copy) NSString *real_name;                                 ///< 真实名称
@property(nonatomic, copy) NSString *subject;                                   ///< 科目
@property(nonatomic, copy) NSString *grade;                                     ///< 年级
@property(nonatomic, assign) NSTimeInterval created_at;                         ///< 注册时间
@property (nonatomic, assign) BOOL password_unsettled;
@property(nonatomic, copy) NSString *rc_token;
@property(nonatomic, copy) NSString *rc_user_id;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, strong) School *school;
@property (nonatomic, strong) Relationship *relationship;

@end


@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

@end


@interface Relationship : NSObject

@property (nonatomic, copy) NSArray<Person *> *friends;
@end


@interface School : NSObject

@property (nonatomic, copy) NSString *name;                                     ///< 学校名称
@property (nonatomic, copy) NSString *school_id;                                ///< 学校级id

@end

NS_ASSUME_NONNULL_END
