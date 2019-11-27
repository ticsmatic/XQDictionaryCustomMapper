//
//  ViewController.m
//  ticsmatic
//
//  Created by ticsmatic on 2019/11/20.
//  Copyright © 2019 ticsmatic. All rights reserved.
//

#import "ViewController.h"
#import "NSMutableDictionary+XQAdd.h"
#import "AppModel.h"

@interface ViewController ()
@property (nonatomic, strong) NSData *responseData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self testCutomMapper];
}

- (void)testCutomMapper {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // Request data complete...
        self.responseData = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AppModel.json" ofType:nil]];
        // Additional mapper before create model
        NSDictionary *mappedData = [AppModel xq_customMapperWithJSON:self.responseData];
        
        // If needed, use model frame(like: YYModel, MJExtension, JSONModel, Mantle)
        // AppModel *model = [AppModel yy_modelWithJSON:mappedData];
        NSLog(@"%@", mappedData);
    });
}


@end
