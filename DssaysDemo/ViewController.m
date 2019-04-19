//
//  ViewController.m
//  DssaysDemo
//
//  Created by Block on 2019/4/18.
//  Copyright © 2019年 Block. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"---->%@", [NSBundle mainBundle].infoDictionary);
    
    NSString *str = nil;
    
#if DEBUG
    
    str = @"debug";
    
#elif DistributionRelease
    
    str = @"distrib";
    
#else
    
    str = @"release";
    
#endif
    
    NSLog(@"----->%@", str);
}


@end
