//
//  ViewController.m
//  DssaysDemo
//
//  Created by Block on 2019/4/18.
//  Copyright © 2019年 Block. All rights reserved.
//

#import "ViewController.h"
#import "SpeechViewController.h"
#import "AudioToolBoxViewController.h"
#import "AudioPlayerViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray *dataSource;

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
    
    self.dataSource = @[@{@"name" : @"speech", @"next" : @"SpeechViewController"},
                        @{@"name" : @"audio tool box", @"next" : @"AudioToolBoxViewController"},
                         @{@"name" : @"audio player", @"next" : @"AudioPlayerViewController"}];
    [self setupTableView];

}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:0];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    
}

#pragma mark

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:ID];
    }
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.textLabel.text = dic[@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSource[indexPath.row];
    NSString *nextStr = dic[@"next"];
    UIViewController *vc;
    if ([nextStr isEqualToString:@"AudioPlayerViewController"]) {
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"audioPlayer"];
    } else {
        vc = [NSClassFromString(nextStr) new];
    }
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark -

- (void)test {
    UIImage *spImage = [UIImage imageNamed:@"superman"];
    UIImage *moneyImage = [UIImage imageNamed:@"money"];
    CGSize spSize = spImage.size;
    CGSize mnSize = moneyImage.size;
    
    UIGraphicsBeginImageContext(spSize);
    [spImage drawInRect:CGRectMake(0, 0, spSize.width, spSize.height)];
    [moneyImage drawInRect:CGRectMake(0, 0, mnSize.width, mnSize.height)];
    
    UIImage *mergeImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageView *merView = [UIImageView new];
    merView.image = mergeImage;
    merView.frame = self.view.bounds;
    [self.view addSubview:merView];
}


@end
