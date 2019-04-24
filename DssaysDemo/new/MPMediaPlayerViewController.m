//
//  MPMediaPlayerViewController.m
//  DssaysDemo
//
//  Created by Block on 2019/4/24.
//  Copyright © 2019年 Block. All rights reserved.
//

#import "MPMediaPlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MPMediaPlayerViewController () <MPMediaPickerControllerDelegate>

@property (nonatomic, strong) MPMediaPickerController *mediaPicker; //媒体选择控制器
@property (nonatomic,strong) MPMusicPlayerController *musicPlayer; //音乐播放器

@end

@implementation MPMediaPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)dealloc {
    [self.musicPlayer endGeneratingPlaybackNotifications];
}

- (MPMusicPlayerController *)musicPlayer {
    if (nil == _musicPlayer) {
        _musicPlayer = [MPMusicPlayerController systemMusicPlayer];
        [_musicPlayer beginGeneratingPlaybackNotifications]; //开启通知，否则监控不到MPMusicPlayerController的通知
        
    }
    
    return _musicPlayer;
}

- (MPMediaPickerController *)mediaPicker {
    if (!_mediaPicker) {
        _mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAny];
        _mediaPicker.allowsPickingMultipleItems = YES;
        _mediaPicker.prompt = @"请选择要播放的音乐";
        _mediaPicker.delegate = self;
    }
    return _mediaPicker;
}

/**
 *  取得媒体队列
 *
 *  @return 媒体队列
 */
- (MPMediaQuery *)getLocalMediaQuery {
    MPMediaQuery *queue = [MPMediaQuery songsQuery];
    for (MPMediaItem *item in queue.items) {
        NSLog(@"标题：%@,%@", item.title, item.albumTitle);
    }
    return queue;
}

/**
 *  取得媒体集合
 *
 *  @return 媒体集合
 */
-(MPMediaItemCollection *)getLocalMediaItemCollection{
    MPMediaQuery *mediaQueue=[MPMediaQuery songsQuery];
    NSMutableArray *array=[NSMutableArray array];
    for (MPMediaItem *item in mediaQueue.items) {
        [array addObject:item];
        NSLog(@"标题：%@,%@", item.title, item.albumTitle);
    }
    MPMediaItemCollection *mediaItemCollection= [[MPMediaItemCollection alloc]initWithItems:[array copy]];
    return mediaItemCollection;
}

#pragma mark -
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    MPMediaItem *item = mediaItemCollection.items.firstObject;
    NSLog(@"标题：%@,表演者：%@,专辑：%@", item.title, item.artist, item.albumTitle);
    [self.musicPlayer setQueueWithItemCollection:mediaItemCollection];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBackStateChange:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPlayer];
}

- (void)playBackStateChange:(NSNotification *)noti {
    switch (self.musicPlayer.playbackState) {
        case MPMusicPlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMusicPlaybackStatePaused:
            NSLog(@"播放暂停.");
            break;
        case MPMusicPlaybackStateStopped:
            NSLog(@"播放停止.");
            break;
        default:
            break;
    }
}

- (IBAction)selectClick:(id)sender {
    [self presentViewController:self.mediaPicker animated:YES completion:nil];
}
- (IBAction)playClick:(id)sender {
    [self.musicPlayer play];
}
- (IBAction)pauseClick:(id)sender {
    [self.musicPlayer pause];
}
- (IBAction)stopClick:(id)sender {
    [self.musicPlayer stop];
}
- (IBAction)nextClick:(id)sender {
    [self.musicPlayer skipToNextItem];
}
- (IBAction)prevClick:(id)sender {
    [self.musicPlayer skipToPreviousItem];
}


@end
