//
//  Constant.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/31.
//
//

#ifndef LightBugBattle_Constant_h
#define LightBugBattle_Constant_h

typedef enum {
    Hero = 0,
    Soldier,
    Monster
} CharacterType;

typedef enum {
    stateAttack,
    stateMove,
    stateIdle,
    stateDead
} SpriteStates;

typedef enum {
    directionUp,
    directionDown,
    directionLeft,
    directionRight
} SpriteDirections;

typedef enum {
    statusUnknown,
    statusPoison,
} StatusType;

typedef enum {
    level1 = 0,
    level2,
    level3
} Levels;

typedef enum {
    player1 = 1,
    player2 = 2
} Players;

#endif
