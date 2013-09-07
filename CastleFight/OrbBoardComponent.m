//
//  OrbBoardComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/8/14.
//
//

#import "OrbBoardComponent.h"
#import "FileManager.h"
#import "EntityFactory.h"
#import "OrbComponent.h"
#import "TouchComponent.h"
#import "RenderComponent.h"
#import "PlayerComponent.h"
#import "BattleDataObject.h"
#import "cocos2d.h"

typedef enum {
    kUp = 0,
    kLeft,
    kDown,
    kRight
} MatchWay;

@interface OrbBoardComponent() {
    int combos;
    int combosOrbSum; // only for test
    BattleDataObject *_battleData;
    int currentColumn;
    int currentPatternIndex;
    int iteration;
    NSArray *patterns;
    NSDictionary *randomOrbs;
    NSDictionary *currentPatternData;
}

@end

@implementation OrbBoardComponent

+(NSString *)name {
    static NSString *name = @"OrbBoardComponent";
    return name;
}

-(id)initWithEntityFactory:(EntityFactory *)entityFactory player:(Entity *)player aiPlayer:(Entity *)aiPlayer BattleData:(BattleDataObject *)battleData {
    if (self = [super init]) {
        
        _columns = [NSMutableArray arrayWithCapacity:kOrbBoardColumns];
        
        _entityFactory = entityFactory;
        combos = 0;
        _player = player;
        _aiPlayer = aiPlayer;
        _battleData = battleData;
        currentColumn = 0;
        currentPatternIndex = -1;
        iteration = 0;
        randomOrbs = [[FileManager sharedFileManager] getPatternDataWithPid:@"RandomOrbs"];
        currentPatternData = [[NSDictionary alloc] init];
    }
    return self;
}

-(void)moveOrb:(Entity *)orb toPosition:(CGPoint)position {
    
    RenderComponent *renderA = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
    
    int deltaX = position.x - renderA.node.position.x;
    int deltaY = position.y - renderA.node.position.y;
    
    // Not enough moved distance
    if (abs(deltaX) < kOrbWidth/2 && abs(deltaY) < kOrbHeight/2) {
        return;
    }
    
    // Add calculated path
    NSMutableArray *path = [[NSMutableArray alloc] init];
    
    int count;
    
    if (abs(deltaX) > abs(deltaY)) {
        count = abs(deltaX) / kOrbWidth + 1;
    } else {
        count = abs(deltaY) / kOrbHeight + 1;
    }
    
    float dx = deltaX / count;
    float dy = deltaY / count;
    
    for (int i = 1; i <= count; i++) {
        CGPoint position = ccp(renderA.position.x + i*dx, renderA.position.y + i*dy);
        [path addObject:[NSValue valueWithCGPoint:position]];
    }
    
//    for (int i=0; i<path.count; i++) {
//        CGPoint targetPosition = [(NSValue *)[path objectAtIndex:i] CGPointValue];
//        NSLog(@"position: %@",NSStringFromCGPoint(targetPosition));
//    }
    
    [self moveOrb:orb withPath:path];
}

-(void)moveOrb:(Entity *)orb withPath:(NSArray *)path {
    combos = 0;
    
    RenderComponent *renderA = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
    
    CGPoint orbPositionA = [self convertRenderPositionToOrbPosition:renderA.node.position];
    
    Entity *entityA = [self orbAtPosition:orbPositionA];
    
    // Orb system have not create orb yet! so we have to wait it!
    if (entityA != orb) {
        return;
    }
    
    for (int i = 0; i < path.count; i++) {
        CGPoint position = [[path objectAtIndex:i] CGPointValue];
        
        CGPoint orbPositionA = [self convertRenderPositionToOrbPosition:renderA.node.position];
        CGPoint orbPositionB = [self convertRenderPositionToOrbPosition:position];
        
        if (orbPositionA.x == orbPositionB.x && orbPositionA.y == orbPositionB.y) {
            continue;
        }
        
//        CCLOG(@"Position : %@ -> %@", NSStringFromCGPoint(renderA.node.position), NSStringFromCGPoint(position));
//        CCLOG(@"Orb Position : %@ -> %@", NSStringFromCGPoint(orbPositionA), NSStringFromCGPoint(orbPositionB));
        
        // Block inclined move
        if (ccpDistance(orbPositionA, orbPositionB) > 1) {
            NSAssert(ccpDistance(orbPositionA, orbPositionB) < 2, @"It should be square root of 2!");
            
            Entity *orb1 = [self orbAtPosition:ccp(orbPositionA.x, orbPositionB.y)];
            Entity *orb2 = [self orbAtPosition:ccp(orbPositionB.x, orbPositionA.y)];
            
            OrbComponent *orb1Com = (OrbComponent *)[orb1 getComponentOfName:[OrbComponent name]];
            OrbComponent *orb2Com = (OrbComponent *)[orb2 getComponentOfName:[OrbComponent name]];
            
            if (orb1Com.color != OrbNull && orb2Com.color != OrbNull ) {
                break;
            }
        }
        
        Entity *entityB = [self orbAtPosition:orbPositionB];
        RenderComponent *renderB = (RenderComponent *)[entityB getComponentOfName:[RenderComponent name]];

        OrbComponent *orbComponentB = (OrbComponent *)[entityB getComponentOfName:[OrbComponent name]];
        
        // Block
        if (orbComponentB.color != OrbNull) {
            break;
        }
                        
//        CCLOG(@"%f %f && %f %f",orbPositionA.x, orbPositionA.y, orbPositionB.x, orbPositionB.y);
//        CCLOG(@"%@ && %@",entityA , entityB);
        
        // Change orb
        CGPoint temp = renderB.node.position;
        renderB.node.position = renderA.node.position;
        renderA.node.position = temp;
        
        [[_columns objectAtIndex:orbPositionA.x] replaceObjectAtIndex:orbPositionA.y withObject:entityB];
        [[_columns objectAtIndex:orbPositionB.x] replaceObjectAtIndex:orbPositionB.y withObject:entityA];
    }
}

-(CGPoint)convertRenderPositionToOrbPosition:(CGPoint)position {
    int x = MAX(0, (position.x - kOrbBoradLeftMargin) / kOrbWidth - (kOrbBoardColumns - _columns.count));
    int y = MIN(kOrbBoardRows - 1, MAX(0, (position.y - kOrbBoradDownMargin) / kOrbHeight));
    
//    CCLOG(@"%f %f -> %d %d", position.x, position.y, x, y);
    
    return ccp(x, y);
}

-(Entity *)orbAtPosition:(CGPoint)position {
    if (position.x >= 0 && position.x < self.columns.count && position.y >= 0 && position.y < kOrbBoardRows) {
        return [[_columns objectAtIndex:position.x] objectAtIndex:position.y];
    }
    return nil;
}

-(NSArray *)searchOrbFromPosition:(CGPoint)position Way:(MatchWay)way OrbColor:(OrbColor)color {
    
    int currentColumns = self.columns.count;
    int currentX = position.x;
    int currentY = position.y;
    
    NSMutableArray *matchArray = [[NSMutableArray alloc] init];
    
    switch (way) {
        case kUp:
            for (int j=currentY+1; j<kOrbBoardRows; j++) {
                CGPoint orbPosition = ccp(currentX,j);
                Entity *orb = [self orbAtPosition:orbPosition];
                OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
                if (orbCom.color == color) {
                    orbCom.color = OrbNull;
                    
                    [matchArray addObjectsFromArray:[self searchOrbFromPosition:orbPosition Way:kLeft OrbColor:color]];
                    [matchArray addObjectsFromArray:[self searchOrbFromPosition:orbPosition Way:kRight OrbColor:color]];
                    
                    [matchArray addObject:orb];
                    break;
                }else if(orbCom.team == 2) {
                    orbCom.color = OrbNull;
                    [matchArray addObject:orb];
                    break;
                }else if(orbCom.color != OrbNull){
                    orbCom.color = OrbNull;
                    [matchArray addObject:orb];
                    break;
                }
            }
            break;
        case kLeft:
            for (int i=currentX-1; i>=0; i--) {
                CGPoint orbPosition = ccp(i,currentY);
                Entity *orb = [self orbAtPosition:orbPosition];
                OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
                if (orbCom.color == color) {
                    orbCom.color = OrbNull;
                    
                    [matchArray addObjectsFromArray:[self searchOrbFromPosition:orbPosition Way:kUp OrbColor:color]];
                    [matchArray addObjectsFromArray:[self searchOrbFromPosition:orbPosition Way:kDown OrbColor:color]];
                    
                    [matchArray addObject:orb];
                    break;
                }else if(orbCom.team == 2) {
                    orbCom.color = OrbNull;
                    [matchArray addObject:orb];
                    break;
                }else if(orbCom.color != OrbNull){
                    orbCom.color = OrbNull;
                    [matchArray addObject:orb];
                    break;
                }
            }
            break;
        case kDown:
            for (int j=currentY-1; j>=0; j--) {
                CGPoint orbPosition = ccp(currentX,j);
                Entity *orb = [self orbAtPosition:orbPosition];
                OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
                if (orbCom.color == color) {
                    orbCom.color = OrbNull;
                    
                    [matchArray addObjectsFromArray:[self searchOrbFromPosition:orbPosition Way:kLeft OrbColor:color]];
                    [matchArray addObjectsFromArray:[self searchOrbFromPosition:orbPosition Way:kRight OrbColor:color]];
                    
                    [matchArray addObject:orb];
                    break;
                }else if(orbCom.team == 2) {
                    orbCom.color = OrbNull;
                    [matchArray addObject:orb];
                    break;
                }else if(orbCom.color != OrbNull){
                    orbCom.color = OrbNull;
                    [matchArray addObject:orb];
                    break;
                }
            }
            break;
        case kRight:
            for (int i=currentX+1; i<currentColumns; i++) {
                CGPoint orbPosition = ccp(i,currentY);
                Entity *orb = [self orbAtPosition:orbPosition];
                OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
                if (orbCom.color == color) {
                    orbCom.color = OrbNull;
                    
                    [matchArray addObjectsFromArray:[self searchOrbFromPosition:orbPosition Way:kUp OrbColor:color]];
                    [matchArray addObjectsFromArray:[self searchOrbFromPosition:orbPosition Way:kDown OrbColor:color]];
                    
                    [matchArray addObject:orb];
                    break;
                }else if(orbCom.team == 2) {
                    orbCom.color = OrbNull;
                    [matchArray addObject:orb];
                    break;
                }else if(orbCom.color != OrbNull){
                    orbCom.color = OrbNull;
                    [matchArray addObject:orb];
                    break;
                }
            }
            break;
        default:
            return nil;
    }
    
    return matchArray;
}

-(NSDictionary *)findMatchForOrb:(Entity *)currentOrb {
    
    OrbComponent *currentOrbCom = (OrbComponent *)[currentOrb getComponentOfName:[OrbComponent name]];
    
    if (currentOrbCom.color == OrbNull || currentOrbCom.team == 2) {
        return nil;
    }
    
    RenderComponent *currentRenderCom = (RenderComponent *)[currentOrb getComponentOfName:[RenderComponent name]];
    CGPoint currentOrbPosition = [self convertRenderPositionToOrbPosition:currentRenderCom.node.position];
    int currentX = currentOrbPosition.x;
    int currentY = currentOrbPosition.y;
    
    Entity *upOrb = [self orbAtPosition:ccp(currentX,currentY+1)];
    Entity *leftOrb = [self orbAtPosition:ccp(currentX-1,currentY)];
    Entity *downOrb = [self orbAtPosition:ccp(currentX,currentY-1)];
    Entity *rightOrb = [self orbAtPosition:ccp(currentX+1,currentY)];
    
    OrbColor searchColor = currentOrbCom.color;
    
    NSMutableArray *matchArray = [[NSMutableArray alloc] init];
    [matchArray addObject:currentOrb];
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
            }else if(orbCom.team == 2) {
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

-(void)bombOrb:(NSMutableArray *)bombArray {
    NSMutableArray *removeArray = [[NSMutableArray alloc] init];
    
    for (NSMutableArray *array in bombArray) {
        if (array.count > 0) {
            Entity *orb = [array lastObject];
            [self cleanOrb:orb];
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

-(void)cleanOrb:(Entity *)orb {
    
    RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
    
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
    
    OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
    orbCom.color = OrbNull;
    if ([orb getComponentOfName:[TouchComponent name]]) {
        [orb removeComponent:[TouchComponent name]];
    }

}

-(void)matchClean:(NSDictionary *)matchDic {
    NSArray *matchArray = [matchDic objectForKey:kOrbMainMatch];
    NSArray *sameColorOrb = [matchDic objectForKey:kOrbSameColorMatch];
    NSArray *bombArray = [matchDic objectForKey:kOrbBombArray];
    combos++;
    PlayerComponent *playerCom = (PlayerComponent *)[self.player getComponentOfName:[PlayerComponent name]];
    playerCom.mana += kManaForEachCombo * combos;
    
    combosOrbSum = matchArray.count + sameColorOrb.count;
    
    [self showCombos];
    
    for (Entity *orb in matchArray) {
        [self cleanOrb:orb];
    }
    
    [self performSelector:@selector(bombOrb:) withObject:bombArray afterDelay:kOrbBombDelay];
}

-(void)showCombos {
    if ([self.entityFactory.mapLayer getChildByTag:kCombosLabelTag]) {
        [self.entityFactory.mapLayer removeChildByTag:kCombosLabelTag cleanup:YES];
    }
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    //test
    CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Combos: %d, sum: %d",combos,combosOrbSum] fontName:@"Helvetica" fontSize:30];
//    CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Combos: %d",combos] fontName:@"Helvetica" fontSize:30];
    
    label.color = ccRED;
    label.position =  ccp(winSize.width - label.boundingBox.size.width/2, kOrbBoradDownMargin + (kOrbBoardRows+1)*kOrbHeight);
    [self.entityFactory.mapLayer addChild:label z:INT16_MAX tag:kCombosLabelTag];
    
    [label runAction:
     [CCSequence actions:
      [CCFadeOut actionWithDuration:5.0f],
      [CCCallBlock actionWithBlock:^{
         combos = 0;
         [self.entityFactory.mapLayer removeChildByTag:kCombosLabelTag cleanup:YES];
     }],nil]];
}

-(NSMutableArray *)produceColumn:(NSArray *)originalColumn {
    NSMutableArray *nextColumn = [[NSMutableArray alloc] init];
    
    if (originalColumn.count == kOrbBoardRows) {
        int originalOrbSum = 0;
        for (int i=0; i<kOrbBoardRows; i++) {
            NSNumber *number = [originalColumn objectAtIndex:i];
            NSString *orbId = nil;
            if (number.intValue > 1000) { // defined range
                NSArray *randomArray = [randomOrbs objectForKey:number.stringValue];
                NSNumber *orbNumber = [randomArray objectAtIndex:arc4random_uniform(randomArray.count)];
                orbId = [NSString stringWithFormat:@"1%03d",orbNumber.intValue];
            }else if(number.intValue == -1) { // player's orb team
                NSNumber *orbNumber = [_battleData.playerOrbs objectAtIndex:arc4random_uniform(_battleData.playerOrbs.count)];
                orbId = [NSString stringWithFormat:@"1%03d",orbNumber.intValue];
            }else if(number.intValue == -2) { // enemy's orb team
                NSNumber *orbNumber = [_battleData.enemyOrbs objectAtIndex:arc4random_uniform(_battleData.enemyOrbs.count)];
                orbId = [NSString stringWithFormat:@"1%03d",orbNumber.intValue];
            }else if(number.intValue == -3) { // both
                NSMutableArray *randomArray = [[NSMutableArray alloc] init];
                [randomArray addObjectsFromArray:_battleData.playerOrbs];
                [randomArray addObjectsFromArray:_battleData.enemyOrbs];
                NSNumber *orbNumber = [randomArray objectAtIndex:arc4random_uniform(randomArray.count)];
                orbId = [NSString stringWithFormat:@"1%03d",orbNumber.intValue];
            }else {
                orbId = [NSString stringWithFormat:@"1%03d",number.intValue];
            }
            if (![orbId isEqualToString:kOrbNull]) {
                originalOrbSum++;
            }
            [nextColumn addObject:orbId];
        }
        
        int minOrb = [[currentPatternData objectForKey:@"minOrb"] intValue];
        int maxOrb = [[currentPatternData objectForKey:@"maxOrb"] intValue];
        int delta = maxOrb - minOrb;
        
        int orbSum = arc4random_uniform(delta+1) + minOrb;
        // turn off random
        orbSum = originalOrbSum;
        
        NSAssert(orbSum >= 0 && orbSum <= kOrbBoardRows, @"Range should be between 0 and rows.");
        
        if (orbSum > originalOrbSum) {
            int count = orbSum - originalOrbSum;
            
            do {
                for (int i=0; i<kOrbBoardRows; i++) {
                    NSString *orbId = [nextColumn objectAtIndex:i];
                    if ([orbId isEqualToString:kOrbNull]) {
                        if (arc4random_uniform(2) > 0) {
                            NSMutableArray *randomArray = [[NSMutableArray alloc] init];
                            [randomArray addObjectsFromArray:_battleData.playerOrbs];
                            [randomArray addObjectsFromArray:_battleData.enemyOrbs];
                            NSNumber *orbNumber = [randomArray objectAtIndex:arc4random_uniform(randomArray.count)];
                            orbId = [NSString stringWithFormat:@"1%03d",orbNumber.intValue];
                            [nextColumn replaceObjectAtIndex:i withObject:orbId];
                            count--;
                            if (count<=0) {
                                break;
                            }
                        }
                    }
                }
            } while (count>0);
            
        }else if (orbSum < originalOrbSum) {
            int count = originalOrbSum - orbSum;
            
            do {
                for (int i=0; i<kOrbBoardRows; i++) {
                    NSString *orbId = [nextColumn objectAtIndex:i];
                    if (![orbId isEqualToString:kOrbNull]) {
                        if (arc4random_uniform(2) > 0) {
                            orbId = kOrbNull;
                            [nextColumn replaceObjectAtIndex:i withObject:orbId];
                            count--;
                            if (count<=0) {
                                break;
                            }
                        }
                    }
                }
            } while (count>0);
        }
        
    }else {
        for (int i=0; i<kOrbBoardRows; i++) {
            NSMutableArray *randomArray = [[NSMutableArray alloc] init];
            [randomArray addObjectsFromArray:_battleData.playerOrbs];
            [randomArray addObjectsFromArray:_battleData.enemyOrbs];
            NSNumber *orbNumber = [randomArray objectAtIndex:arc4random_uniform(randomArray.count)];
            NSString *orbId = [NSString stringWithFormat:@"1%03d",orbNumber.intValue];
            if (arc4random_uniform(2) > 0) {
                orbId = kOrbNull;
            }
            
            [nextColumn addObject:orbId];
        }
        
    }
    
    return nextColumn;
}

-(NSArray *)producePattern {
    
    iteration--;
    if (iteration <= 0) {
        if (_battleData.patternRandom) {
            currentPatternIndex = arc4random_uniform(_battleData.patterns.count);
        }else {
            currentPatternIndex = (currentPatternIndex+1)%_battleData.patterns.count;
        }
        NSString *pid = [_battleData.patterns objectAtIndex:currentPatternIndex];
        currentPatternData = [[FileManager sharedFileManager] getPatternDataWithPid:pid];
        
        int minIteration = [[currentPatternData objectForKey:@"minIteration"] intValue];
        int maxIteration = [[currentPatternData objectForKey:@"maxIteration"] intValue];
        int delta = maxIteration - minIteration;
        
        iteration = arc4random_uniform(delta+1) + minIteration;
    }
    
    NSArray *originalPatterns = [currentPatternData objectForKey:@"patterns"];
    
    int minColumns = [[currentPatternData objectForKey:@"minColumns"] intValue];
    int maxColumns = [[currentPatternData objectForKey:@"maxColumns"] intValue];
    int deltaColumns = maxColumns - minColumns;
    
    int columns = arc4random_uniform(deltaColumns+1) + minColumns;
    
    int count = originalPatterns.count - columns;
    
    NSAssert(count >= 0 && count < originalPatterns.count, @"count can not over pattern's count");
    
    NSMutableArray *fixedPatterns = [[NSMutableArray alloc] init];
    for (int i=0; i<originalPatterns.count; i++) {
        NSMutableArray *column = [self produceColumn:[originalPatterns objectAtIndex:i]];
        [fixedPatterns addObject:column];
    }
    for (int i=0; i<count; i++) {
        [fixedPatterns removeObjectAtIndex:arc4random_uniform(fixedPatterns.count)];
    }
    
    int enemyOrbSum = 0;
    int playerOrbSum = 0;
    for (NSArray *column in fixedPatterns) {
        for(NSString *orbId in column) {
            int orbNum = orbId.intValue - 1000;
            if (orbNum > 100) { //enemy
                enemyOrbSum++;
            }else if (orbNum > 0){
                playerOrbSum++;
            }
        }
    }
    float orbSum = enemyOrbSum + playerOrbSum;
    float ratio = enemyOrbSum / orbSum;
    float defineRatio = _battleData.enemyOrbsRatio;
    CCLOG(@"define Ratio:%g, ratio:%g, enemy:%d, player:%d",defineRatio,ratio,enemyOrbSum,playerOrbSum);
    
    //turn off control ratio
//    ratio = defineRatio;
    
    if (defineRatio > ratio) { // need to increase enemy
        do {
            for (int i=0; i<fixedPatterns.count; i++) {
                NSMutableArray *column = [fixedPatterns objectAtIndex:i];
                for (int j=0; j<column.count; j++) {
                    NSString *orbId = [column objectAtIndex:j];
                    int orbNum = orbId.intValue - 1000;
                    if (orbNum > 0 && orbNum < 100) { // player's
                        if (arc4random_uniform(2) > 0) {
                            NSNumber *orbNumber = [_battleData.enemyOrbs objectAtIndex:arc4random_uniform(_battleData.enemyOrbs.count)];
                            orbId = [NSString stringWithFormat:@"1%03d",orbNumber.intValue];
                            [column replaceObjectAtIndex:j withObject:orbId];
                            enemyOrbSum++;
                            playerOrbSum--;
                            ratio = enemyOrbSum / orbSum;
                            if (ratio >= defineRatio) {
                                break;
                            }
                        }
                    }
                }
                if (ratio >= defineRatio) {
                    break;
                }
            }
        } while (defineRatio > ratio);
    }else if(defineRatio < ratio) { // need to decrease enemy
        do {
            for (int i=0; i<fixedPatterns.count; i++) {
                NSMutableArray *column = [fixedPatterns objectAtIndex:i];
                for (int j=0; j<column.count; j++) {
                    NSString *orbId = [column objectAtIndex:j];
                    int orbNum = orbId.intValue - 1000;
                    if (orbNum > 100) { // enemy's
                        if (arc4random_uniform(2) > 0) {
                            NSNumber *orbNumber = [_battleData.playerOrbs objectAtIndex:arc4random_uniform(_battleData.playerOrbs.count)];
                            orbId = [NSString stringWithFormat:@"1%03d",orbNumber.intValue];
                            [column replaceObjectAtIndex:j withObject:orbId];
                            playerOrbSum++;
                            enemyOrbSum--;
                            ratio = enemyOrbSum / orbSum;
                            if (ratio <= defineRatio) {
                                break;
                            }
                        }
                    }
                }
                if (ratio <= defineRatio) {
                    break;
                }
            }
        } while (defineRatio < ratio);
    }
    
    CCLOG(@"fix define Ratio:%g, ratio:%g, enemy:%d, player:%d",defineRatio,ratio,enemyOrbSum,playerOrbSum);
    
    return fixedPatterns;
}

-(NSArray *)nextColumn {
    currentColumn++;
    if (currentColumn >= patterns.count) {
        currentColumn = 0;
        patterns = [self producePattern];
    }
    return [patterns objectAtIndex:currentColumn];
}

@end
