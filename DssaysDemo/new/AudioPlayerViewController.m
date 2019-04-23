//
//  AudioPlayerViewController.m
//  DssaysDemo
//
//  Created by Block on 2019/4/23.
//  Copyright © 2019年 Block. All rights reserved.
//

#import "AudioPlayerViewController.h"

@interface AudioPlayerViewController () <AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *singer;
@property (weak, nonatomic) IBOutlet UIProgressView *playProgress;
@property (weak, nonatomic) IBOutlet UIButton *playPause;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, weak) NSTimer *timer; //进度更新定时器

@end

@implementation AudioPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"千年缘";
    self.singer.text = @"心然";

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //开启远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (NSTimer *)timer {
    if (nil == _timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    }
    return _timer;
}



- (AVAudioPlayer *)audioPlayer {
    if (nil == _audioPlayer) {
        NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"心然 - 千年缘.mp3" ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:urlStr];
        
        NSError *error = nil;
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        _audioPlayer.numberOfLoops = 0;
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];
        
        if (error) {
            NSLog(@"error = %@", error.localizedDescription);
            return nil;
        }
        
        //设置后台播放模式
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
        //添加通知，拔出耳机后暂停播放
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roteChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    }
    return _audioPlayer;
}

- (void)play {
    if (!self.audioPlayer.isPlaying) {
        [self.audioPlayer play];
        self.timer.fireDate = [NSDate distantPast]; //恢复定时器
    }
}

- (void)pause {
    if (self.audioPlayer.playing) {
        [self.audioPlayer pause];
        self.timer.fireDate = [NSDate distantFuture]; //暂停定时器，注意不能调用invalidate方法，此方法会取消，之后无法恢复
    }
}

- (IBAction)playClick:(UIButton *)sender {
    if(sender.tag){
        sender.tag=0;
        [sender setImage:[UIImage imageNamed:@"playing_btn_play_n"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"playing_btn_play_h"] forState:UIControlStateHighlighted];
        [self pause];
    }else{
        sender.tag=1;
        [sender setImage:[UIImage imageNamed:@"playing_btn_pause_n"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"playing_btn_pause_h"] forState:UIControlStateHighlighted];
        [self play];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}

#pragma mark -

- (void)updateProgress {
    [self.playProgress setProgress:(float)(self.audioPlayer.currentTime / self.audioPlayer.duration) animated:YES];
}

//一旦输出改变则执行此方法
- (void)roteChange:(NSNotification *)noti {
    NSDictionary *dic = noti.userInfo;
    int changeReaSon = [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    
    if (changeReaSon == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *description = dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDes = description.outputs.firstObject;
        
        if ([portDes.portType isEqualToString:@"Headphones"]) { //原设备为耳机则暂停
            [self pause];
        }
    }
}

#pragma mark - <AVAudioPlayerDelegate>
-  (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"finish ...");
    //根据实际情况播放完成可以将会话关闭，其他音频应用继续播放
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

@end
