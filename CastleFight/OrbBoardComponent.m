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

#define kOrbBoardLastColumnNum 99

@interface OrbBoardComponent() {
    int _rows;
    int _columns;
    float _width;
    float _height;
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
        _rows = kOrbBoardRows;
        _columns = kOrbBoardColumns;
        _width = kOrbBoardWidth;
        _height = kOrbBoardHeight;
        
        _board = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(void)produceOrbs {
    RenderComponent *boardRenderCom = (RenderComponent *)[self.entity getComponentOfName:[RenderComponent name]];
    
    for (int j = 0; j<_rows; j++) {
        
        int randomOrb = OrbRed + arc4random_uniform(OrbBottom-1);
        
        int randomExist = arc4random_uniform(2);
        if (randomExist == 0) {
            randomOrb = OrbPink;
        }
        
        Entity *orb = [_entityFactory createOrbForType:randomOrb];
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        orbCom.board = self.entity;
        orbCom.position = CGPointMake(kOrbBoardLastColumnNum, j);
        RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
        
        if (randomOrb == OrbPink) {
            [orbRenderCom.node setVisible:NO];
        }
        
        CGPoint position = [boardRenderCom.sprite convertToNodeSpace:CGPointMake(boardRenderCom.sprite.boundingBox.size.width+kOrb_XSIZE,kOrb_YSIZE/2+(kOrb_YSIZE+kOrb_YPad)*j)];
        position = [boardRenderCom.node convertToWorldSpace:position];
        orbRenderCom.node.position = position;
        [boardRenderCom.node addChild:orbRenderCom.node];
        
        [self adjustOrbPosition:orb realPosition:orbRenderCom.node.position];
        
        [_board addObject:orb];
    }
}

-(void)moveOrb:(Entity *)startOrb ToPosition:(CGPoint)targetPosition {
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
        x = floor(position.x / (kOrb_XSIZE));
        y = floor(position.y / (kOrb_YSIZE));
    }else {
        x = round(position.x / (kOrb_XSIZE));
        y = round(position.y / (kOrb_YSIZE));
    }
    
    if (x>= _columns -1) {
        x = _columns -1;
    }
    if (y>= _rows -1) {
        y = _rows -1;
    }
    return CGPointMake(x, y);
}

-(Entity *)getOrbInPosition:(CGPoint)position {
    Entity *target = nil;
    for (Entity *orb in self.board) {
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
    for (Entity *orb in self.board) {
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        if (orbCom.position.x < 0) {
            [deletOrbs addObject:orb];
        }
    }
    for (Entity *orb in deletOrbs) {
        RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
        [self.board removeObject:orb];
        [orbRenderCom.node removeFromParentAndCleanup:YES];
        [orb removeSelf];
    }
}

-(NSArray *)findMatchFromPosition:(CGPoint)position CurrentOrb:(Entity *)currentOrb {
    
    OrbComponent *currentOrbCom = (OrbComponent *)[currentOrb getComponentOfName:[OrbComponent name]];
    if (currentOrbCom.type == OrbPink) {
        return nil;
    }
    
    NSMutableArray *matchArray = [[NSMutableArray alloc] init];
    
    for (Entity *orb in self.board) {
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        if (orbCom.type == currentOrbCom.type) {
            if (orbCom.position.x == currentOrbCom.position.x) {
                if (abs(orbCom.position.y - currentOrbCom.position.y) <= 1) {
                    [matchArray addObject:orb];
                    continue;
                }
            }
            if (orbCom.position.y == currentOrbCom.position.y) {
                if (abs(orbCom.position.x - currentOrbCom.position.x) <= 1) {
                    [matchArray addObject:orb];
                    continue;
                }
            }
        }
    }
    
    return matchArray;
}

-(void)matchClean:(NSArray *)matchArray {
    
    for (Entity *orb in matchArray) {
        RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
        [orbRenderCom.node setVisible:NO];
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        orbCom.type = OrbPink;
    }
}

/*
-(NSArray *)findCombos {
    int cols = self.columns;
    int rows = self.rows;
    
    NSMutableArray *combos = [NSMutableArray new];
    
    NSMutableArray *xCombos = [NSMutableArray new];
    NSMutableArray *yCombos = [NSMutableArray new];
    NSMutableArray *combinCombos = [NSMutableArray new];
    
    // scan x way
    for (int j = 0; j < rows; j++) {
        int xCount = 1;
        for (int i = 1; i < cols; i++) {
            NSNumber *currentNumber = [self getNumberFromBoard:CGPointMake(i, j)];
            NSNumber *preNumber = [self getNumberFromBoard:CGPointMake(i-1, j)];
            
            if (currentNumber.intValue == preNumber.intValue) {
                xCount +=1;
                if (xCount == minSingleAttackCount) {

                    PadCombo *xCombo = [[PadCombo alloc] init];
                    xCombo.way = kXWay;
                    xCombo.color = currentNumber.intValue;
                    for (int k = 0; k < xCount; k++) {
                        [xCombo addOrb:CGPointMake(i-k, j)];
                    }
                    [xCombos addObject:xCombo];
                }else if(xCount > minSingleAttackCount) {
                    PadCombo *xCombo = [self getComboByPosition:CGPointMake(i-1, j) InArray:xCombos];
                    [xCombo addOrb:CGPointMake(i, j)];
                }
                
            }else {
                xCount = 1;
            }
        }
    }
    
    // scan y way
    for (int i = 0; i < cols; i++) {
        int yCount = 1;
        for (int j = 1; j < rows; j++) {
            NSNumber *currentNumber = [self getNumberFromBoard:CGPointMake(i, j)];
            NSNumber *preNumber = [self getNumberFromBoard:CGPointMake(i, j-1)];
            if (currentNumber.intValue == preNumber.intValue) {
                yCount +=1;
                if (yCount == minSingleAttackCount) {
                    
                    PadCombo *yCombo = [[PadCombo alloc] init];
                    yCombo.way = kYWay;
                    yCombo.color = currentNumber.intValue;
                    for (int k = 0; k < yCount; k++) {
                        [yCombo addOrb:CGPointMake(i, j-k)];
                    }
                    [yCombos addObject:yCombo];
                }else if(yCount > minSingleAttackCount) {
                    PadCombo *yCombo = [self getComboByPosition:CGPointMake(i, j-1) InArray:yCombos];
                    [yCombo addOrb:CGPointMake(i, j)];
                }
                
            }else {
                yCount = 1;
            }
        }
    }
    
    // integrate x Way
    for (int j = 1; j < rows; j++) {
        for (int i = 0; i < cols; i++) {
            NSNumber *preNumber = [self getNumberFromBoard:CGPointMake(i, j-1)]; //up orb
            NSNumber *currentNumber = [self getNumberFromBoard:CGPointMake(i, j)];
            if (currentNumber.intValue == preNumber.intValue) {
                PadCombo *preXCombo = [self getComboByPosition:CGPointMake(i, j-1) InArray:xCombos];
                PadCombo *xCombo = [self getComboByPosition:CGPointMake(i, j) InArray:xCombos];
                if (preXCombo && xCombo) {
                    [preXCombo combineCombo:xCombo];
                }
            }else
                continue;
        }
    }
    
    // integrate y Way
    for (int i = 1; i < cols; i++) {
        for (int j = 0; j < rows; j++) {
            NSNumber *preNumber = [self getNumberFromBoard:CGPointMake(i-1, j)]; //left orb
            NSNumber *currentNumber = [self getNumberFromBoard:CGPointMake(i, j)];
            if (currentNumber.intValue == preNumber.intValue) {
                PadCombo *preYCombo = [self getComboByPosition:CGPointMake(i-1, j) InArray:yCombos];
                PadCombo *yCombo = [self getComboByPosition:CGPointMake(i, j) InArray:yCombos];
                if (preYCombo && yCombo) {
                    [preYCombo combineCombo:yCombo];
                }
            }else
                continue;
        }
    }
    
    //integrate x y
    for (int j = 0; j < rows; j++) {
        for (int i = 0; i < cols; i++) {
            PadCombo *xCombo = [self getComboByPosition:CGPointMake(i, j) InArray:xCombos];
            PadCombo *yCombo = [self getComboByPosition:CGPointMake(i, j) InArray:yCombos];
            if (xCombo && yCombo) {
                PadCombo *combo = [self combineACombo:xCombo andBCombo:yCombo];
                PadCombo *oldCombo = [self getComboByPosition:CGPointMake(i, j) InArray:combinCombos];
                if (oldCombo) {
                    [oldCombo combineCombo:combo];
                }else {
                    [combinCombos addObject:combo];
                }
            }
        }
    }
    
    //delete the duplicated combo
    for (int j = 0; j < rows; j++) {
        for (int i = 0; i < cols; i++) {
            PadCombo *xCombo = [self getComboByPosition:CGPointMake(i, j) InArray:xCombos];
            PadCombo *yCombo = [self getComboByPosition:CGPointMake(i, j) InArray:yCombos];
            PadCombo *combo = [self getComboByPosition:CGPointMake(i, j) InArray:combinCombos];
            if (xCombo && combo) {
                [xCombos removeObject:xCombo];
                [xCombo deleteSelf];
            }
            if (yCombo && combo) {
                [yCombos removeObject:yCombo];
                [yCombo deleteSelf];
            }
        }
    }
    
    [combos addObjectsFromArray:combinCombos];
    
    //Final
    for (int j = 0; j < rows; j++) {
        for (int i = 0; i < cols; i++) {
            PadCombo *xCombo = [self getComboByPosition:CGPointMake(i, j) InArray:xCombos];
            PadCombo *yCombo = [self getComboByPosition:CGPointMake(i, j) InArray:yCombos];
            if (![combos containsObject:xCombo] && xCombo != nil) {
                [combos addObject:xCombo];
            }
            if (![combos containsObject:yCombo] && yCombo != nil) {
                [combos addObject:yCombo];
            }
        }
    }
    
    return combos;
}
//*/

@end
