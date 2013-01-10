//
//  CharacterInfoView.m
//  LightBugBattle
//
//  Created by  浩翔 on 13/1/4.
//
//

#import "cocos2d.h"
#import "CharacterInfoView.h"
#import "Character.h"

typedef enum {
    levelLabelTag = 0,
    hpLabelTag,
    attackLabelTag,
    defenseLabelTag,
    speedLabelTag,
    moveSpeedLabelTag,
    moveTimeLabelTag
} LabelTags;

@interface CharacterInfoView() {
//    CCLabelTTF *nameLbBM;
    CCNode<CCLabelProtocol>* levelLbBM;
    CCNode<CCLabelProtocol>* hpLbBM;
    CCNode<CCLabelProtocol>* attackLbBM;
    CCNode<CCLabelProtocol>* defenseLbBM;
    CCNode<CCLabelProtocol>* speedLbBM;
    CCNode<CCLabelProtocol>* moveSpeedLbBM;
    CCNode<CCLabelProtocol>* moveTimeLbBM;
}

@end

@implementation CharacterInfoView
//TODO: view appearance
//
-(id)init {
    
    if ((self = [super init])) {
    
        //CGSize winSize = [CCDirector sharedDirector].winSize;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            //_statusLabel = [CCLabelBMFont labelWithString:@"" fntFile:@"Arial-hd.fnt"];
        } else {
            //_statusLabel = [CCLabelBMFont labelWithString:@"" fntFile:@"Arial.fnt"];
        }
        //_statusLabel.position = ccp(winSize.width* 0.85, winSize.height * 0.9);
        //[self addChild:_statusLabel];
    }
    return self;
}
//*/
- (void)setLabels:(CGPoint)point {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCLayerColor *layer = [CCLayerColor layerWithColor:ccc4(180, 180, 255, 225)];
    layer.contentSize = CGSizeMake(winSize.width/2 - winSize.width/20, winSize.height*9/12);
    layer.position = point;
    [self addChild:layer];
    //CCLabelTTF *label = [CCLabelBMFont labelWithString:string fntFile:@""];
    int i = 0;
//    CCLabelTTF *roleNameLabel = [CCLabelTTF labelWithString:@"Name:" fontName:@"Marker Felt" fontSize:20];
//    roleNameLabel.position =  ccp( windowSize.width*70/120 , windowSize.height*i/12);
//    roleNameLabel.anchorPoint = CGPointMake(1, 0);
//    roleNameLabel.color = ccBLACK;
//    roleNameLabel.tag = levelLabelTag;
//    [self addChild: roleNameLabel];
//    nameLbBM = [CCLabelBMFont labelWithString:@"Nick" fntFile:@"TestFont.fnt"];
//    nameLbBM.position =  ccp( windowSize.width*95/120 , windowSize.height*i/12);
//    nameLbBM.anchorPoint = CGPointMake(0.5, 0);
//    [self addChild:nameLbBM z:1];
    i++;
    CCLabelTTF *moveTimeLabel = [CCLabelTTF labelWithString:@"MoveTime:" fontName:@"Marker Felt" fontSize:20];
    moveTimeLabel.position =  ccp( point.x + winSize.width/4, point.y + winSize.height/11*i);
    moveTimeLabel.anchorPoint = CGPointMake(1, 0);
    moveTimeLabel.color = ccBLACK;
    moveTimeLabel.tag = moveTimeLabelTag;
    [self addChild: moveTimeLabel];
    moveTimeLbBM = [CCLabelBMFont labelWithString:@"0" fntFile:@"TestFont.fnt"];
    moveTimeLbBM.position =  ccp( point.x + 150 , point.y + winSize.height/11*i);
    moveTimeLbBM.anchorPoint = CGPointMake(0.5, 0);
    [self addChild:moveTimeLbBM z:1];
    i++;
    CCLabelTTF *moveSpeedLabel = [CCLabelTTF labelWithString:@"MoveSpeed:" fontName:@"Marker Felt" fontSize:20];
    moveSpeedLabel.position =  ccp( point.x + winSize.width/4, point.y + winSize.height/11*i);
    moveSpeedLabel.anchorPoint = CGPointMake(1, 0);
    moveSpeedLabel.color = ccBLACK;
    moveSpeedLabel.tag = moveSpeedLabelTag;
    [self addChild: moveSpeedLabel];
    moveSpeedLbBM = [CCLabelBMFont labelWithString:@"0" fntFile:@"TestFont.fnt"];
    moveSpeedLbBM.position =  ccp( point.x + 150 , point.y + winSize.height/11*i);
    moveSpeedLbBM.anchorPoint = CGPointMake(0.5, 0);
    [self addChild:moveSpeedLbBM z:1];
    i++;
    CCLabelTTF *speedLabel = [CCLabelTTF labelWithString:@"Speed:" fontName:@"Marker Felt" fontSize:20];
    speedLabel.position =  ccp( point.x + winSize.width/4, point.y + winSize.height/11*i);
    speedLabel.anchorPoint = CGPointMake(1, 0);
    speedLabel.color = ccBLACK;
    speedLabel.tag = speedLabelTag;
    [self addChild: speedLabel];
    speedLbBM = [CCLabelBMFont labelWithString:@"0" fntFile:@"TestFont.fnt"];
    speedLbBM.position =  ccp( point.x + 150 , point.y + winSize.height/11*i);
    speedLbBM.anchorPoint = CGPointMake(0.5, 0);
    [self addChild:speedLbBM z:1];
    i++;
    CCLabelTTF *defenseLabel = [CCLabelTTF labelWithString:@"Defense:" fontName:@"Marker Felt" fontSize:20];
    defenseLabel.position =  ccp( point.x + winSize.width/4, point.y + winSize.height/11*i);
    defenseLabel.anchorPoint = CGPointMake(1, 0);
    defenseLabel.color = ccBLACK;
    defenseLabel.tag = defenseLabelTag;
    [self addChild: defenseLabel];
    defenseLbBM = [CCLabelBMFont labelWithString:@"0" fntFile:@"TestFont.fnt"];
    defenseLbBM.position =  ccp( point.x + 150 , point.y + winSize.height/11*i);
    defenseLbBM.anchorPoint = CGPointMake(0.5, 0);
    [self addChild:defenseLbBM z:1];
    i++;
    CCLabelTTF *attackLabel = [CCLabelTTF labelWithString:@"Attack:" fontName:@"Marker Felt" fontSize:20];
    attackLabel.position =  ccp( point.x + winSize.width/4, point.y + winSize.height/11*i);
    attackLabel.anchorPoint = CGPointMake(1, 0);
    attackLabel.color = ccBLACK;
    attackLabel.tag = attackLabelTag;
    [self addChild: attackLabel];
    attackLbBM = [CCLabelBMFont labelWithString:@"0" fntFile:@"TestFont.fnt"];
    attackLbBM.position =  ccp( point.x + 150 , point.y + winSize.height/11*i);
    attackLbBM.anchorPoint = CGPointMake(0.5, 0);
    [self addChild:attackLbBM z:1];
    i++;
    CCLabelTTF *hpLabel = [CCLabelTTF labelWithString:@"Hp:" fontName:@"Marker Felt" fontSize:20];
    hpLabel.position =  ccp( point.x + winSize.width/4, point.y + winSize.height/11*i);
    hpLabel.anchorPoint = CGPointMake(1, 0);
    hpLabel.color = ccBLACK;
    hpLabel.tag = hpLabelTag;
    [self addChild: hpLabel];
    hpLbBM = [CCLabelBMFont labelWithString:@"0" fntFile:@"TestFont.fnt"];
    hpLbBM.position =  ccp( point.x + 150 , point.y + winSize.height/11*i);
    hpLbBM.anchorPoint = CGPointMake(0.5, 0);
    [self addChild:hpLbBM z:1];
    i++;
    CCLabelTTF *roleLevelLabel = [CCLabelTTF labelWithString:@"Level:" fontName:@"Marker Felt" fontSize:20];
    roleLevelLabel.position =  ccp( point.x + winSize.width/4, point.y + winSize.height/11*i);
    roleLevelLabel.anchorPoint = CGPointMake(1, 0);
    roleLevelLabel.color = ccBLACK;
    roleLevelLabel.tag = levelLabelTag;
    [self addChild: roleLevelLabel];
    levelLbBM = [CCLabelBMFont labelWithString:@"0" fntFile:@"TestFont.fnt"];
    levelLbBM.position =  ccp( point.x + 150 , point.y + winSize.height/11*i);
    levelLbBM.anchorPoint = CGPointMake(0.5, 0);
    [self addChild:levelLbBM z:1];
}

- (void)showInfoFromCharacter:(Character *)role loacation:(CGPoint)point{
    NSAssert([role isKindOfClass:[Character class]], @"role should be a Character class");
    [self clean];
    [self setLabels:point];
    
    int rolelevel   = role.level;
    int hp          = [role getAttribute:kCharacterAttributeHp].value;
    int attack      = [role getAttribute:kCharacterAttributeAttack].value;
    int defense     = [role getAttribute:kCharacterAttributeDefense].value;
    int speed       = [role getAttribute:kCharacterAttributeAgile].value;
    int moveSpeed   = [role getAttribute:kCharacterAttributeSpeed].value;
    int moveTime    = [role getAttribute:kCharacterAttributeTime].value;
    
//    [nameLbBM       setString:[NSString stringWithFormat:@"%@", role.name]];
    [levelLbBM      setString:[NSString stringWithFormat:@"%i", rolelevel]];
    [hpLbBM         setString:[NSString stringWithFormat:@"%i", hp]];
    [attackLbBM     setString:[NSString stringWithFormat:@"%i", attack]];
    [defenseLbBM    setString:[NSString stringWithFormat:@"%i", defense]];
    [speedLbBM      setString:[NSString stringWithFormat:@"%i", speed]];
    [moveSpeedLbBM  setString:[NSString stringWithFormat:@"%i", moveSpeed]];
    [moveTimeLbBM   setString:[NSString stringWithFormat:@"%i", moveTime]];
}

-(void)clean {
    [self removeAllChildrenWithCleanup:YES];
}
@end
