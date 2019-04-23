//
//  AudioToolBoxViewController.m
//  DssaysDemo
//
//  Created by Block on 2019/4/23.
//  Copyright © 2019年 Block. All rights reserved.
//

#import "AudioToolBoxViewController.h"

@interface AudioToolBoxViewController ()

@end

@implementation AudioToolBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self playSoundEffect:@"videoRing.caf"];

}

- (void)playSoundEffect:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    if (path == nil) return;
    NSURL *url = [NSURL fileURLWithPath:path];
    
    //1.获得系统声音ID
    SystemSoundID soundID = 0;
    /**
     * inFileUrl:音频文件url
     * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundID);
    //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallBack, NULL);
    //2.播放音频
//    AudioServicesPlayAlertSound(soundID);
    AudioServicesPlaySystemSound(soundID);
}

void soundCompleteCallBack(SystemSoundID soundID, void *clientData) {
    NSLog(@"播放完成");
}


@end
