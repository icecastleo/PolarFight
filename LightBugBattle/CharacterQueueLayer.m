//
//  CharacterQueueLayer.m
//  LightBugBattle
//
//  Created by  DAN on 13/1/17.
//
//

#import "CharacterQueueLayer.h"
#import "CharacterHeadView.h"
#import "Character.h"
#import "MyCell.h"

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
//    NSArray *headViewPointArray;
    NSMutableArray *queueBarSprit;
    
    CCSprite *selectSprite;
    CCAction *selectAction;
    
    SWTableView   *tableView;
}
@property (nonatomic) CharacterQueue *queue;
@end

@implementation CharacterQueueLayer

static const int currentCharacterHeadViewTag = 999;
static const int tableviewWidth = 32;
static const int tableviewHeight = 200;
static const int tableviewCellHeight = 40;
static const int tableviewPositionX = 5;
static const int tableviewPositionY = 40;
static const int tableviewPositionZ = 100;

-(id)initWithQueue:(CharacterQueue *)aQueue {
    if ((self = [super init])) {
        _queue = aQueue;
        _queue.delegate = self;
        queueBarSprit = [[NSMutableArray alloc] init];
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

-(void)drawQueueBar {
    
    for (CharacterHeadView *sprite in queueBarSprit) {
        [self removeChild:sprite cleanup:YES];
    }
    [queueBarSprit removeAllObjects];
    
    NSArray *characterArray = [self.queue currentCharacterQueueArray];
    int count = characterArray.count;
    for (int i=0; i<count; i++) {
        Character *character = [characterArray objectAtIndex:i];
        CharacterHeadView *characterHeadView = [[CharacterHeadView alloc] initWithCharacter:character];
        [queueBarSprit addObject:characterHeadView];
    }
    [tableView reloadData];
    [tableView moveToTop];
}

-(void)setCCSelectSprite {
    selectSprite = [[CCSprite alloc] initWithFile:@"currentCharacter.png"];
    selectSprite.anchorPoint = ccp(0.5,0.5);
    selectSprite.visible = NO;
    [self addChild:selectSprite];
}

-(void)redrawQueueBar {
    [self drawQueueBar];
}

-(void)insertCharacter {
    //TODO: Show Insert Animation.
    [self drawQueueBar];
}

-(void)removeCharacter {
    //TODO: Show Remove Animation.
    [self drawQueueBar];
}

- (void)setTable {
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
    [tableView reloadData];
    [tableView moveToTop];
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
    
    CCSprite *sprite = [queueBarSprit objectAtIndex:idx];
    CCSprite *newSprite = [CCSprite spriteWithTexture:[sprite texture] rect:[sprite textureRect]];
    newSprite.anchorPoint = ccp(0,0.5);
    newSprite.position = ccp(0, tableviewCellHeight/2);
    newSprite.tag = idx;
    [cell addChild:newSprite];
    
    return cell;
}
-(NSUInteger)numberOfCellsInTableView:(SWTableView *)table {
    return queueBarSprit.count;
}

#pragma mark SWTableViewDelegate
-(void)table:(SWTableView *)table cellTouched:(SWTableViewCell *)cell {
    CCSprite *sprite = [cell.children objectAtIndex:0];
    [self selectSpriteForTouchFromCell:sprite];
}

-(void)selectSpriteForTouchFromCell:(CCSprite *)sprite {
    
}

@end
