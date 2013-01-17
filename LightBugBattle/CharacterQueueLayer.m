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
    NSArray *headViewPointArray;
    NSMutableArray *queueBarSprit;
    
    CCSprite *selectSprite;
    CCAction *selectAction;
}
@property (nonatomic) CharacterQueue *queue;
@end

@implementation CharacterQueueLayer

static const int currentCharacterHeadViewTag = 999;

-(id)initWithQueue:(CharacterQueue *)aQueue {
    if ((self = [super init])) {
        _queue = aQueue;
        _queue.delegate = self;
        queueBarSprit = [[NSMutableArray alloc] init];
        [self setCCSelectSprite];
        [self setQueueBar];
        [self drawQueueBar];
    }
    return self;
}

-(void)setQueueBar {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    //winSize.width/2, winSize.height*restartLabelY/labelsCount
    CGPoint currentCharacterHeadView = CGPointMake(winSize.width/48, winSize.height*currentCharacterHeadViewPosition/labelsCount);
    CGPoint firstCharacterHeadView = CGPointMake(winSize.width/48, winSize.height*firstCharacterHeadViewPosition/labelsCount);
    CGPoint secondCharacterHeadView = CGPointMake(winSize.width/48, winSize.height*secondCharacterHeadViewPosition/labelsCount);
    CGPoint thirdCharacterHeadView = CGPointMake(winSize.width/48, winSize.height*thirdCharacterHeadViewPosition/labelsCount);
    CGPoint fourthCharacterHeadView = CGPointMake(winSize.width/48, winSize.height*fourthCharacterHeadViewPosition/labelsCount);
    CGPoint fifthCharacterHeadView = CGPointMake(winSize.width/48, winSize.height*fifthCharacterHeadViewPosition/labelsCount);
    
    NSValue *point0Value = [NSValue valueWithCGPoint:currentCharacterHeadView];
    NSValue *point1Value = [NSValue valueWithCGPoint:firstCharacterHeadView];
    NSValue *point2Value = [NSValue valueWithCGPoint:secondCharacterHeadView];
    NSValue *point3Value = [NSValue valueWithCGPoint:thirdCharacterHeadView];
    NSValue *point4Value = [NSValue valueWithCGPoint:fourthCharacterHeadView];
    NSValue *point5Value = [NSValue valueWithCGPoint:fifthCharacterHeadView];
    
    headViewPointArray = [[NSArray alloc] initWithObjects:point0Value,point1Value,point2Value,point3Value,point4Value,point5Value, nil];
}

-(void)setCurrentCharacter:(Character *)currentCharacter {
    [self removeChildByTag:currentCharacterHeadViewTag cleanup:YES];
    CharacterHeadView *characterHeadView = [[CharacterHeadView alloc] initWithCharacter:currentCharacter];
    if (!characterHeadView) {
        NSAssert(characterHeadView !=nil , @"character's headImage should not nil.");
        return;
    }
    CGPoint currentHeadViewPoint = [[headViewPointArray objectAtIndex:currentCharacterIndex] CGPointValue];
    characterHeadView.position = currentHeadViewPoint;
    characterHeadView.anchorPoint = ccp(0,0.5);
    characterHeadView.tag = currentCharacterHeadViewTag;
    selectSprite.position = currentHeadViewPoint;
    selectSprite.visible = YES;

    [self addChild:characterHeadView];
}

-(void)drawQueueBar {
    
    for (CharacterHeadView *sprite in queueBarSprit) {
        [self removeChild:sprite cleanup:YES];
    }
    
    NSArray *characterArray = [self.queue currentCharacterQueueArray];
    int count = characterArray.count;
    for (int i=0; i<count; i++) {
        Character *character = [characterArray objectAtIndex:i];
        CharacterHeadView *characterHeadView = [[CharacterHeadView alloc] initWithCharacter:character];
        if ((i+1) < headViewPointArray.count) {
            CGPoint headViewPoint = [[headViewPointArray objectAtIndex:i+1] CGPointValue];
            characterHeadView.position = headViewPoint;
            characterHeadView.anchorPoint = ccp(0,0.5);
            [self addChild:characterHeadView];
            [queueBarSprit addObject:characterHeadView];
        }else {
            break;
        }
    }
}

-(void)setCCSelectSprite {
    selectSprite = [[CCSprite alloc] initWithFile:@"select-3.png"];
    selectSprite.anchorPoint = ccp(0.25,0.5);
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

@end
