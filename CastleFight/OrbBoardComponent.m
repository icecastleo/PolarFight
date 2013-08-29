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
    int combos;
    int combosOrbSum; // only for test
    BattleDataObject *_battleData;
    int currentColumn;
    int currentPattern;
    int iteration;
    NSArray *patterns;
    NSDictionary *randomOrbs;
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
        currentPattern = -1;
        iteration = 0;
        randomOrbs = [[FileManager sharedFileManager] getPatternDataWithPid:@"RandomOrbs"];
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
        
        Entity *entityB = [self orbAtPosition:orbPositionB];
        RenderComponent *renderB = (RenderComponent *)[entityB getComponentOfName:[RenderComponent name]];
        
        OrbComponent *orbComponentB = (OrbComponent *)[entityB getComponentOfName:[OrbComponent name]];
        
        // Block
        if (orbComponentB.type != OrbNull) {
            break;
        }
        
        // Block inclined move
        if (ccpDistance(orbPositionA, orbPositionB) > 1) {
            Entity *orb1 = [self orbAtPosition:ccp(orbPositionA.x, orbPositionB.y)];
            Entity *orb2 = [self orbAtPosition:ccp(orbPositionB.x, orbPositionA.y)];
            
            OrbComponent *orb1Com = (OrbComponent *)[orb1 getComponentOfName:[OrbComponent name]];
            OrbComponent *orb2Com = (OrbComponent *)[orb2 getComponentOfName:[OrbComponent name]];
            
            if (orb1Com.type != OrbNull && orb2Com.type != OrbNull ) {
                break;
            }
        }
        
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
    return [[_columns objectAtIndex:position.x] objectAtIndex:position.y];
}

-(NSArray *)findMatchForOrb:(Entity *)currentOrb {
    
    OrbComponent *currentOrbCom = (OrbComponent *)[currentOrb getComponentOfName:[OrbComponent name]];
    RenderComponent *currentRenderCom = (RenderComponent *)[currentOrb getComponentOfName:[RenderComponent name]];
    
    if (currentOrbCom.type == OrbNull || currentOrbCom.type == OrbPurple) {
        return nil;
    }
    NSMutableArray *matchXArray = [[NSMutableArray alloc] init];
    NSMutableArray *matchYArray = [[NSMutableArray alloc] init];
    
    CGPoint currentOrbPosition = [self convertRenderPositionToOrbPosition:currentRenderCom.node.position];
    int currentX = currentOrbPosition.x;
    int currentY = currentOrbPosition.y;
    int currentColumns = self.columns.count;
    
    //left way
    for (int i=currentX-1; i>=0; i--) {
        Entity *orb = [self orbAtPosition:ccp(i,currentY)];
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        if (orbCom.type == currentOrbCom.type) {
            [matchXArray addObject:orb];
        }else {
            break;
        }
    }
    
    //right way
    for (int i=currentX; i<currentColumns; i++) {
        Entity *orb = [self orbAtPosition:ccp(i,currentY)];
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        if (orbCom.type == currentOrbCom.type) {
            [matchXArray addObject:orb];
        }else {
            break;
        }
    }
    
    //up way
    for (int j=currentY; j<kOrbBoardRows; j++) {
        Entity *orb = [self orbAtPosition:ccp(currentX,j)];
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        if (orbCom.type == currentOrbCom.type) {
            [matchYArray addObject:orb];
        }else {
            break;
        }
    }
    
    //down way
    for (int j=currentY-1; j>=0; j--) {
        Entity *orb = [self orbAtPosition:ccp(currentX,j)];
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        if (orbCom.type == currentOrbCom.type) {
            [matchYArray addObject:orb];
        }else {
            break;
        }
    }
    
    NSMutableArray *matchArray = [[NSMutableArray alloc] init];
    
    if (matchXArray.count >=3) {
        [matchArray addObjectsFromArray:matchXArray];
        for (int i=0; i<currentColumns; i++) {
            Entity *orb = [self orbAtPosition:ccp(i,currentY)];
            OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
            if (orbCom.type == OrbPurple) {
                [self cleanOrb:orb];
            }
        }
    }
    if (matchYArray.count >=3) {
        [matchArray addObjectsFromArray:matchYArray];
        for (int j=0; j<kOrbBoardRows; j++) {
            Entity *orb = [self orbAtPosition:ccp(currentX,j)];
            OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
            if (orbCom.type == OrbPurple) {
                [self cleanOrb:orb];
            }
        }
    }
    
    return matchArray;
}

-(void)cleanOrb:(Entity *)orb {
    RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
    [orbRenderCom.sprite runAction:
     [CCSequence actions:
      [CCFadeOut actionWithDuration:0.5f],
      [CCCallBlock actionWithBlock:^{
         [orbRenderCom.node setVisible:NO];
     }],nil]];
    OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
    orbCom.type = OrbNull;
    [orb removeComponent:[TouchComponent name]];

}

-(void)matchClean:(NSArray *)matchArray {
    combos++;
    PlayerComponent *playerCom = (PlayerComponent *)[self.player getComponentOfName:[PlayerComponent name]];
    playerCom.mana += kManaForEachCombo * combos;
    
    // only test
    combosOrbSum = matchArray.count;
    
    [self showCombos];
    for (Entity *orb in matchArray) {
        [self cleanOrb:orb];
    }
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

-(NSArray *)nextColumn {
    currentColumn++;
    if (currentColumn >= patterns.count) {
        currentColumn = 0;
        iteration--;
        // check iteration if pattern is needed change
        if (iteration <= 0) {
            // change pattern
            if (_battleData.patternRandom) {
                currentPattern = arc4random_uniform(_battleData.patterns.count);
            }else {
                currentPattern = (currentPattern+1)%_battleData.patterns.count;
            }
            NSString *pid = [_battleData.patterns objectAtIndex:currentPattern];
            NSDictionary *patternData = [[FileManager sharedFileManager] getPatternDataWithPid:pid];
            iteration = [[patternData objectForKey:@"iteration"] intValue];
            patterns = [patternData objectForKey:@"patterns"];
        }
    }
    NSMutableArray *nextColumn = [[NSMutableArray alloc] init];
    NSArray *array = nil;
    if (patterns.count > 0) {
        array = [NSMutableArray arrayWithArray:[patterns objectAtIndex:currentColumn]];
    }
    
    if (array.count == kOrbBoardRows) {
        for (int i=0; i<kOrbBoardRows; i++) {
            NSNumber *number = [array objectAtIndex:i];
            if (number.intValue > 100) {
                NSArray *randomArray = [randomOrbs objectForKey:number.stringValue];
                NSNumber *orbNumber = [randomArray objectAtIndex:arc4random_uniform(randomArray.count)];
                [nextColumn addObject:orbNumber];
            }else if(number.intValue < 0) {
                NSNumber *orbNumber = [NSNumber numberWithInt:(arc4random_uniform(OrbBottom - 1)+1)];
                [nextColumn addObject:orbNumber];
            }else {
                [nextColumn addObject:number];
            }
        }
    }else {
        for (int i=0; i<kOrbBoardRows; i++) {
            int type = arc4random_uniform(OrbBottom - 1) + 1;
            if (arc4random_uniform(2) > 0) {
                type = OrbNull;
            }
            NSNumber *orbNumber = [NSNumber numberWithInt:type];
            [nextColumn addObject:orbNumber];
        }
        
    }
    
    return nextColumn;
}

@end
