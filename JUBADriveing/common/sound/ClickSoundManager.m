//
//  ClickSoundManager.m
//  lkNaPlayer
//
//  Created by le kan on 13-7-10.
//
//
#import <AudioToolbox/AudioToolbox.h>
#import "ClickSoundManager.h"
#import <AVFoundation/AVFoundation.h>

#define CLICK_SOUND_RESOURCE_PATH     @"click-2"
#define CLICK_SOUND_RESOURCE_TYPE     @"wav"


@implementation ClickSoundManager

//static SystemSoundID soundID = 0;
static AVAudioPlayer *player;

+ (void)initialize {
    [ClickSoundManager createClickSound];
}

+ (void)createClickSound {
    // NSString *path = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:CLICK_SOUND_RESOURCE_PATH ofType:CLICK_SOUND_RESOURCE_TYPE];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:CLICK_SOUND_RESOURCE_PATH ofType:CLICK_SOUND_RESOURCE_TYPE];
    // AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    
    // 判断是否可以访问这个文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        // 设置 player
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        // 调节音量 (范围从0到1)
        player.volume = 0.5f;
        // 准备buffer，减少播放延时的时间
        [player prepareToPlay];
        // 设置播放次数，0为播放一次，负数为循环播放
        [player setNumberOfLoops:0];
    }
}

+ (void)desposeClickSound {
    // AudioServicesDisposeSystemSoundID(soundID);
    
    if ([player isPlaying]) {
        [player stop];
    }
}

+ (void)play {
    // AudioServicesPlaySystemSound(soundID);
    [player play];
}

@end
