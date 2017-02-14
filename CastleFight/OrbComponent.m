//
//  OrbComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/8/14.
//
//

#import "OrbComponent.h"
#import "OrbBoardComponent.h"
#import "RenderComponent.h"
#import "PlayerComponent.h"
#import "Magic.h"

#import "SummonToLineMagic.h"

static int kOriginalOrbOpacity = 0.25 * 255;
static int kTouchOrbOpacity = 0.6 * 255;

@interface OrbComponent () {
    CCSprite *touchSprite;
    int tempOpacity;
}

@end

@implementation OrbComponent

+(NSString *)name {
    static NSString *name = @"OrbComponent";
    return name;
}

-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _originalColor = [[dic objectForKey:@"color"] intValue];
        _color = _originalColor;
        _isMovable = [[dic objectForKey:@"move"] boolValue];
        _isTappable = [[dic objectForKey:@"tap"] boolValue];
        _team = [[dic objectForKey:@"team"] intValue];
        _type = [dic objectForKey:@"type"];
    }
    return self;
}

-(void)handlePan:(PanState)state positions:(NSArray *)positions {
    if (!self.isMovable) {
        return;
    }
    if (state == kPanStateBegan) {
        RenderComponent *render = (RenderComponent *)[self.entity getComponentOfName:[RenderComponent name]];

        NSAssert([render.sprite isKindOfClass:[CCSprite class]], @"I think orb's sprite is ccsprite...");
        tempOpacity = [(CCSprite *)render.sprite opacity];
        [(CCSprite *)render.sprite setOpacity:kOriginalOrbOpacity];
        
        touchSprite = [CCSprite spriteWithTexture:[(CCSprite *)render.sprite texture] rect:[(CCSprite *)render.sprite textureRect]];
        touchSprite.scaleX = render.sprite.scaleX;
        touchSprite.scaleY = render.sprite.scaleY;
        touchSprite.position = [[positions lastObject] CGPointValue];
        [touchSprite setOpacity:kTouchOrbOpacity];
        [render.node.parent addChild:touchSprite z:INT16_MAX];
    } else if (state == kPanStateMoved) {
        CGPoint position = [[positions lastObject] CGPointValue];
        [self.board moveOrb:self.entity toPosition:position];
        
        touchSprite.position = position;
    } else if (state == kPanStateEnded) {
        RenderComponent *render = (RenderComponent *)[self.entity getComponentOfName:[RenderComponent name]];
        
        NSAssert([render.sprite isKindOfClass:[CCSprite class]], @"I think orb's sprite is ccsprite...");
        [(CCSprite *)render.sprite setOpacity:tempOpacity];
        
        [touchSprite removeFromParentAndCleanup:YES];
        touchSprite = nil;
    }
}

-(void)handleTap {
    if (!self.isTappable) {
        return;
    }
    NSDictionary *matchDic = [self findMatch];
    if (!matchDic) {
        return;
    }
    
    NSArray *matchArray = [matchDic objectForKey:kOrbMainMatch];
    NSArray *sameColorOrbs = [matchDic objectForKey:kOrbSameColorMatch];
    
    if ((matchArray.count+sameColorOrbs.count) >= kOrbMinMatchSum) {
        [self addToRecord:matchDic];
        [self executeMatch:matchArray.count];
        [self matchClean:matchDic];
    }
}

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    if (type == kEntityEventRemoveComponent) {
        if (touchSprite) {
            [touchSprite removeFromParentAndCleanup:YES];
        }
    }
}

-(void)executeMatch:(int)number {
    // TODO: Add mana here?
    
//    PlayerComponent *playerCom = (PlayerComponent *)[self.board.player getComponentOfName:[PlayerComponent name]];
//    
//    NSMutableDictionary *magicInfo = [[NSMutableDictionary alloc] init];
//    [magicInfo setValue:[playerCom.battleTeam objectAtIndex:self.type-1] forKey:@"SummonData"];
//    
//    int addLevel = 0;
//    switch (number) {
//        case 4:
//            addLevel += 1;
//            break;
//        case 5:
//            addLevel += 2;
//            break;
//        default:
//            break;
//    }
//    [magicInfo setValue:[NSNumber numberWithInt:addLevel] forKey:@"addLevel"];
//    //test
//    Magic *magic = [[SummonToLineMagic alloc] initWithMagicInformation:magicInfo];
//    magic.entityFactory = self.board.entityFactory;
//    [magic active];
}

#pragma mark Looking For Match

-(NSDictionary *)findMatch {
    
    if (self.color == OrbNull || self.team == kEnemyTeam) {
        return nil;
    }
    
    RenderComponent *currentRenderCom = (RenderComponent *)[self.entity getComponentOfName:[RenderComponent name]];
    CGPoint currentOrbPosition = [self.board convertRenderPositionToOrbPosition:currentRenderCom.node.position];
    int currentX = currentOrbPosition.x;
    int currentY = currentOrbPosition.y;
    
    Entity *upOrb = [self.board orbAtPosition:ccp(currentX,currentY+1)];
    Entity *leftOrb = [self.board orbAtPosition:ccp(currentX-1,currentY)];
    Entity *downOrb = [self.board orbAtPosition:ccp(currentX,currentY-1)];
    Entity *rightOrb = [self.board orbAtPosition:ccp(currentX+1,currentY)];
    
    OrbColor searchColor = self.color;
    
    NSMutableArray *matchArray = [[NSMutableArray alloc] init];
    [matchArray addObject:self.entity];
    NSMutableArray *wayArray = [[NSMutableArray alloc] init];
    
    if (upOrb) {
        OrbComponent *orbCom = (OrbComponent *)[upOrb getComponentOfName:[OrbComponent name]];
        if (orbCom.color == searchColor) {
            [matchArray addObject:upOrb];
            [wayArray addObject:[NSNumber numberWithInt:kUp]];
        }
    }
    
    if (leftOrb) {
        OrbComponent *orbCom = (OrbComponent *)[leftOrb getComponentOfName:[OrbComponent name]];
        if (orbCom.color == searchColor) {
            [matchArray addObject:leftOrb];
            [wayArray addObject:[NSNumber numberWithInt:kLeft]];
        }
    }
    
    if (downOrb) {
        OrbComponent *orbCom = (OrbComponent *)[downOrb getComponentOfName:[OrbComponent name]];
        if (orbCom.color == searchColor) {
            [matchArray addObject:downOrb];
            [wayArray addObject:[NSNumber numberWithInt:kDown]];
        }
    }
    
    if (rightOrb) {
        OrbComponent *orbCom = (OrbComponent *)[rightOrb getComponentOfName:[OrbComponent name]];
        if (orbCom.color == searchColor) {
            [matchArray addObject:rightOrb];
            [wayArray addObject:[NSNumber numberWithInt:kRight]];
        }
    }
    
    if (wayArray.count < 2) {
        [matchArray removeAllObjects];
        return nil;
    }
    
    for (Entity *orb in matchArray) {
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        orbCom.color = OrbNull;
    }
    
    NSMutableArray *bombArray = [[NSMutableArray alloc] init];
    for (NSNumber *way in wayArray) {
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:[self searchOrbFromPosition:currentOrbPosition Way:way.intValue OrbColor:searchColor]];
        
        for (Entity *orb in array) {
            OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
            orbCom.color = orbCom.originalColor;
        }
        
        [bombArray addObject:array];
    }
    
    // remove repeated orb
    for (NSMutableArray *array in bombArray) {
        if (array.count > 0) {
            Entity *orb = [array lastObject];
            for (NSMutableArray *array2 in bombArray) {
                if (array != array2) {
                    [array2 removeObject:orb];
                }
            }
        }
    }
    
    NSMutableArray *sameColorOrbs = [[NSMutableArray alloc] init];
    NSMutableArray *enemyOrbs = [[NSMutableArray alloc] init];
    NSMutableArray *otherColorOrbs = [[NSMutableArray alloc] init];
    
    for (NSArray *array in bombArray) {
        for (Entity *orb in array) {
            OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
            if (orbCom.color == searchColor) {
                [sameColorOrbs addObject:orb];
            }else if(orbCom.team == kEnemyTeam) {
                [enemyOrbs addObject:orb];
            }else {
                [otherColorOrbs addObject:orb];
            }
        }
    }
    
    for (Entity *orb in matchArray) {
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        orbCom.color = orbCom.originalColor;
    }
    
    CCLOG(@"mainMatchOrbs: %d, sameColorOrbs: %d, enemyOrbs: %d, otherColorOrbs: %d",matchArray.count,sameColorOrbs.count,enemyOrbs.count,otherColorOrbs.count);
    
    NSDictionary *matchDic = [[NSDictionary alloc] initWithObjectsAndKeys:matchArray,kOrbMainMatch,sameColorOrbs,kOrbSameColorMatch,enemyOrbs,kOrbEnemyMatch,otherColorOrbs,kOrbOtherMatch,bombArray,kOrbBombArray, nil];
    
    return matchDic;
}

-(NSArray *)searchOrbFromPosition:(CGPoint)position Way:(MatchWay)way OrbColor:(OrbColor)color {
    
    int currentColumns = self.board.columns.count;
    int currentX = position.x;
    int currentY = position.y;
    
    NSMutableArray *matchArray = [[NSMutableArray alloc] init];
    
    switch (way) {
        case kUp:
            for (int j=currentY+1; j<kOrbBoardRows; j++) {
                CGPoint orbPosition = ccp(currentX,j);
                Entity *orb = [self.board orbAtPosition:orbPosition];
                OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
                if (orbCom.color == color) {
                    orbCom.color = OrbNull;
                    
                    [matchArray addObjectsFromArray:[self searchOrbFromPosition:orbPosition Way:kLeft OrbColor:color]];
                    [matchArray addObjectsFromArray:[self searchOrbFromPosition:orbPosition Way:kRight OrbColor:color]];
                    
                    [matchArray addObject:orb];
                    break;
                }else if(orbCom.team == kEnemyTeam) {
                    orbCom.color = OrbNull;
                    [matchArray addObject:orb];
                    break;
                }
//                else if(orbCom.color != OrbNull){
//                    orbCom.color = OrbNull;
//                    [matchArray addObject:orb];
//                    break;
//                }
            }
            break;
        case kLeft:
            for (int i=currentX-1; i>=0; i--) {
                CGPoint orbPosition = ccp(i,currentY);
                Entity *orb = [self.board orbAtPosition:orbPosition];
                OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
                if (orbCom.color == color) {
                    orbCom.color = OrbNull;
                    
                    [matchArray addObjectsFromArray:[self searchOrbFromPosition:orbPosition Way:kUp OrbColor:color]];
                    [matchArray addObjectsFromArray:[self searchOrbFromPosition:orbPosition Way:kDown OrbColor:color]];
                    
                    [matchArray addObject:orb];
                    break;
                }else if(orbCom.team == kEnemyTeam) {
                    orbCom.color = OrbNull;
                    [matchArray addObject:orb];
                    break;
                }
//                else if(orbCom.color != OrbNull){
//                    orbCom.color = OrbNull;
//                    [matchArray addObject:orb];
//                    break;
//                }
            }
            break;
        case kDown:
            for (int j=currentY-1; j>=0; j--) {
                CGPoint orbPosition = ccp(currentX,j);
                Entity *orb = [self.board orbAtPosition:orbPosition];
                OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
                if (orbCom.color == color) {
                    orbCom.color = OrbNull;
                    
                    [matchArray addObjectsFromArray:[self searchOrbFromPosition:orbPosition Way:kLeft OrbColor:color]];
                    [matchArray addObjectsFromArray:[self searchOrbFromPosition:orbPosition Way:kRight OrbColor:color]];
                    
                    [matchArray addObject:orb];
                    break;
                }else if(orbCom.team == kEnemyTeam) {
                    orbCom.color = OrbNull;
                    [matchArray addObject:orb];
                    break;
                }
//                else if(orbCom.color != OrbNull){
//                    orbCom.color = OrbNull;
//                    [matchArray addObject:orb];
//                    break;
//                }
            }
            break;
        case kRight:
            for (int i=currentX+1; i<currentColumns; i++) {
                CGPoint orbPosition = ccp(i,currentY);
                Entity *orb = [self.board orbAtPosition:orbPosition];
                OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
                if (orbCom.color == color) {
                    orbCom.color = OrbNull;
                    
                    [matchArray addObjectsFromArray:[self searchOrbFromPosition:orbPosition Way:kUp OrbColor:color]];
                    [matchArray addObjectsFromArray:[self searchOrbFromPosition:orbPosition Way:kDown OrbColor:color]];
                    
                    [matchArray addObject:orb];
                    break;
                }else if(orbCom.team == kEnemyTeam) {
                    orbCom.color = OrbNull;
                    [matchArray addObject:orb];
                    break;
                }
//                else if(orbCom.color != OrbNull){
//                    orbCom.color = OrbNull;
//                    [matchArray addObject:orb];
//                    break;
//                }
            }
            break;
        default:
            return nil;
    }
    
    return matchArray;
}

#pragma mark clean orbs

-(void)matchClean:(NSDictionary *)matchDic {
    NSArray *matchArray = [matchDic objectForKey:kOrbMainMatch];
    NSArray *bombArray = [matchDic objectForKey:kOrbBombArray];
    
    for (Entity *orb in matchArray) {
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        [orbCom disappearAfterMatch];
    }
    
    [self performSelector:@selector(bombOrb:) withObject:bombArray afterDelay:kOrbBombDelay];
}

-(void)bombOrb:(NSMutableArray *)bombArray {
    NSMutableArray *removeArray = [[NSMutableArray alloc] init];
    
    for (NSMutableArray *array in bombArray) {
        if (array.count > 0) {
            Entity *orb = [array lastObject];
            OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
            [orbCom disappearAfterMatch];
            for (NSMutableArray *array2 in bombArray) {
                [array2 removeObject:orb];
            }
        }
        if (array.count == 0) {
            [removeArray addObject:array];
        }
    }
    
    [bombArray removeObjectsInArray:removeArray];
    
    if (bombArray.count > 0) {
        [self performSelector:@selector(bombOrb:) withObject:bombArray afterDelay:kOrbBombDelay];
    }
}

-(void)disappearAfterMatch {
    
    RenderComponent *orbRenderCom = (RenderComponent *)[self.entity getComponentOfName:[RenderComponent name]];
    
    CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:0];
    
    CCSpawn *spawn = [CCSpawn actions:[CCCallBlock actionWithBlock:^{
        CCSprite *sprite = [CCSprite spriteWithFile:@"explosion.png"];
        [orbRenderCom.node addChild:sprite];
        [sprite runAction:[CCSequence actions:
                           [CCScaleTo actionWithDuration:0.1 scaleX:2.0 scaleY:2.0],
                           fadeOut,
                           [CCCallBlock actionWithBlock:^{
            [sprite removeFromParentAndCleanup:YES];}],nil]];
    }],[CCScaleTo actionWithDuration:0.1 scaleX:0.1 scaleY:0.1], nil];
    
    [orbRenderCom.sprite runAction:
     [CCSequence actions:
      spawn,
      fadeOut,
      [CCCallBlock actionWithBlock:^{
         [orbRenderCom.node setVisible:NO];
     }],nil]];
    
    _color = OrbNull;
    _team = kNoTeam;
    [touchSprite removeFromParentAndCleanup:YES];
    touchSprite = nil;
    
    if ([self.entity getComponentOfName:[TouchComponent name]]) {
        [self.entity removeComponent:[TouchComponent name]];
    }
    
}

#pragma mark Record 
-(void)addToRecord:(NSDictionary *)matchDic {
    NSMutableArray *allOrbs = [[NSMutableArray alloc] initWithArray:[matchDic objectForKey:kOrbMainMatch]];
    [allOrbs addObjectsFromArray:[matchDic objectForKey:kOrbSameColorMatch]];
    [allOrbs addObjectsFromArray:[matchDic objectForKey:kOrbEnemyMatch]];
    [allOrbs addObjectsFromArray:[matchDic objectForKey:kOrbOtherMatch]];
    
    PlayerComponent *playerCom = (PlayerComponent *)[self.board.player getComponentOfName:[PlayerComponent name]];
    
    for (Entity *orb in allOrbs) {
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        [playerCom addCount:1 onOrbColor:orbCom.color];
    }
}

@end
