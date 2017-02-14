//
//  SimpleAudioEngine+VibrateExtend.m
//  CastleFight
//
//  Created by 朱 世光 on 13/7/2.
//
//

#import "SimpleAudioEngine+VibrateExtend.h"

@implementation SimpleAudioEngine (VibrateExtend)

-(void)vibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
