//
//  EffectType.h
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/30.
//
//

#import <Foundation/Foundation.h>
@class Character;

@interface Effect : NSObject {

}

-(void) doEffectFromCharacter:(Character*) aCharacter toCharacter:(Character*)bCharacter;

@end