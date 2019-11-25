//
//  ViewController.m
//  ticsmatic
//
//  Created by ticsmatic on 2019/11/20.
//  Copyright © 2019 ticsmatic. All rights reserved.
//

#import "ViewController.h"
#import "NSMutableDictionary+XQAdd.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSDictionary *_result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configTestData];
    [self testCutomMapper];
}

- (void)configTestData {
    NSData *data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AppModel.json" ofType:nil]];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    _result = dict[@"data"];
}

- (void)testCutomMapper {
    NSMutableDictionary *mDict = _result.mutableCopy;
    
    [mDict xq_customMapper:@{
        @"name" : @"real_name", // 'real_name' ->  'name'
        @"stu" : @[@"stu", @"student.name", @"school.classs.name"], // select first nonull value -> 'stu'
        @"friend_first" : @"releationship.friends[0].name", // arrays object 'name' -> 'friend_first'
    }];
    
    NSLog(@"%@", mDict);
}

- (void)testCutomMapperWithNodeKey {
    NSMutableDictionary *mDict = _result.mutableCopy;
    
    [mDict xq_customMapper:@{
        @"profile.nose.size" : @"nose_size", // 'nose_size' -> exit value and replace
        @"profile.eye.size" : @"eye_size", // 'eye_size' -> create 'eye' and 'size' at 'profile'
        @"releationship.friends[1].name" : @"student.name", // 'student.name' -> array object at index 1 'name'
    }];
    
    NSLog(@"%@", mDict);
}

@end
