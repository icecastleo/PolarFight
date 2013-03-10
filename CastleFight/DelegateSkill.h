//
//  DelegateSkill.h
//  CastleFight
//
//  Created by 朱 世光 on 13/3/11.
//
//

#import <Foundation/Foundation.h>

@class Character;
@interface DelegateSkill : NSObject {
    Character *character;
}

-(id)initWithCharacter:(Character *)aCharacter;
-(void)effectTarget:(Character *)target atPosition:(CGPoint)position;

@end
