//
//  CharacterQueueLayer.m
//  LightBugBattle
//
//  Created by  浩翔 on 13/1/17.
//
//

#import "CharacterQueueLayer.h"
#import "CharacterHeadView.h"
#import "Character.h"
#import "MyCell.h"
#import "MapLayer.h"
#import "MapCameraControl.h"

typedef enum {
    buttomPad1 = 0,
    buttomPad2,
    fifthCharacterHeadViewPosition,
    fourthCharacterHeadViewPosition,
    thirdCharacterHeadViewPosition,
    secondCharacterHeadViewPosition,
    firstCharacterHeadViewPosition,
    pad,
    currentCharacterHeadViewPosition,
    topPad,
    labelsCount
} HeadViewPosition;

typedef enum {
    currentCharacterIndex = 0,
    firstCharacterIndex,
    secondCharacterIndex,
    thirdCharacterIndex,
    fourthCharacterIndex,
    fifthCharacterIndex
} HeadViewIndex;

@interface CharacterQueueLayer() {
    NSMutableArray *queueBarSprite;
    
    CCSprite *selectSprite;
    CCAction *selectAction;
    
    SWTableView   *tableView;
}
@property (nonatomic,weak) CharacterQueue *queue;
@end

@implementation CharacterQueueLayer

static const int currentCharacterHeadViewTag = 999;
static const int tableviewWidth = 36;
static const int tableviewHeight = 200;
static const int tableviewCellHeight = 40;
static const int tableviewPositionX = 5;
static const int tableviewPositionY = 40;
static const int tableviewPositionZ = 100;
static const int player1Tag = 1;
static const int playerColerFrameTag = 987;
static const int arrowTag = 990;

-(id)initWithQueue:(CharacterQueue *)aQueue {
    if ((self = [super init])) {
        _queue = aQueue;
        _queue.delegate = self;
        queueBarSprite = [[NSMutableArray alloc] init];
        [self setCCSelectSprite];
        [self drawQueueBar];
        [self setTable];
    }
    return self;
}

-(void)setCurrentCharacter:(Character *)currentCharacter {
    if ([self getChildByTag:currentCharacterHeadViewTag]) {
        [self removeChildByTag:currentCharacterHeadViewTag cleanup:YES];
    }
    CharacterHeadView *characterHeadView = [[CharacterHeadView alloc] initWithCharacter:currentCharacter];
    if (!characterHeadView) {
        NSAssert(characterHeadView !=nil , @"character's headImage should not nil.");
        return;
    }
    
    CGPoint currentHeadViewPoint = ccp(tableviewWidth/2+tableviewPositionX*2,tableviewPositionY+tableviewHeight+tableviewCellHeight/2);
    characterHeadView.position = currentHeadViewPoint;
    characterHeadView.anchorPoint = ccp(0.5,0.5);
    characterHeadView.tag = currentCharacterHeadViewTag;
    selectSprite.position = currentHeadViewPoint;
    selectSprite.visible = YES;

    [self addChild:characterHeadView];
}

-(void)setCCSelectSprite {
    selectSprite = [[CCSprite alloc] initWithFile:@"currentCharacter.png"];
    selectSprite.anchorPoint = ccp(0.5,0.5);
    selectSprite.visible = NO;
    [self addChild:selectSprite];
}

-(void)drawQueueBar {
    
    for (CharacterHeadView *sprite in queueBarSprite) {
        [self removeChild:sprite cleanup:YES];
    }
    [queueBarSprite removeAllObjects];
    
    NSArray *characterArray = [self.queue currentCharacterQueueArray];
    int count = characterArray.count;
    for (int i=0; i<count; i++) {
        Character *character = [characterArray objectAtIndex:i];
        CharacterHeadView *characterHeadView = [[CharacterHeadView alloc] initWithCharacter:character];
        [queueBarSprite addObject:characterHeadView];
    }
    [self resortTableViewWithAnimated:NO];
}

-(void)redrawQueueBar {
    [self drawQueueBar];
}

-(void)insertCharacterAtIndex:(NSUInteger)index withAnimated:(BOOL)animated {
    //FIXME: Here should be tested more.
//    if (!animated) {
//        [self drawQueueBar];
//        return;
//    }
    CGSize winSize = [CCDirector sharedDirector].winSize;
//    NSLog(@"%d",index);
    SWTableViewCell *cell = [tableView cellAtIndex:index];
    CCSprite *insertArrow = [[CCSprite alloc] initWithFile:@"Arrow.png"];
    int height;
    BOOL show = NO;
    insertArrow.tag = arrowTag;
    if (cell) {
//        int count = cell.children.count;
//        NSLog(@"%d.cell is here ::(%g,%g) count :: %d",cell.idx,cell.position.x,cell.position.y,count);
        height = cell.position.y;
        show = YES;
    }else {
//        NSLog(@"no cell");
        height = winSize.height - (tableviewPositionY + index*tableviewCellHeight);
        if (height > tableviewPositionY) {
            show = YES;
        }
    }
    if (show) {
        insertArrow.position = ccp(tableviewPositionX+tableviewWidth,height);
        [self addChild:insertArrow];
        [insertArrow runAction:[CCFadeOut actionWithDuration:1.0f]];
        [self performSelector:@selector(arrowClean) withObject:nil afterDelay:1.0];
    }
    [self drawQueueBar];
}

-(void)arrowClean {
    [[self getChildByTag:arrowTag] removeFromParentAndCleanup:YES];
}

-(void)removeCharacter:(Character *)character withAnimated:(BOOL)animated{
    if (!animated) {
        [self drawQueueBar];
        return;
    }
    BOOL removed = NO;
    int index;
    int count = queueBarSprite.count;
    for (int i=0; i<count; i++) {
        CharacterHeadView *characterHeadView = [queueBarSprite objectAtIndex:i];
        Character *removeCharacter = characterHeadView.character;
        if (removeCharacter == character) {
            [self removeCharacterHeadViewInCell:i];
            removed = YES;
            index = i;
            break;
        }
    }
    if (removed) {
        [queueBarSprite removeObjectAtIndex:index];
    }
}

-(void)setTable {
    //CCLayerColor *layer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 0)];  //no color
    
    CGSize tableSize;
    CGPoint tablePosition;
    
    tableSize = CGSizeMake(tableviewWidth,tableviewHeight);
    tablePosition = ccp(tableviewPositionX,tableviewPositionY);
    tableView = [SWTableView viewWithDataSource:self size:tableSize];
    
    tableView.verticalFillOrder = SWTableViewFillTopDown;
    tableView.direction = SWScrollViewDirectionVertical;
    tableView.position = tablePosition;
    tableView.delegate = self;
    tableView.bounces = YES;
    
    //layer.contentSize		 = tableView.contentSize;
    
    //[tableView addChild:layer];
    
    [self addChild:tableView z:tableviewPositionZ];
    [self resortTableViewWithAnimated:NO];
}

#pragma mark SWTableViewDataSource
-(CGSize)cellSizeForTable:(SWTableView *)table {
    return CGSizeMake(tableviewWidth, tableviewCellHeight);;
}
-(SWTableViewCell *)table:(SWTableView *)table cellAtIndex:(NSUInteger)idx {
    SWTableViewCell *cell = [table dequeueCell];
    if (!cell) {
        cell = [MyCell new];
    } else {
        [cell removeAllChildrenWithCleanup:YES];
    }
    
    CCSprite *sprite = [queueBarSprite objectAtIndex:idx];
    CCSprite *newSprite = [CCSprite spriteWithTexture:[sprite texture] rect:[sprite textureRect]];
    newSprite.anchorPoint = ccp(0.5,0.5);
    newSprite.position = ccp(tableviewWidth/2, tableviewCellHeight/2);
    newSprite.tag = idx;
    [cell addChild:newSprite];
    
    if ([[queueBarSprite objectAtIndex:idx] isKindOfClass:[CharacterHeadView class]]) {
        CharacterHeadView *characterHeadView = [queueBarSprite objectAtIndex:idx];
        Character *character = characterHeadView.character;
        CCSprite *playerColorFrame;
        
        if (character.player == player1Tag) {
            playerColorFrame = [[CCSprite alloc] initWithFile:@"player1Character.png"];
            playerColorFrame.tag = playerColerFrameTag;
        }else {
            playerColorFrame = [[CCSprite alloc] initWithFile:@"player2Character.png"];
            playerColorFrame.tag = playerColerFrameTag;
        }
        playerColorFrame.position = newSprite.position;
        [cell addChild:playerColorFrame];
    }
    
    return cell;
}
-(NSUInteger)numberOfCellsInTableView:(SWTableView *)table {
    return queueBarSprite.count;
}

#pragma mark SWTableViewDelegate
-(void)table:(SWTableView *)table cellTouched:(SWTableViewCell *)cell {
    CharacterHeadView *characterHeadView = [queueBarSprite objectAtIndex:cell.idx];
    Character *character = characterHeadView.character;
    MapLayer *mapLayer = (MapLayer *)character.sprite.parent;
    MapCameraControl *camera = mapLayer.cameraControl;
    if (camera) {
        [camera smoothMoveCameraToX:character.position.x Y:character.position.y];
    }
}

#pragma mark Custom Table animation method
-(void)removeCharacterHeadViewInCell:(NSUInteger)index {
    SWTableViewCell *cell = [tableView cellAtIndex:index];
    
    CCNode *node = [cell getChildByTag:index];
    CCNode *playerColorFrame = [cell getChildByTag:playerColerFrameTag];
    
    [self runDeadAnimation:node];
    [playerColorFrame runAction:[CCFadeOut actionWithDuration:1.0f]];
}

-(void)runDeadAnimation:(CCNode *)node {
    CCParticleSystemQuad *emitter = [[CCParticleSystemQuad alloc] initWithFile:@"bloodParticle.plist"];
    emitter.position = ccp(node.position.x, node.position.y);
    emitter.positionType = kCCPositionTypeRelative;
    emitter.autoRemoveOnFinish = YES;
    [node addChild:emitter];
    
    [node runAction:[CCSequence actions:
                     [CCFadeOut actionWithDuration:1.0f],
                     [CCCallFunc actionWithTarget:self selector:@selector(deadAnimationCallback)]
                     ,nil]];
}

-(void)resortTableViewWithAnimated:(BOOL)animated {
    [tableView reloadData];
    [tableView moveToTopWithAnimated:animated];
}

-(void)deadAnimationCallback {
    NSArray *characterArray = [self.queue currentCharacterQueueArray];
    if (queueBarSprite.count == characterArray.count) {
        [self resortTableViewWithAnimated:YES];
    }
}

@end
