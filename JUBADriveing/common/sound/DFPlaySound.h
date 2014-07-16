//
//  lkNaPlaySound.h
//  lkNaPlayer
//
//  Created by lekan_lyr on 13-12-2.
//
//

#import <Foundation/Foundation.h>

@interface DFPlaySound : NSObject

+ (DFPlaySound *)sharedInstance;
-(void)playSoundWithFileName:(NSString *)fileName;
-(void)stopPlay;
@end
