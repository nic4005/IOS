//
//  lkNaPlaySound.m
//  lkNaPlayer
//
//  Created by lekan_lyr on 13-12-2.
//
//

#import "DFPlaySound.h"
#import <AVFoundation/AVFoundation.h>
@interface DFPlaySound(){
    AVAudioPlayer *player;
}

@end


@implementation DFPlaySound

static DFPlaySound *sharedInstance_ = nil;

+ (DFPlaySound *)sharedInstance
{
    return sharedInstance_;
}

+ (void)initialize
{
    if (self == [DFPlaySound class]) {
        //
        sharedInstance_ = [NSAllocateObject([self class], 0, NULL)init];
    }
}

-(void)playSoundWithFileName:(NSString *)fileName{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mp3"];
    // AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    
    // 判断是否可以访问这个文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        player.volume = 0.5f;
    
        [player prepareToPlay];
    
        [player setNumberOfLoops:0];
    }
    [player play];
}

-(void)stopPlay{
    if ([player isPlaying]) {
        [player stop];
    }
    [player release];
}

-(void)dealloc{
    
    [player release];
    
    [super dealloc];
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedInstance] retain];
}

+ (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (oneway void)release
{
    
}

- (id)autorelease
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (void)operation
{
    NSLog(@"%@",self);
}
@end
