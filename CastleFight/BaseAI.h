//
//  BaseAI.h
//  CastleFight
//
//  Created by 陳 謙 on 13/3/4.
//
//

#import <Foundation/Foundation.h>
@class Character;
typedef enum  {
    Walking,Battleing
} aiStateEnum;
@interface BaseAI : NSObject {
    __weak Character* character;
     aiStateEnum aiState;
}

@property (readonly, weak) Character *character;
-(id)initWithCharacter:(Character *)aCharacter;
-(void)AIUpdate;
@end
