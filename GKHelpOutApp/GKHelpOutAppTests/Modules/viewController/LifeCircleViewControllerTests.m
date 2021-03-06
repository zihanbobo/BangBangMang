//
//  LifeCircleViewControllerTests.m
//  GKHelpOutAppTests
//
//  Created by kky on 2019/9/2.
//  Copyright © 2019年 kky. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LifeCircleViewController.h"

@interface LifeCircleViewControllerTests : XCTestCase
@property(nonatomic,strong)LifeCircleViewController *lifeCircleVC;


@end

@implementation LifeCircleViewControllerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.lifeCircleVC = [[LifeCircleViewController alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.lifeCircleVC = nil;
}

- (void)testLifeCycle {
    [self.lifeCircleVC viewWillDisappear:YES];
    [self.lifeCircleVC viewDidLoad];
    [self.lifeCircleVC viewWillAppear:YES];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
