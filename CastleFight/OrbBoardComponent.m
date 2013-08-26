//
//  OrbBoardComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/8/14.
//
//

#import "OrbBoardComponent.h"
#import "EntityFactory.h"
#import "OrbComponent.h"
#import "RenderComponent.h"
#import "cocos2d.h"

@interface OrbBoardComponent() {
    int combos;
    int combosOrbSum; // only for test
}

@end

@implementation OrbBoardComponent

+(NSString *)name {
    static NSString *name = @"OrbBoardComponent";
    return name;
}

-(id)initWithEntityFactory:(EntityFactory *)entityFactory {
    if (self = [super init]) {
        
        _entityFactory = entityFactory;
        _orbs = [[NSMutableArray alloc] init];
        combos = 0;
        //TODO: create lots of Orb.
    }
    return self;
}

//-(void)produceOrbs {
//    RenderComponent *boardRenderCom = (RenderComponent *)[self.entity getComponentOfName:[RenderComponent name]];
//    
//    for (int j = 0; j<_rows; j++) {
//        
//        int randomOrb = OrbRed + arc4random_uniform(OrbBottom-1);
//        
//        int randomExist = arc4random_uniform(2);
//        if (randomExist == 0) {
//            randomOrb = OrbNull;
//        }
//
//        Entity *orb = [_entityFactory createOrbForType:randomOrb];
//        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
//        orbCom.board = self.entity;
//        orbCom.position = CGPointMake(0, j);
//        RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
//        
//        if (randomOrb == OrbNull) {
//            [orbRenderCom.node setVisible:NO];
//        }
//        
//        CGPoint position = [boardRenderCom.sprite convertToNodeSpace:CGPointMake(boardRenderCom.sprite.boundingBox.size.width+kOrb_XSIZE,kOrb_YSIZE/2+(kOrb_YSIZE+kOrb_YPad)*j)];
//        position = [boardRenderCom.node convertToWorldSpace:position];
//        orbRenderCom.node.position = position;
//        [boardRenderCom.node addChild:orbRenderCom.node];
//        
//        [self adjustOrbPosition:orb realPosition:orbRenderCom.node.position];
//        
//        [_board addObject:orb];
//    }
//}

-(void)moveOrb:(Entity *)startOrb ToPosition:(CGPoint)targetPosition {
    combos = 0;
    CGPoint target = [self getPositionInTheBoardFromRealPosition:targetPosition floor:YES];
    Entity *targetOrb = [self getOrbInPosition:target];
    if (!targetOrb) { //out of board
        return;
    }
    [self exchangeOrb:startOrb targetOrb:targetOrb];
}

-(CGPoint)getPositionInTheBoardFromRealPosition:(CGPoint)position floor:(BOOL)isFloor {
    int x,y;
    if (isFloor) {
        x = floor((position.x-kOrbBoradLeftMargin) / (kOrbWidth));
        y = floor((position.y-kOrbBoradDownMargin) / (kOrbHeight));
    }else {
        x = round((position.x-kOrbBoradLeftMargin) / (kOrbWidth));
        y = round((position.y-kOrbBoradDownMargin) / (kOrbHeight));
    }
    
    if (x>= kOrbBoardColumns -1) {
        x = kOrbBoardColumns -1;
    }
    if (y>= kOrbBoardRows -1) {
        y = kOrbBoardRows -1;
    }
    return CGPointMake(x, y);
}

-(Entity *)getOrbInPosition:(CGPoint)position {
    Entity *target = nil;
    for (Entity *orb in self.orbs) {
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        if (CGPointEqualToPoint(orbCom.position, position)) {
            target = orb;
            break;
        }
    }
    return target;
}

-(void)exchangeOrb:(Entity *)startOrb targetOrb:(Entity *)targetOrb {
    
    OrbComponent *startOrbCom = (OrbComponent *)[startOrb getComponentOfName:[OrbComponent name]];
    OrbComponent *targetOrbCom = (OrbComponent *)[targetOrb getComponentOfName:[OrbComponent name]];
    
    RenderComponent *startRenderCom = (RenderComponent *)[startOrb getComponentOfName:[RenderComponent name]];
    RenderComponent *targetRenderCom = (RenderComponent *)[targetOrb getComponentOfName:[RenderComponent name]];
    
    CGPoint tempOrbPoint = startOrbCom.position;
    CGPoint tempRenderPoint = startRenderCom.node.position;
    
    startOrbCom.position = targetOrbCom.position;
    targetOrbCom.position = tempOrbPoint;
    startRenderCom.node.position = targetRenderCom.node.position;
    targetRenderCom.node.position = tempRenderPoint;
}

-(void)adjustOrbPosition:(Entity *)orb realPosition:(CGPoint)realPosition {
    CGPoint boardPosition = [self getPositionInTheBoardFromRealPosition:realPosition floor:YES];
    OrbComponent *orbComponent = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
    int currentX = orbComponent.position.x;
    if (boardPosition.x == currentX) {
        return;
    }else {
        orbComponent.position = boardPosition;
    }
}

-(void)clean {
    NSMutableArray *deletOrbs = [[NSMutableArray alloc] init];
    for (Entity *orb in self.orbs) {
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        if (orbCom.position.x <= 0) {
            [deletOrbs addObject:orb];
        }
    }
    for (Entity *orb in deletOrbs) {
        RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
        [self.orbs removeObject:orb];
        
        [orbRenderCom.sprite runAction:
         [CCSequence actions:
          [CCFadeOut actionWithDuration:0.5f],
          [CCCallBlock actionWithBlock:^{
             [orbRenderCom.node removeFromParentAndCleanup:YES];
         }],nil]];
        
        [orb removeSelf];
    }
    [deletOrbs removeAllObjects];
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
    [self.entityFactory.mapLayer addChild:label z:0 tag:kCombosLabelTag];
    
    [label runAction:
     [CCSequence actions:
      [CCFadeOut actionWithDuration:5.0f],
      [CCCallBlock actionWithBlock:^{
         combos = 0;
         [self.entityFactory.mapLayer removeChildByTag:kCombosLabelTag cleanup:YES];
     }],nil]];
}

@end
