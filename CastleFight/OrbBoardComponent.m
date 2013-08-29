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
#import "RenderComponent.h"
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

-(id)initWithEntityFactory:(EntityFactory *)entityFactory owner:(Entity *)player BattleData:(BattleDataObject *)battleData {
    if (self = [super init]) {
        
        _columns = [NSMutableArray arrayWithCapacity:kOrbBoardColumns];
        
        _entityFactory = entityFactory;
        _orbs = [[NSMutableArray alloc] init];
        combos = 0;
        _owner = player;
        _battleData = battleData;
        currentColumn = 0;
        currentPattern = -1;
        iteration = 0;
        randomOrbs = [[FileManager sharedFileManager] getPatternDataWithPid:@"RandomOrbs"];
        //TODO: create lots of Orb.
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

-(NSArray *)findMatchFromPosition:(CGPoint)position CurrentOrb:(Entity *)currentOrb {
    
    OrbComponent *currentOrbCom = (OrbComponent *)[currentOrb getComponentOfName:[OrbComponent name]];
    if (currentOrbCom.type == OrbNull) {
        return nil;
    }
    
    NSMutableArray *xArray = [[NSMutableArray alloc] init];
    NSMutableArray *yArray = [[NSMutableArray alloc] init];
    
    for (Entity *orb in self.orbs) {
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        if (orbCom.type == currentOrbCom.type) {
            if (orbCom.position.x == currentOrbCom.position.x) {
                [xArray addObject:orbCom];
            }
            if (orbCom.position.y == currentOrbCom.position.y) {
                [yArray addObject:orbCom];
            }
        }
    }
    
    [xArray sortUsingComparator:^(OrbComponent *obj1, OrbComponent *obj2) {
        int y1 = obj1.position.y;
        int y2 = obj2.position.y;
        if (y1 > y2) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    [yArray sortUsingComparator:^(OrbComponent *obj1, OrbComponent *obj2) {
        int x1 = obj1.position.x;
        int x2 = obj2.position.x;
        if (x1 > x2) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    NSMutableArray *matchXArray = [[NSMutableArray alloc] init];
    NSMutableArray *matchYArray = [[NSMutableArray alloc] init];
    
    int xStart = 0;
    int xEnd = 0;
    for (int i=0; i<xArray.count; i++) {
        OrbComponent *orbCom = [xArray objectAtIndex:i];
        if (orbCom.position.y > currentOrbCom.position.y) {
            OrbComponent *lastOrbCom = [xArray objectAtIndex:xEnd];
            if (orbCom.position.y == lastOrbCom.position.y+1) {
                xEnd = i;
            }else {
                break;
            }
        } else {
            OrbComponent *lastOrbCom = [xArray objectAtIndex:xEnd];
            if (orbCom.position.y != lastOrbCom.position.y+1) {
                xStart = i;
            }
            xEnd = i;
        }
    }
    
    int yStart = 0;
    int yEnd = 0;
    for (int i=0; i<yArray.count; i++) {
        OrbComponent *orbCom = [yArray objectAtIndex:i];
        if (orbCom.position.x > currentOrbCom.position.x) {
            OrbComponent *lastOrbCom = [yArray objectAtIndex:yEnd];
            if (orbCom.position.x == lastOrbCom.position.x+1) {
                yEnd = i;
            }else {
                break;
            }
        } else {
            OrbComponent *lastOrbCom = [yArray objectAtIndex:yEnd];
            if (orbCom.position.x != lastOrbCom.position.x+1) {
                yStart = i;
            }
            yEnd = i;
        }
    }
    
    for (int i= xStart; i<=xEnd; i++) {
        [matchXArray addObject:[xArray objectAtIndex:i]];
    }
    for (int i= yStart; i<=yEnd; i++) {
        [matchYArray addObject:[yArray objectAtIndex:i]];
    }
    
    NSMutableArray *matchArray = [[NSMutableArray alloc] init];
    
    if (matchXArray.count >= 3) {
        for (OrbComponent *orbCom in matchXArray) {
            [matchArray addObject:orbCom.entity];
        }
    }
    if (matchYArray.count >= 3) {
        for (OrbComponent *orbCom in matchYArray) {
            [matchArray addObject:orbCom.entity];
        }
    }
    
    return matchArray;
}

-(void)matchClean:(NSArray *)matchArray {
    combos++;
    // only test
    combosOrbSum = matchArray.count;
    [self showCombos];
    if (combos>=5) {
        matchArray = self.orbs;
        CCAction *shake = [CCShake actionWithDuration:3.0 amplitude:ccp(5, 5)];
        [self.entityFactory.mapLayer runAction:shake];
    }
    for (Entity *orb in matchArray) {
        RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
        [orbRenderCom.sprite runAction:
         [CCSequence actions:
          [CCFadeOut actionWithDuration:0.5f],
          [CCCallBlock actionWithBlock:^{
             [orbRenderCom.node setVisible:NO];
         }],nil]];
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        orbCom.type = OrbNull;
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
