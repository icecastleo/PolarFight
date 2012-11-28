//
//  SelectLayer.m
//  LightBugBattle
//
//  Created by  浩翔 on 12/11/1.
//
//

#import "SelectLayer.h"
#import "Constant.h"

#import "HelloWorldLayer.h"
#import "BattleController.h"
#import "PartyParser.h"
#import "Role.h"
#import "Character.h"

#pragma mark - SelectLayer

typedef enum {
    //nameLabelTag = 0,
    levelLabelTag = 0,
    hpLabelTag,
    attackLabelTag,
    defenseLabelTag,
    speedLabelTag,
    moveSpeedLabelTag,
    moveTimeLabelTag
} LabelTags;


typedef enum {
    mainRoleTag = 1001
} RolesTag;

@interface SelectLayer()
{
    BOOL isSelecting;
    int currentRoleIndex;
    int nextRoleIndex;
    //Party *party;
    NSMutableArray *pool;
    
    CCSprite * selSprite;
    
    int rolelevel;
    int hp;
    int attack;
    int defense;
    int speed;
    int moveSpeed;
    int moveTime;
    
    CCNode<CCLabelProtocol>* levelLbBM;
    CCNode<CCLabelProtocol>* hpLbBM;
    CCNode<CCLabelProtocol>* attackLbBM;
    CCNode<CCLabelProtocol>* defenseLbBM;
    CCNode<CCLabelProtocol>* speedLbBM;
    CCNode<CCLabelProtocol>* moveSpeedLbBM;
    CCNode<CCLabelProtocol>* moveTimeLbBM;
}

@end

@implementation SelectLayer

static const int totalRoleNumber = 6;
static const int mainRolePosition = 0;
static const int nilRoleTag = 100;
//static const int mainRoleTag = 1001;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	SelectLayer *layer = [SelectLayer node];
	[scene addChild: layer];
    
	return scene;
}

-(id) init
{
    if( (self=[super initWithColor:ccc4(255, 255, 255, 255)]) ) {
                
        // 1 - Initialize
        self.isTouchEnabled = YES;
        
        self.selectedRoles = [[NSMutableArray alloc] initWithCapacity:totalRoleNumber];
        
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

- (void) dealloc
{
	[super dealloc];
}

- (void)SetLabels
{
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
    
    int i = 10;
    
    CCLabelTTF *roleLevelLabel = [CCLabelTTF labelWithString:@"Level:" fontName:@"Marker Felt" fontSize:20];
    roleLevelLabel.position =  ccp( windowSize.width*5/6 , windowSize.height*i/12);
    roleLevelLabel.anchorPoint = CGPointMake(1, 0);
    roleLevelLabel.color = ccBLACK;
    roleLevelLabel.tag = levelLabelTag;
    [self addChild: roleLevelLabel];
    levelLbBM = [CCLabelBMFont labelWithString:@"0" fntFile:@"TestFont.fnt"];
    levelLbBM.position =  ccp( windowSize.width*11/12 , windowSize.height*i/12);
    levelLbBM.anchorPoint = CGPointMake(0.5, 0);
    [self addChild:levelLbBM z:1];
    i--;
    CCLabelTTF *hpLabel = [CCLabelTTF labelWithString:@"Hp:" fontName:@"Marker Felt" fontSize:20];
    hpLabel.position =  ccp( windowSize.width*5/6 , windowSize.height*i/12);
    hpLabel.anchorPoint = CGPointMake(1, 0);
    hpLabel.color = ccBLACK;
    hpLabel.tag = hpLabelTag;
    [self addChild: hpLabel];
    hpLbBM = [CCLabelBMFont labelWithString:@"0" fntFile:@"TestFont.fnt"];
    hpLbBM.position =  ccp( windowSize.width*11/12 , windowSize.height*i/12);
    hpLbBM.anchorPoint = CGPointMake(0.5, 0);
    [self addChild:hpLbBM z:1];
    i--;
    CCLabelTTF *attackLabel = [CCLabelTTF labelWithString:@"Attack:" fontName:@"Marker Felt" fontSize:20];
    attackLabel.position =  ccp( windowSize.width*5/6 , windowSize.height*i/12);
    attackLabel.anchorPoint = CGPointMake(1, 0);
    attackLabel.color = ccBLACK;
    attackLabel.tag = attackLabelTag;
    [self addChild: attackLabel];
    attackLbBM = [CCLabelBMFont labelWithString:@"0" fntFile:@"TestFont.fnt"];
    attackLbBM.position =  ccp( windowSize.width*11/12 , windowSize.height*i/12);
    attackLbBM.anchorPoint = CGPointMake(0.5, 0);
    [self addChild:attackLbBM z:1];
    i--;
    CCLabelTTF *defenseLabel = [CCLabelTTF labelWithString:@"Defense:" fontName:@"Marker Felt" fontSize:20];
    defenseLabel.position =  ccp( windowSize.width*5/6 , windowSize.height*i/12);
    defenseLabel.anchorPoint = CGPointMake(1, 0);
    defenseLabel.color = ccBLACK;
    defenseLabel.tag = defenseLabelTag;
    [self addChild: defenseLabel];
    defenseLbBM = [CCLabelBMFont labelWithString:@"0" fntFile:@"TestFont.fnt"];
    defenseLbBM.position =  ccp( windowSize.width*11/12 , windowSize.height*i/12);
    defenseLbBM.anchorPoint = CGPointMake(0.5, 0);
    [self addChild:defenseLbBM z:1];
    i--;
    CCLabelTTF *speedLabel = [CCLabelTTF labelWithString:@"Speed:" fontName:@"Marker Felt" fontSize:20];
    speedLabel.position =  ccp( windowSize.width*5/6 , windowSize.height*i/12);
    speedLabel.anchorPoint = CGPointMake(1, 0);
    speedLabel.color = ccBLACK;
    speedLabel.tag = speedLabelTag;
    [self addChild: speedLabel];
    speedLbBM = [CCLabelBMFont labelWithString:@"0" fntFile:@"TestFont.fnt"];
    speedLbBM.position =  ccp( windowSize.width*11/12 , windowSize.height*i/12);
    speedLbBM.anchorPoint = CGPointMake(0.5, 0);
    [self addChild:speedLbBM z:1];
    i--;
    CCLabelTTF *moveSpeedLabel = [CCLabelTTF labelWithString:@"MoveSpeed:" fontName:@"Marker Felt" fontSize:20];
    moveSpeedLabel.position =  ccp( windowSize.width*5/6 , windowSize.height*i/12);
    moveSpeedLabel.anchorPoint = CGPointMake(1, 0);
    moveSpeedLabel.color = ccBLACK;
    moveSpeedLabel.tag = moveSpeedLabelTag;
    [self addChild: moveSpeedLabel];
    moveSpeedLbBM = [CCLabelBMFont labelWithString:@"0" fntFile:@"TestFont.fnt"];
    moveSpeedLbBM.position =  ccp( windowSize.width*11/12 , windowSize.height*i/12);
    moveSpeedLbBM.anchorPoint = CGPointMake(0.5, 0);
    [self addChild:moveSpeedLbBM z:1];
    i--;
    CCLabelTTF *moveTimeLabel = [CCLabelTTF labelWithString:@"MoveTime:" fontName:@"Marker Felt" fontSize:20];
    moveTimeLabel.position =  ccp( windowSize.width*5/6 , windowSize.height*i/12);
    moveTimeLabel.anchorPoint = CGPointMake(1, 0);
    moveTimeLabel.color = ccBLACK;
    moveTimeLabel.tag = moveTimeLabelTag;
    [self addChild: moveTimeLabel];
    moveTimeLbBM = [CCLabelBMFont labelWithString:@"0" fntFile:@"TestFont.fnt"];
    moveTimeLbBM.position =  ccp( windowSize.width*11/12 , windowSize.height*i/12);
    moveTimeLbBM.anchorPoint = CGPointMake(0.5, 0);
    [self addChild:moveTimeLbBM z:1];
    
}

- (void)SetMenu
{
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    
    [CCMenuItemFont setFontSize:26];
    
    CCMenuItem *cancelMenuItem = [CCMenuItemFont itemWithString:@"取消任務" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer node]];
    }];
    
    CCMenuItem *startMenuItem = [CCMenuItemFont itemWithString:@"開始任務" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[BattleController node]];
    }];
    
    CCMenu *menu = [CCMenu menuWithItems:cancelMenuItem, startMenuItem, nil];
    menu.color = ccBLACK;
    
    [menu alignItemsHorizontallyWithPadding:20];
    [menu setPosition:ccp( windowSize.width*3/4, 20 )];
    // Add the menu to the layer
    [self addChild:menu];
}

- (void)initAllSelectableRoles
{
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

- (void)initAllSelectedRoles
{
    isSelecting = NO;
    currentRoleIndex = mainRolePosition;
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"SelectedRolesPostion" ofType:@"plist"];
    NSArray * rolePositions = [NSArray arrayWithContentsOfFile:plistPath];
    self.selectedRoles = [[NSMutableArray alloc] initWithCapacity:totalRoleNumber];
    
    for(NSDictionary * rolePos in rolePositions)
    {
        CCSprite * roleBase;
        roleBase = [CCSprite spriteWithFile:@"open_spot.jpg"];
        [roleBase setPosition:ccp([[rolePos objectForKey:@"x"] intValue],[[rolePos objectForKey:@"y"] intValue])];
        roleBase.tag = nilRoleTag;
        [self.selectedRoles addObject:roleBase];
        [self addChild:roleBase];
    }
}

#pragma LoadData

- (NSString *)loadCurrentLevel
{
    //load data from file...
    return @"Level: 1";
}

- (NSString *)loadCurrentGoal
{
    //load data from file...
    return @"Goal: Who let the dogs out?";
}

- (NSString *)loadCurrentMoney
{
    //load data from file...
    return @"Money: 100元";
}

-(void)putMainRole
{
    CCSprite *oldMainRole = [self.selectedRoles objectAtIndex:mainRolePosition];
    
    CCSprite *mainRole = [CCSprite spriteWithFile:@"mainRole.jpg"];
    mainRole.tag = mainRoleTag; //should put main roles Tag
    
    if (oldMainRole.tag == nilRoleTag) {
    
        [self replaceOldRole:oldMainRole newCharacter:mainRole inArray:self.selectedRoles index:mainRolePosition];
        nextRoleIndex = mainRolePosition + 1;
    }
}

-(NSArray *)loadAllRolesFromFile // load data from file
{
    //party = [[PartyParser loadParty] retain];
    NSArray *party = [[PartyParser getRolesArrayFromXMLFile] autorelease];
    NSAssert(party != nil, @"party is nil");
    
    int count = party.count;
    pool = [[[NSMutableArray alloc] initWithCapacity:count] retain];
    NSMutableArray *roles = [[[NSMutableArray alloc] initWithCapacity:count] autorelease];
    
    for (int i = 0; i < count; i++) {
        Role *role = [party objectAtIndex:i];
        Character *character = [[Character alloc] initWithName:role.name fileName:role.picture];
        [character setCharacterWithVelocity:CGPointMake(0, -1)];
        CCSprite * sprite = character.sprite;
        sprite.tag = i;
        [roles addObject:sprite];
        [pool addObject:character];
        if (i==0) {
            [self showCharacterInfo:sprite];
        }
    }

//    for (int i = 0; i < count; i++) {
//        Character *role = [party.players objectAtIndex:i];
//        [role setCharacterWithVelocity:CGPointMake(0, -1)];
//        CCSprite * sprite = role.sprite;
//        sprite.tag = i;
//        [roles addObject:sprite];
//        if (i==0) {
//            [self showCharacterInfo:sprite];
//        }
//    }
    
    return roles;
}

- (void)loadAllRolesCanBeSelected
{
    NSArray *allRoleCanUse = [self loadAllRolesFromFile];
    
    for(int i = 0; i < allRoleCanUse.count; i++)
    {
        if ([[allRoleBases objectAtIndex:i] tag]) {
            if ([[allRoleBases objectAtIndex:i] tag] == nilRoleTag){
                CCSprite *newRole = [allRoleCanUse objectAtIndex:i];
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
- (void)replaceOldRole:(CCSprite*)oldCharacter newCharacter:(CCSprite*)newCharacter inArray:(NSMutableArray *)selectedArray index:(int)index
{
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
- (void)selectSpriteForTouch:(CGPoint)touchLocation
{
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

- (void)selectRolesInReadyArrayForTouch:(CGPoint)touchLocation
{
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

- (void)shakyShaky:(CCSprite *) newSprite
{
    [selSprite stopAllActions];
    [selSprite runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
    CCRotateTo * rotLeft = [CCRotateBy actionWithDuration:0.1 angle:-4.0];
    CCRotateTo * rotCenter = [CCRotateBy actionWithDuration:0.1 angle:0.0];
    CCRotateTo * rotRight = [CCRotateBy actionWithDuration:0.1 angle:4.0];
    CCSequence * rotSeq = [CCSequence actions:rotLeft, rotCenter, rotRight, rotCenter, nil];
    [newSprite runAction:[CCRepeatForever actionWithAction:rotSeq]];
}

- (void)showCharacterInfo:(CCSprite *) newSprite
{
    Character *role = [pool objectAtIndex:newSprite.tag];
    rolelevel = role.level;
    hp = role.maxHp;
    attack = role.attack;
    defense = role.defense;
    speed = role.speed;
    moveSpeed = role.moveSpeed;
    moveTime = role.moveTime;
    [levelLbBM setString:[NSString stringWithFormat:@"%i", rolelevel]];
    [hpLbBM setString:[NSString stringWithFormat:@"%i", hp]];
    [attackLbBM setString:[NSString stringWithFormat:@"%i", attack]];
    [defenseLbBM setString:[NSString stringWithFormat:@"%i", defense]];
    [speedLbBM setString:[NSString stringWithFormat:@"%i", speed]];
    [moveSpeedLbBM setString:[NSString stringWithFormat:@"%i", moveSpeed]];
    [moveTimeLbBM setString:[NSString stringWithFormat:@"%i", moveTime]];
}

- (void)addRole:(CCSprite *)sprite
{
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

- (BOOL)IsPositionFull
{
    for (CCSprite *sprite in self.selectedRoles) {
        if (sprite.tag == nilRoleTag) {
            return NO;
        }
    }
    return YES;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    [self selectSpriteForTouch:touchLocation];
}

@end
