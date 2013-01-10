//
//  CharacterInfoView.h
//  LightBugBattle
//
//  Created by  浩翔 on 13/1/4.
//
//

#import "CCLayer.h"

@class Character;

@interface CharacterInfoView : CCLayer

- (void)showInfoFromCharacter:(Character *)role loacation:(CGPoint)point;
- (void)clean;
@end
