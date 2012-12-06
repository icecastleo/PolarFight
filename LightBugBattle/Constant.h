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
    kCharacterAttributeHp,
} CharacterAttribute;

typedef enum {
    stateAttack,
    stateMove,
    stateIdle,
    stateDead
} CharacterState;

typedef enum {
    kCharacterDirectionUp = 1,
    kCharacterDirectionDown,
    kCharacterDirectionLeft,
    kCharacterDirectionRight
} CharacterDirection;

typedef enum {
    kAttackNoraml
} AttackType;

typedef enum {
    kArmorNoraml,
} ArmorType;

//typedef enum {
////    statusUnknown,
//    // TimeStatus
//    statusPoison,
//    
//    statusTypeLine = 50,
//    // AuraStatus
//    statusAttackBuff,
//} StatusType;

typedef enum {
    statusPoison,
} TimeStatusType;

typedef enum {
    statusAttackBuff,
} AuraStatusType;

typedef enum {
    ConditionMonsterAttack,
    
} ConditionType;

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
