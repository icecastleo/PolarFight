//
//  SelectLayer.m
//  LightBugBattle
//
//  Created by  浩翔 on 12/11/1.
//
//

#import "SelectLayer.h"
#import "HelloWorldLayer.h"
#import "BattleController.h"
#import "Character.h"
#import "PartyParser.h"
#import "GDataXMLNode.h"
#import "CharacterInfoView.h"
#import "MyCell.h"

@implementation SelectLayer

static const int totalRoleNumber = 5;
static const int nilRoleTag = 100;
static const int characterMinNumber = 1;
static const int tableviewWidth = 200;
static const int tableviewHeight = 180;
static const int tableviewCellHeight = 50;
static const int tableviewPositionX = 20;
static const int tableviewPositionY = 100;
static const int tableviewPositionZ = 100;

+(CCScene *) scene {
	CCScene *scene = [CCScene node];
    
	SelectLayer *layer = [SelectLayer node];
	[scene addChild: layer];
    
	return scene;
}

#pragma mark Init Methods
-(id) init {
    if( (self=[super init]) ) {
        
        backgroundLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)]; //white color
        [self addChild:backgroundLayer];
        
        // 1 - Initialize
        self.isTouchEnabled = YES;
        
        characterInfoView = [CharacterInfoView node];
        [self addChild:characterInfoView z:1];
        
        [self SetLabels];
        [self SetMenu];
        [self initAllSelectedRoles];
        [self loadAllRolesCanBeSelected];
        [self setTable];
        
        [[CCDirector sharedDirector] setDisplayStats:NO];
        
	}
	return self;
}
- (void)SetLabels {
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    
    NSString *currentLevel = [self loadCurrentLevel];
    NSString *currentGoal = [self loadCurrentGoal];
    NSString *currentMoney = [self loadCurrentMoney];
    
    CCLabelTTF *levelLabel = [CCLabelTTF labelWithString:currentLevel fontName:@"Marker Felt" fontSize:20];
    levelLabel.position =  ccp( 0 , windowSize.height);
    levelLabel.anchorPoint = CGPointMake(0, 1);
    levelLabel.color = ccBLACK;
    [self addChild: levelLabel];
    
    CCLabelTTF *goalLabel = [CCLabelTTF labelWithString:currentGoal fontName:@"Marker Felt" fontSize:20];
    goalLabel.position =  ccp( windowSize.width/2 , windowSize.height);
    goalLabel.anchorPoint = CGPointMake(0.5, 1);
    goalLabel.color = ccBLACK;
    [self addChild: goalLabel];
    
    CCLabelTTF *moneyLabel = [CCLabelTTF labelWithString:currentMoney fontName:@"Marker Felt" fontSize:20];
    moneyLabel.position =  ccp( windowSize.width , windowSize.height);
    moneyLabel.anchorPoint = CGPointMake(1, 1);
    moneyLabel.color = ccBLACK;
    [self addChild: moneyLabel];
}
- (void)SetMenu {
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    
    [CCMenuItemFont setFontSize:26];
    
    CCMenuItem *cancelMenuItem = [CCMenuItemFont itemWithString:@"取消任務" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer node]];
    }];
    
    CCMenuItem *startMenuItem = [CCMenuItemFont itemWithString:@"開始任務" block:^(id sender) {
        [self startMenuDidPress];
    }];
    
    CCMenu *menu = [CCMenu menuWithItems:cancelMenuItem, startMenuItem, nil];
    menu.color = ccBLACK;
    
    [menu alignItemsHorizontallyWithPadding:20];
    [menu setPosition:ccp( windowSize.width*3/4, 20 )];
    // Add the menu to the layer
    [self addChild:menu];
}
- (void)initAllSelectedRoles {
    isSelecting = NO;
    currentRoleIndex = 0;
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"SelectedRolesPostion" ofType:@"plist"];
    NSArray * rolePositions = [NSArray arrayWithContentsOfFile:plistPath];
    self.selectedRoles = [[NSMutableArray alloc] initWithCapacity:totalRoleNumber];
    
    for(NSDictionary * rolePos in rolePositions) {
        CCSprite * roleBase;
        roleBase = [CCSprite spriteWithFile:@"open_spot.jpg"];
        [roleBase setPosition:ccp([[rolePos objectForKey:@"x"] intValue],[[rolePos objectForKey:@"y"] intValue])];
        roleBase.tag = nilRoleTag;
        [self.selectedRoles addObject:roleBase];
        [self addChild:roleBase];
    }
}
- (void)setTable {
    CCLayerColor *layer = [CCLayerColor layerWithColor:ccc4(77, 31, 0, 225)];  //coffee color
    
    CGSize tableSize;
    CGPoint tablePosition;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]
        && [[UIScreen mainScreen] scale] == 2.0) {
        // Retina
        tableSize = CGSizeMake(tableviewWidth,tableviewHeight);
        tablePosition = ccp(tableviewPositionX*2,tableviewPositionY*2);
    } else {
        // Not Retina
        tableSize = CGSizeMake(tableviewWidth,tableviewHeight);
        tablePosition = ccp(tableviewPositionX,tableviewPositionY);
    }
    
    tableView = [SWTableView viewWithDataSource:self size:tableSize];
    
    tableView.verticalFillOrder = SWTableViewFillTopDown;
    tableView.direction = SWScrollViewDirectionVertical;
    tableView.position = tablePosition;
    tableView.delegate = self;
    tableView.bounces = YES;
    
    
    layer.contentSize		 = tableView.contentSize;
    
    [tableView addChild:layer];
    
    [self addChild:tableView z:tableviewPositionZ];
    [tableView reloadData];
    [tableView moveToTop];
}

#pragma LoadData
- (NSString *)loadCurrentLevel {
    //load data from file...
    return @"Level: 1";
}
- (NSString *)loadCurrentGoal {
    //load data from file...
    return @"Goal: Who let the dogs out?";
}
- (NSString *)loadCurrentMoney {
    //load data from file...
    return @"Money: 100元";
}
-(NSArray *)loadAllCharacterFromFile {
    NSArray *characterIdArray = [PartyParser getAllNodeFromXmlFile:@"Save.xml" tagAttributeName:@"ol" tagName:@"character"];
    NSMutableArray *characters = [[NSMutableArray alloc] init];
    for (NSString *characterId in characterIdArray) {
        Character *character = [[Character alloc] initWithXMLElement:[PartyParser getNodeFromXmlFile:@"Save.xml" tagName:@"character" tagAttributeName:@"ol" tagId:characterId]];
        [characters addObject:character];
    }
    return characters;
}
- (void)loadAllRolesCanBeSelected {
    characterParty = [self loadAllCharacterFromFile];
    if ([[characterParty objectAtIndex:0] isKindOfClass:[Character class]]) {
        Character *character = [characterParty objectAtIndex:0];
        character.sprite.tag = 0;
        [self showCharacterInfo:character.sprite];
    }
}

#pragma mark draw character methods
- (void)replaceOldRole:(CCSprite*)oldCharacter newCharacter:(CCSprite*)newCharacter inArray:(NSMutableArray *)selectedArray index:(int)index {
    
    [self addCharacter:newCharacter toPosition:oldCharacter.position];
    [selectedArray replaceObjectAtIndex:index withObject:newCharacter];
    [self removeCharacter:oldCharacter];
    
    if ([selectedArray isEqualToArray:self.selectedRoles]) {
        currentRoleIndex = index;
    }
}
-(void) addCharacter:(CCSprite*)character toPosition:(CGPoint)position{
    
    character.position = position;
    [self addChild:character];
}
-(void)removeCharacter:(CCSprite *)character {
    [character removeFromParentAndCleanup:YES];
}

#pragma mark add character To selectedArray
- (void)addRole:(CCSprite *)sprite {
    if (isSelecting) {
        nextRoleIndex = currentRoleIndex;
        isSelecting = NO;
    }else if ([self IsPositionFull]) {
        return;
    }
    
    CCSprite *newSprite = [CCSprite spriteWithTexture:[sprite texture] rect:[sprite textureRect]];
    
    newSprite.tag = sprite.tag;
    
    [self replaceOldRole:[self.selectedRoles objectAtIndex:nextRoleIndex] newCharacter:newSprite inArray:self.selectedRoles index:nextRoleIndex];
    
    for (CCSprite *sprite in self.selectedRoles) {
        if (sprite.tag == nilRoleTag) {
            nextRoleIndex = [self.selectedRoles indexOfObject:sprite];
            break;
        }
    }
    
}
- (BOOL)IsPositionFull {
    for (CCSprite *sprite in self.selectedRoles) {
        if (sprite.tag == nilRoleTag) {
            return NO;
        }
    }
    return YES;
}

#pragma mark touch
- (void)selectSpriteForTouchFromCell:(CCSprite *)sprite {
    CCSprite * newSprite = nil;
    if(sprite.tag != nilRoleTag) {
        newSprite = sprite;
    }
    if (newSprite != selSprite) {
        [self showCharacterInfo:newSprite];
        [self shakyShaky:newSprite];
        selSprite = newSprite;
    }
    if (newSprite)
        [self addRole:newSprite];
}
- (void)selectRolesInReadyArrayForTouch:(CGPoint)touchLocation {
    CCSprite * newSprite = nil;
    for (CCSprite *sprite in self.selectedRoles) {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {
            newSprite = sprite;
            currentRoleIndex = [self.selectedRoles indexOfObject:sprite];
            isSelecting = YES;
            break;
        }
    }
    if (newSprite != selSprite) {
        [self showCharacterInfo:newSprite];
        [self shakyShaky:newSprite];
        selSprite = newSprite;
    }
}
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectRolesInReadyArrayForTouch:touchLocation];
}

#pragma mark Animation
- (void)shakyShaky:(CCSprite *) newSprite {
    [selSprite stopAllActions];
    [selSprite runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
    CCRotateTo * rotLeft = [CCRotateBy actionWithDuration:0.1 angle:-4.0];
    CCRotateTo * rotCenter = [CCRotateBy actionWithDuration:0.1 angle:0.0];
    CCRotateTo * rotRight = [CCRotateBy actionWithDuration:0.1 angle:4.0];
    CCSequence * rotSeq = [CCSequence actions:rotLeft, rotCenter, rotRight, rotCenter, nil];
    [newSprite runAction:[CCRepeatForever actionWithAction:rotSeq]];
}

#pragma mark showCharacterInfo
- (void)showCharacterInfo:(CCSprite *) newSprite {
    if (!newSprite)
        return;
    if (newSprite.tag > characterParty.count)
        return;
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    Character *role = [characterParty objectAtIndex:newSprite.tag];
    [characterInfoView showInfoFromCharacter:role loacation:CGPointMake(winSize.width/2 + winSize.width/48, winSize.height/4) needBackGround:NO];
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
    
    Character *character = [characterParty objectAtIndex:idx];
    CCSprite *sprite = character.sprite;
    
    CCSprite *newSprite = [CCSprite spriteWithTexture:[sprite texture] rect:[sprite textureRect]];
    newSprite.position = ccp(65, 20);
    newSprite.tag = idx;
    NSLog(@"%d.%@:",idx,character.name);
    [cell addChild:newSprite];

    return cell;
}
-(NSUInteger)numberOfCellsInTableView:(SWTableView *)table {
    
    return characterParty.count;
}

#pragma mark SWTableViewDelegate
-(void)table:(SWTableView *)table cellTouched:(SWTableViewCell *)cell {
    CCSprite *sprite = [cell.children objectAtIndex:0];
    [self selectSpriteForTouchFromCell:sprite];
}

#pragma mark Transit To Next Scene
- (void)startMenuDidPress {
    NSMutableArray *saveCharacterArray = [[NSMutableArray alloc] init];
    for (CCSprite *sprite in self.selectedRoles) {
        if (sprite.tag != nilRoleTag) {
            Character *chr = [characterParty objectAtIndex:sprite.tag];
            [saveCharacterArray addObject:chr];
        }
    }
    
    if (saveCharacterArray.count < characterMinNumber) {
        CCLOG(@"you don't choose any character.");
    }else {
        [PartyParser saveParty:saveCharacterArray fileName:@"SelectedCharacters.xml"];
        [[CCDirector sharedDirector] replaceScene:[BattleController node]];
    }
}

@end
