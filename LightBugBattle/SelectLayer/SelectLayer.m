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

#pragma mark - SelectLayer

@interface SelectLayer()
{
    BOOL isSelecting;
    int currentRoleIndex;
    int nextRoleIndex;
    
    CCSprite * selSprite;
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
        
        [self SetLabelsAndMenu];
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

- (void)SetLabelsAndMenu
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

-(NSArray *)loadAllRoleCanUse // load data from file
{
    int number = 7;
    NSMutableArray *allRoleCanUse = [[NSMutableArray alloc] initWithCapacity:number];
    
    CCSprite * role1 = [CCSprite spriteWithFile:@"amg1_fr2.gif"];
    CCSprite * role2 = [CCSprite spriteWithFile:@"ftr1_fr1.gif"];
    CCSprite * role3 = [CCSprite spriteWithFile:@"avt4_fr1.gif"];
    CCSprite * role4 = [CCSprite spriteWithFile:@"bmg1_fr2.gif"];
    CCSprite * role5 = [CCSprite spriteWithFile:@"chr1_fr2.gif"];
    CCSprite * role6 = [CCSprite spriteWithFile:@"gsd1_fr2.gif"];
    CCSprite * role7 = [CCSprite spriteWithFile:@"jli1_fr2.gif"];
    
    role1.tag = role1Tag;
    role2.tag = role2Tag;
    role3.tag = role3Tag;
    role4.tag = role4Tag;
    role5.tag = role5Tag;
    role6.tag = role6Tag;
    role7.tag = role7Tag;
    
    
    [allRoleCanUse addObject:role1];
    [allRoleCanUse addObject:role2];
    [allRoleCanUse addObject:role3];
    [allRoleCanUse addObject:role4];
    [allRoleCanUse addObject:role5];
    [allRoleCanUse addObject:role6];
    [allRoleCanUse addObject:role7];
    
    return allRoleCanUse;
}

- (void)loadAllRolesCanBeSelected
{
    NSArray *allRoleCanUse = [self loadAllRoleCanUse];
    
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

// =================== select roles methods ============

-(BOOL)canPutRoles {
    return YES;
}

#pragma mark draw character methods
//=============== add and remove character methods ===============
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

#pragma touch
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
