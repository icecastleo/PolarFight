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

#pragma mark - SelectLayer

typedef enum {
    mainRoleTag = 1001
} RolesTag;

@interface SelectLayer() {
    BOOL isSelecting;
    int currentRoleIndex;
    int nextRoleIndex;
    
    NSArray *characterParty;
    CCSprite * selSprite;
    
    CharacterInfoView *_characterInfoView;
}

@end

@implementation SelectLayer

static const int totalRoleNumber = 6;
static const int mainRolePosition = 0;
static const int nilRoleTag = 100;
static const int characterMinNumber = 1;

+(CCScene *) scene {
	CCScene *scene = [CCScene node];
    
	SelectLayer *layer = [SelectLayer node];
	[scene addChild: layer];
    
	return scene;
}

-(id) init {
    if( (self=[super initWithColor:ccc4(255, 255, 255, 255)]) ) {
                
        // 1 - Initialize
        self.isTouchEnabled = YES;
        
        CharacterInfoView *characterInfoView = [CharacterInfoView node];
        _characterInfoView = characterInfoView;
        [self addChild:_characterInfoView z:1];
        
        [self SetLabels];
        [self SetMenu];
        [self initAllSelectableRoles];
        [self initAllSelectedRoles];
        [self putMainRole];
        [self loadAllRolesCanBeSelected];
        
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

- (void)initAllSelectableRoles {
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"UnSelectedRolesPosition" ofType:@"plist"];
    NSArray * rolePositions = [NSArray arrayWithContentsOfFile:plistPath];
    allRoleBases = [[NSMutableArray alloc] initWithCapacity:10];
    
    for(NSDictionary * rolePos in rolePositions)
    {
        CCSprite * roleBase = [CCSprite spriteWithFile:@"open_spot.jpg"];
        
        [roleBase setPosition:ccp([[rolePos objectForKey:@"x"] intValue],[[rolePos objectForKey:@"y"] intValue])];
        
        roleBase.tag = nilRoleTag;
        
        [self addChild:roleBase];
        [allRoleBases addObject:roleBase];
    }
}

- (void)initAllSelectedRoles {
    isSelecting = NO;
    currentRoleIndex = mainRolePosition;
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

-(void)putMainRole {
    CCSprite *oldMainRole = [self.selectedRoles objectAtIndex:mainRolePosition];
    
    CCSprite *mainRole = [CCSprite spriteWithFile:@"mainRole.jpg"];
    mainRole.tag = mainRoleTag; //should put main roles Tag
    
    if (oldMainRole.tag == nilRoleTag) {
    
        [self replaceOldRole:oldMainRole newCharacter:mainRole inArray:self.selectedRoles index:mainRolePosition];
        nextRoleIndex = mainRolePosition + 1;
    }
}

//FIXME: load All Roles From File
-(NSArray *)loadAllRolesFromFile // load data from file
{
    NSMutableArray *characterSprites = [[NSMutableArray alloc] init];
    NSArray *characters = [self loadAllCharacterFromFile];
    
    int count = characters.count;
    for (int i=0; i < count; i++) {
        Character *chr = [characters objectAtIndex:i];
        CCTexture2D *tx = [chr.sprite texture];
        CCSprite * sprite = [CCSprite spriteWithTexture:tx];
        sprite.tag = i;
        [characterSprites addObject:sprite];
        if (i==0) {
            [self showCharacterInfo:sprite];
        }
    }
    return characterSprites;
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
    NSArray *characterSpritParty = [self loadAllRolesFromFile];
    
    for(int i = 0; i < characterSpritParty.count; i++)
    {
        if ([[allRoleBases objectAtIndex:i] tag]) {
            if ([[allRoleBases objectAtIndex:i] tag] == nilRoleTag){
                CCSprite *newRole = [characterSpritParty objectAtIndex:i];
                newRole.tag = i;
                
                [self replaceOldRole:[allRoleBases objectAtIndex:i] newCharacter:newRole inArray:allRoleBases index:i];
            }
        }
    }
}

//select roles methods
-(BOOL)canPutRoles {
    return YES;
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

#pragma mark touch
- (void)selectSpriteForTouch:(CGPoint)touchLocation {
    CCSprite * newSprite = nil;
    for (CCSprite *sprite in allRoleBases) {
        if(sprite.tag != nilRoleTag)
        {
            if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {
                newSprite = sprite;
                break;
            }
        }
    }
    if (newSprite != selSprite) {
        [self showCharacterInfo:newSprite];
        [self shakyShaky:newSprite];
        selSprite = newSprite;
    }
    if (!newSprite) {
        [self selectRolesInReadyArrayForTouch:touchLocation];
    }else{
        [self addRole:newSprite];
    }
}

- (void)selectRolesInReadyArrayForTouch:(CGPoint)touchLocation {
    CCSprite * newSprite = nil;
    for (CCSprite *sprite in self.selectedRoles) {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {
            if ([self.selectedRoles indexOfObject:sprite] !=0 ) {
                newSprite = sprite;
                currentRoleIndex = [self.selectedRoles indexOfObject:sprite];
                isSelecting = YES;
            }
            break;
        }
    }
    if (newSprite != selSprite) {
        [self showCharacterInfo:newSprite];
        [self shakyShaky:newSprite];
        selSprite = newSprite;
    }
}

- (void)shakyShaky:(CCSprite *) newSprite {
    [selSprite stopAllActions];
    [selSprite runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
    CCRotateTo * rotLeft = [CCRotateBy actionWithDuration:0.1 angle:-4.0];
    CCRotateTo * rotCenter = [CCRotateBy actionWithDuration:0.1 angle:0.0];
    CCRotateTo * rotRight = [CCRotateBy actionWithDuration:0.1 angle:4.0];
    CCSequence * rotSeq = [CCSequence actions:rotLeft, rotCenter, rotRight, rotCenter, nil];
    [newSprite runAction:[CCRepeatForever actionWithAction:rotSeq]];
}

- (void)showCharacterInfo:(CCSprite *) newSprite {
    if (newSprite.tag > characterParty.count)
        return;
    Character *role = [characterParty objectAtIndex:newSprite.tag];
    [_characterInfoView setValueForLabels:role];
}

- (void)addRole:(CCSprite *)sprite {
    if (isSelecting) {
        nextRoleIndex = currentRoleIndex;
        isSelecting = NO;
    }else if ([self IsPositionFull]) {
        return;
    }

    CCTexture2D *tx = [sprite texture];
    CCSprite *newSprite = [CCSprite spriteWithTexture:tx];
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

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];
}

- (void)startMenuDidPress {
    NSMutableArray *saveCharacterArray = [[NSMutableArray alloc] init];
    for (CCSprite *sprite in self.selectedRoles) {
        if (sprite.tag != nilRoleTag && sprite.tag != mainRoleTag) {
            Character *chr = [characterParty objectAtIndex:sprite.tag];
            [saveCharacterArray addObject:chr];
        }
    }
    
    if (saveCharacterArray.count < characterMinNumber) {
        for (Character *chr in saveCharacterArray) {
            NSLog(@"Character name :: %@", chr.name);
        }
    }else {
        [PartyParser saveParty:saveCharacterArray fileName:@"SelectedCharacters.xml"];
        [[CCDirector sharedDirector] replaceScene:[BattleController node]];
    }
}

@end
