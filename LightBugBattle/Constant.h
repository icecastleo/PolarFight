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
    test1,
    test2
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
    role1Tag,
    role2Tag,
    role3Tag,
    role4Tag,
    role5Tag,
    role6Tag,
    role7Tag,
    role8Tag,
    role9Tag,
    role10Tag,
    mainRoleTag = 1001
} RolesTag;

typedef enum {
    level1,
    level2,
    level3
} Levels;

#endif
