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

@interface OrbBoardComponent() {
    // Only used for very short period board time to adjust orb position!
    int columnsShift;
    
    //for combos
    int combos;
    
    // for patterns
    BattleDataObject *_battleData;
    int currentColumn;
    int currentPatternIndex;
    int iteration;
    NSArray *patterns;
    NSDictionary *randomOrbs;
    NSDictionary *currentPatternData;
    NSDictionary *allOrbRatioDic;
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
        _maxColumns = kOrbBoardColumns;
        
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
        
        NSMutableDictionary *allDic = [NSMutableDictionary dictionaryWithDictionary:battleData.playerOrbs];
        [allDic addEntriesFromDictionary:battleData.enemyOrbs];
        allOrbRatioDic = allDic;
    }
    return self;
}

-(void)setTimeCountdown:(float)timeCountdown {
    if (timeCountdown <= 0) {
        columnsShift = _maxColumns - _columns.count;
    }
    
    _timeCountdown = timeCountdown;
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
        
        // Change orb with invalid position
        if (entityB == nil) {
            break;
        }
        
        OrbComponent *orbComponentB = (OrbComponent *)[entityB getComponentOfName:[OrbComponent name]];
        
        // Block
        if (orbComponentB.color != OrbNull) {
            break;
        }
                        
        RenderComponent *renderB = (RenderComponent *)[entityB getComponentOfName:[RenderComponent name]];
        
        // Change orb
        CGPoint temp = renderB.node.position;
        renderB.node.position = renderA.node.position;
        renderA.node.position = temp;
        
        [[_columns objectAtIndex:orbPositionA.x] replaceObjectAtIndex:orbPositionA.y withObject:entityB];
        [[_columns objectAtIndex:orbPositionB.x] replaceObjectAtIndex:orbPositionB.y withObject:entityA];
    }
}

-(CGPoint)convertRenderPositionToOrbPosition:(CGPoint)position {
    int x = 0;
    int y = 0;
    
    if (_timeCountdown > 0) {
        x = MAX(0, (position.x - kOrbBoradLeftMargin) / kOrbWidth - (_maxColumns - _columns.count));
        y = MIN(kOrbBoardRows - 1, MAX(0, (position.y - kOrbBoradDownMargin) / kOrbHeight));
    } else {
        x = MAX(0, (position.x - kOrbBoradLeftMargin) / kOrbWidth - columnsShift);
        y = MIN(kOrbBoardRows - 1, MAX(0, (position.y - kOrbBoradDownMargin) / kOrbHeight));
    }
    
//    CCLOG(@"%f %f -> %d %d", position.x, position.y, x, y);
    
    return ccp(x, y);
}

-(Entity *)orbAtPosition:(CGPoint)position {
    if (position.x >= 0 && position.x < self.columns.count && position.y >= 0 && position.y < kOrbBoardRows) {
        return [[_columns objectAtIndex:position.x] objectAtIndex:position.y];
    }
    
    return nil;
}

#pragma mark Record & Show Combos
// might move to other place

-(void)showCombos {
    
    combos++;
    PlayerComponent *playerCom = (PlayerComponent *)[self.player getComponentOfName:[PlayerComponent name]];
    playerCom.mana += kManaForEachCombo * combos;
    
    if ([self.entityFactory.mapLayer getChildByTag:kCombosLabelTag]) {
        [self.entityFactory.mapLayer removeChildByTag:kCombosLabelTag cleanup:YES];
    }
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Combos: %d",combos] fontName:@"Helvetica" fontSize:30];
    
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

#pragma mark create columns and patterns

-(NSString *)randomOrbFromRatioDictionary:(NSDictionary *)ratioDictionary {
    
    NSString *orbId = nil;
    
    int ratioSum = 0;
    for (NSNumber *ratio in ratioDictionary.allValues) {
        ratioSum += ratio.intValue;
    }
    
    int random = arc4random_uniform(ratioSum) + 1;
    
    for (NSString *key in ratioDictionary.allKeys) {
        NSNumber *ratio = [ratioDictionary objectForKey:key];
        random -= ratio.intValue;
        if (random <= 0) {
            orbId = [NSString stringWithFormat:@"1%03d",key.intValue];
            break;
        }
    }
    NSAssert(orbId!=nil, @"not found orbKey");
    
    return orbId;
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
            }else if(number.intValue == kPlayerTeam*-1) { // player's orb team
                orbId = [self randomOrbFromRatioDictionary:_battleData.playerOrbs];
            }else if(number.intValue == kEnemyTeam*-1) { // enemy's orb team
                orbId = [self randomOrbFromRatioDictionary:_battleData.enemyOrbs];
            }else if(number.intValue == kAllTeam*-1) { // both
                orbId = [self randomOrbFromRatioDictionary:allOrbRatioDic];
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
        
        // do not adjust orb num when they are negative.
        if (minOrb >= 0 && maxOrb >= 0) {
            int delta = maxOrb - minOrb;
            int orbSum = arc4random_uniform(delta+1) + minOrb;
            
            NSAssert(orbSum >= 0 && orbSum <= kOrbBoardRows, @"Range should be between 0 and rows.");
            
            if (orbSum > originalOrbSum) {
                int count = orbSum - originalOrbSum;
                
                do {
                    for (int i=0; i<kOrbBoardRows; i++) {
                        NSString *orbId = [nextColumn objectAtIndex:i];
                        if ([orbId isEqualToString:kOrbNull]) {
                            if (arc4random_uniform(2) > 0) {
                                orbId = [self randomOrbFromRatioDictionary:allOrbRatioDic];
                                
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
        }
        
    }else {
        for (int i=0; i<kOrbBoardRows; i++) {
            NSString *orbId = [self randomOrbFromRatioDictionary:allOrbRatioDic];
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
    
    //Adjust sum of enemy's orb according to the enemyOrbsRatio
    int enemyOrbSum = 0;
    int playerOrbSum = 0;
    for (NSArray *column in fixedPatterns) {
        for(NSString *orbId in column) {
            int orbNum = orbId.intValue - kOrbNull.intValue;
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
//    CCLOG(@"define Ratio:%g, ratio:%g, enemy:%d, player:%d",defineRatio,ratio,enemyOrbSum,playerOrbSum);
    
    if (defineRatio > ratio) { // need to increase enemy
        do {
            for (int i=0; i<fixedPatterns.count; i++) {
                NSMutableArray *column = [fixedPatterns objectAtIndex:i];
                for (int j=0; j<column.count; j++) {
                    NSString *orbId = [column objectAtIndex:j];
                    int orbNum = orbId.intValue - kOrbNull.intValue;
                    if (orbNum > 0 && orbNum <= 100) { // player's
                        if (arc4random_uniform(2) > 0) {
                            orbId = [self randomOrbFromRatioDictionary:_battleData.enemyOrbs];
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
                    int orbNum = orbId.intValue - kOrbNull.intValue;
                    if (orbNum > 100) { // enemy's
                        if (arc4random_uniform(2) > 0) {
                            orbId = [self randomOrbFromRatioDictionary:_battleData.playerOrbs];
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
    
//    CCLOG(@"fix define Ratio:%g, ratio:%g, enemy:%d, player:%d",defineRatio,ratio,enemyOrbSum,playerOrbSum);
    
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
