//
//  BaseAI.h
//  CastleFight
//
//  Created by 陳 謙 on 13/3/4.
//
//

#import <Foundation/Foundation.h>
@class Character;
@class AIState;
typedef enum  {
    Walking,Battleing
} aiStateEnum;
@interface BaseAI : NSObject {
    __weak Character* character;
    aiStateEnum aiState;
    AIState * _currentState;
    CGPoint _targetPoint;
}
@property CGPoint targetPoint;
@property (readonly, weak) Character *character;
-(id)initWithCharacter:(Character *)aCharacter;
-(void)AIUpdate;
- (void)changeState:(AIState *)state;
@end
