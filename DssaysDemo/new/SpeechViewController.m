//
//  SpeechViewController.m
//  DssaysDemo
//
//  Created by Block on 2019/4/22.
//  Copyright © 2019年 Block. All rights reserved.
//

#import "SpeechViewController.h"

@interface SpeechViewController ()<AVSpeechSynthesizerDelegate>

@property (nonatomic, copy) NSArray *speechStrings;
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;

@end

@implementation SpeechViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.synthesizer.delegate = self;
    
    [self beginSpeech];
    
}

- (NSArray *)speechStrings {
    return @[@"多拉点法拉法律",
             @"慈恩奥恩",
             @"俺怕套路你发偶尔"];
}

- (AVSpeechSynthesizer *)synthesizer {
    if (nil == _synthesizer) {
        _synthesizer = [AVSpeechSynthesizer new];
        
    }
    return _synthesizer;
}

- (void)beginSpeech {
    for (int i = 0; i < self.speechStrings.count; i++) {
        NSLog(@"-->%@", self.speechStrings[i]);
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:self.speechStrings[i]];
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-cn"];
        utterance.rate = 0.5;
        utterance.pitchMultiplier = 0.8;
        utterance.postUtteranceDelay = 0.1;
        [self.synthesizer speakUtterance:utterance];
    }
}

#pragma mark -
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance {
    NSLog(@"====>%@", utterance.speechString);
}


@end
