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
    int _rows;
    int _columns;
    float _width;
    float _height;
    int _currentColumn;
    EntityFactory *_entityFactory;
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
        _currentColumn = -1;
        
        _board = [NSMutableArray arrayWithCapacity:_columns]; // x axis
        //TODO: create lots of Orb.
    }
    return self;
}

-(void)produceOrbs {
    _currentColumn = ++_currentColumn%_columns;
    
    RenderComponent *boardRenderCom = (RenderComponent *)[self.entity getComponentOfName:[RenderComponent name]];
    NSMutableArray *newColumn = [[NSMutableArray alloc] init];
    for (int j = 0; j<_rows; j++) {
        
        int randomExist = arc4random_uniform(2);
        if (randomExist == 0) {
            continue;
        }
        
        int randomOrb = OrbRed + arc4random_uniform(OrbBottom-1);
        Entity *orb = [_entityFactory createOrbForType:randomOrb];
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        orbCom.board = self.entity;
        orbCom.position = CGPointMake(_currentColumn, j);
        RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
        
        CGPoint position = [boardRenderCom.sprite convertToNodeSpace:CGPointMake(boardRenderCom.sprite.boundingBox.size.width+kOrb_XSIZE,kOrb_YSIZE/2+(kOrb_YSIZE+kOrb_YPad)*j)];
        position = [boardRenderCom.node convertToWorldSpace:position];
        orbRenderCom.node.position = position;
        [boardRenderCom.node addChild:orbRenderCom.node];
        
        [newColumn addObject:orb];
    }
    [_board addObject:newColumn];
}

-(void)removeColumn:(int)index {
    [_board removeObjectAtIndex:index];
}

-(BOOL)isMovable:(CGPoint)targetPosition {
    
    BOOL movable = NO;
    
    int x = targetPosition.x;
    int y = targetPosition.y;
    
    if (x >= kOrbBoardMinBorder && x < _columns && y >= kOrbBoardMinBorder && y < _rows) {
        movable = YES;
    }
    
    return movable;
}

-(void)moveOrb:(Entity *)startOrb ToPosition:(CGPoint)targetPosition {
    CGPoint target = [self getPositionInTheBoardFromRealPosition:targetPosition floor:YES];
    if([self isMovable:target]) {
//        Entity *targetOrb = [self getOrbInPosition:target];
//        [self exchangeOrb:startOrb targetOrb:targetOrb];
//        NSLog(@"exchange success");
    }
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
    if (x<0) {
        x=0;
    }
    if (y<0) {
        y=0;
    }
    
    return CGPointMake(x, y);
}

-(void)exchangeOrb:(Entity *)startOrb targetOrb:(Entity *)targetOrb {
    
    OrbComponent *startOrbCom = (OrbComponent *)[startOrb getComponentOfName:[OrbComponent name]];
    OrbComponent *targetOrbCom = (OrbComponent *)[targetOrb getComponentOfName:[OrbComponent name]];
    
    RenderComponent *startRenderCom = (RenderComponent *)[startOrb getComponentOfName:[RenderComponent name]];
    RenderComponent *targetRenderCom = (RenderComponent *)[targetOrb getComponentOfName:[RenderComponent name]];
    
    NSMutableArray *startColumn = [self.board objectAtIndex:startOrbCom.position.x];
    NSMutableArray *targetColumn = [self.board objectAtIndex:targetOrbCom.position.x];
    
    [startColumn replaceObjectAtIndex:startOrbCom.position.y withObject:targetOrb];
    [targetColumn replaceObjectAtIndex:targetOrbCom.position.y withObject:startOrb];
    
    CGPoint tempOrbPoint = startOrbCom.position;
    CGPoint tempRenderPoint = startRenderCom.node.position;
    
    startOrbCom.position = targetOrbCom.position;
    targetOrbCom.position = tempOrbPoint;
    startRenderCom.node.position = targetRenderCom.node.position;
    targetRenderCom.node.position = tempRenderPoint;
}

-(Entity *)getOrbInPosition:(CGPoint)position {
    NSMutableArray *column = [self.board objectAtIndex:position.x];
    Entity *orb = [column objectAtIndex:position.y];
    return orb;
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
