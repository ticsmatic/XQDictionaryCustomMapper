### 是什么
轻量级自定义NSDictionary内部映射，把某个key的值映射到另一个key上去

### 使用场景

1. 客户端在做服务器数据转模型时，当服务器返回的数据字段修改时，客户端做相应的做新老字段兼容性适配；

2. 客户端本地存储的用户数据在进行版本升级时，做字段的适配；

### 功能

* NSDictionary内部，从一个key的值映射到另一个key上； `@"name" : @"real_name"`
* 多个key时，取第一个非空值映射到另外一个key上；`@"stu" : @[@"stu", @"student.name", @"school.classs.name"]`
* 甚至支持key中包含数组标识符；`@"releationship.friends[1].name" : @"student.name"`
* 是字典转模型工具映射功能的补充，这里映射支持多层级、且支持层级内带数组标识


### 使用
```objc
@implementation Appmodel
+ (NSDictionary *)dictionaryCustomMapper {
    return @{@"name" : @"real_name",                            // 'real_name' ->  'name'
           @"stu" : @[@"stu", @"student.name"],                 // select first nonull value -> 'stu'
           @"best_friend" : @"releationship.friends[0]",        // arrays object 'name' -> 'best_friend'
           @"profile.nose.size" : @"nose_size",                 // 'nose_size' -> exit value and replace
           @"releationship.friends[1].name" : @"student.name",  // 'student.name' -> array object at index 1 'name'
    };
}
@end
```
在YYModel中有类似的方法
```objc
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"page" : @"releationship.friends",
        @"name" : @[@"releationship.friends[0].name", @"p", @"school.name"], // 不支持数组内带有'[]'的数组标识
        @"profile.nose.size" : @"nose_size",                                 // 不支持要映射到的key有多级
    };
}
```
在MJExtension中有类似的方法
```objc
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"page" : @"releationship.friends",
        @"name" : @[@"releationship.friends[0].name", @"p", @"school.name"],
        @"profile.nose.size" : @"nose_size",                                // 不支持要映射到的key有多级
        
    };
}
```

本人在这里做对比，无孰优孰略的之意，只是列举不同的实现方案

### 其它
当你的项目中已经包含有有类似YYModel、MJExtension等实现属性自定义映射的库，我更建议你使用这些三方工具。

当它们满足不了你的需求，比如说在被映射的key中包含层级结构、甚至数组标志，或者你需要一个轻量且抽象的做数据字段兼容性升级的工具，你可以考虑使用当前这个工具。

如果你有更好的建议，欢迎提出来。
