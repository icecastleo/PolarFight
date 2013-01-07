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
- (void)setLabels {
    
    CGSize windowSize = [CCDirector sharedDirector].winSize;
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

- (void)setValueForLabels:(Character *)role {
    if (!levelLbBM) {
        [self setLabels];
    }
    
    int rolelevel = role.level;
    int hp = [role getAttribute:kCharacterAttributeHp].value;
    int attack = [role getAttribute:kCharacterAttributeAttack].value;
    int defense = [role getAttribute:kCharacterAttributeDefense].value;
    int speed = [role getAttribute:kCharacterAttributeAgile].value;
    int moveSpeed = [role getAttribute:kCharacterAttributeSpeed].value;
    int moveTime = [role getAttribute:kCharacterAttributeTime].value;
    
    [levelLbBM setString:[NSString stringWithFormat:@"%i", rolelevel]];
    [hpLbBM setString:[NSString stringWithFormat:@"%i", hp]];
    [attackLbBM setString:[NSString stringWithFormat:@"%i", attack]];
    [defenseLbBM setString:[NSString stringWithFormat:@"%i", defense]];
    [speedLbBM setString:[NSString stringWithFormat:@"%i", speed]];
    [moveSpeedLbBM setString:[NSString stringWithFormat:@"%i", moveSpeed]];
    [moveTimeLbBM setString:[NSString stringWithFormat:@"%i", moveTime]];
}

@end
