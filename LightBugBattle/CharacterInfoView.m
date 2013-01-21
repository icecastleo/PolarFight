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

@implementation CharacterInfoView

-(id)init {
    
    if ((self = [super init])) {
    
    }
    return self;
}

- (void)showInfoFromCharacter:(Character *)role loacation:(CGPoint)point needBackGround:(BOOL)needBg {
    NSAssert([role isKindOfClass:[Character class]], @"role should be a Character class");
    [self clean];
    
    NSString *roleName    = role.name;
    NSString *rolelevel   = [self getNSStringFromint:role.level];
    NSString *currenthp   = [self getNSStringFromint:[role getAttribute:kCharacterAttributeHp].currentValue];
    NSString *maxhp       = [self getNSStringFromint:[role getAttribute:kCharacterAttributeHp].value];
    NSString *hp          = [NSString stringWithFormat:@"%@/%@",currenthp,maxhp];
    NSString *attack      = [self getNSStringFromint:[role getAttribute:kCharacterAttributeAttack].value];
    NSString *defense     = [self getNSStringFromint:[role getAttribute:kCharacterAttributeDefense].value];
    NSString *agile       = [self getNSStringFromint:[role getAttribute:kCharacterAttributeAgile].value];
    NSString *moveSpeed   = [self getNSStringFromint:[role getAttribute:kCharacterAttributeSpeed].value];
//    NSString *moveTime    = [self getNSStringFromint:[role getAttribute:kCharacterAttributeTime].value];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int yPad = winSize.height/30;
    int xPad = winSize.width/4.5;
    int i = 0;
    //i++;
//    CCLabelTTF *moveTimeLabel = [CCLabelTTF labelWithString:@"MoveTime: " fontName:@"Marker Felt" fontSize:20];
//    moveTimeLabel.position =  ccp( point.x + xPad, point.y + winSize.height/11*i + yPad);
//    moveTimeLabel.anchorPoint = CGPointMake(1, 0);
//    moveTimeLabel.color = ccBLACK;
//    [self addChild: moveTimeLabel];
//    CCLabelTTF *moveTimeLable2 = [CCLabelTTF labelWithString:moveTime fontName:@"Marker Felt" fontSize:23];
//    moveTimeLable2.color = ccBROWN;
//    moveTimeLable2.position =  ccp( moveTimeLabel.position.x, moveTimeLabel.position.y);
//    moveTimeLable2.anchorPoint = CGPointMake(0, 0);
//    [self addChild:moveTimeLable2 z:1];
//    i++;
    CCLabelTTF *moveSpeedLabel = [CCLabelTTF labelWithString:@"Speed: " fontName:@"Marker Felt" fontSize:20];
    moveSpeedLabel.position =  ccp( point.x + xPad, point.y + winSize.height/11*i + yPad);
    moveSpeedLabel.anchorPoint = CGPointMake(1, 0);
    moveSpeedLabel.color = ccBLACK;
    [self addChild: moveSpeedLabel];
    CCLabelTTF *moveSpeedLabel2 = [CCLabelTTF labelWithString:moveSpeed fontName:@"Marker Felt" fontSize:23];
    moveSpeedLabel2.color = ccBROWN;
    moveSpeedLabel2.position =  ccp( moveSpeedLabel.position.x, moveSpeedLabel.position.y);
    moveSpeedLabel2.anchorPoint = CGPointMake(0, 0);
    [self addChild:moveSpeedLabel2 z:1];
    i++;
    CCLabelTTF *agileLabel = [CCLabelTTF labelWithString:@"Agile: " fontName:@"Marker Felt" fontSize:20];
    agileLabel.position =  ccp( point.x + xPad, point.y + winSize.height/11*i + yPad);
    agileLabel.anchorPoint = CGPointMake(1, 0);
    agileLabel.color = ccBLACK;
    [self addChild: agileLabel];
    CCLabelTTF *agileLabel2 = [CCLabelTTF labelWithString:agile fontName:@"Marker Felt" fontSize:23];
    agileLabel2.color = ccBROWN;
    agileLabel2.position =  ccp( agileLabel.position.x, agileLabel.position.y);
    agileLabel2.anchorPoint = CGPointMake(0, 0);
    [self addChild:agileLabel2 z:1];
    i++;
    CCLabelTTF *defenseLabel = [CCLabelTTF labelWithString:@"Defense: " fontName:@"Marker Felt" fontSize:20];
    defenseLabel.position =  ccp( point.x + xPad, point.y + winSize.height/11*i + yPad);
    defenseLabel.anchorPoint = CGPointMake(1, 0);
    defenseLabel.color = ccBLACK;
    [self addChild: defenseLabel];
    CCLabelTTF *defenseLabel2 = [CCLabelTTF labelWithString:defense fontName:@"Marker Felt" fontSize:23];
    defenseLabel2.color = ccBROWN;
    defenseLabel2.position =  ccp( defenseLabel.position.x, defenseLabel.position.y);
    defenseLabel2.anchorPoint = CGPointMake(0, 0);
    [self addChild:defenseLabel2 z:1];
    i++;
    CCLabelTTF *attackLabel = [CCLabelTTF labelWithString:@"Attack: " fontName:@"Marker Felt" fontSize:20];
    attackLabel.position =  ccp( point.x + xPad, point.y + winSize.height/11*i + yPad);
    attackLabel.anchorPoint = CGPointMake(1, 0);
    attackLabel.color = ccBLACK;
    [self addChild: attackLabel];
    CCLabelTTF *attackLabel2 = [CCLabelTTF labelWithString:attack fontName:@"Marker Felt" fontSize:23];
    attackLabel2.color = ccBROWN;
    attackLabel2.position =  ccp( attackLabel.position.x, attackLabel.position.y);
    attackLabel2.anchorPoint = CGPointMake(0, 0);
    [self addChild:attackLabel2 z:1];
    i++;
    CCLabelTTF *hpLabel = [CCLabelTTF labelWithString:@"Hp: " fontName:@"Marker Felt" fontSize:20];
    hpLabel.position =  ccp( point.x + xPad, point.y + winSize.height/11*i + yPad);
    hpLabel.anchorPoint = CGPointMake(1, 0);
    hpLabel.color = ccBLACK;
    [self addChild: hpLabel];
    CCLabelTTF *hpLabel2 = [CCLabelTTF labelWithString:hp fontName:@"Marker Felt" fontSize:23];
    hpLabel2.color = ccBROWN;
    hpLabel2.position =  ccp( hpLabel.position.x, hpLabel.position.y);
    hpLabel2.anchorPoint = CGPointMake(0, 0);
    [self addChild:hpLabel2 z:1];
    i++;
    CCLabelTTF *roleLevelLabel = [CCLabelTTF labelWithString:@"Level: " fontName:@"Marker Felt" fontSize:20];
    roleLevelLabel.position =  ccp( point.x + xPad, point.y + winSize.height/11*i + yPad);
    roleLevelLabel.anchorPoint = CGPointMake(1, 0);
    roleLevelLabel.color = ccBLACK;
    [self addChild: roleLevelLabel];
    CCLabelTTF *roleLevelLabel2 = [CCLabelTTF labelWithString:rolelevel fontName:@"Marker Felt" fontSize:23];
    roleLevelLabel2.color = ccBROWN;
    roleLevelLabel2.position =  ccp( roleLevelLabel.position.x, roleLevelLabel.position.y);
    roleLevelLabel2.anchorPoint = CGPointMake(0, 0);
    [self addChild:roleLevelLabel2 z:1];
    i++;
    CCLabelTTF *roleNameLabel = [CCLabelTTF labelWithString:@"Name: " fontName:@"Marker Felt" fontSize:20];
    roleNameLabel.position =  ccp( point.x + xPad, point.y + winSize.height/11*i + yPad);
    roleNameLabel.anchorPoint = CGPointMake(1, 0);
    roleNameLabel.color = ccBLACK;
    [self addChild: roleNameLabel];
    CCLabelTTF *roleNameLabel2 = [CCLabelTTF labelWithString:roleName fontName:@"Marker Felt" fontSize:23];
    roleNameLabel2.color = ccBROWN;
    roleNameLabel2.position =  ccp( roleNameLabel.position.x, roleNameLabel.position.y);
    roleNameLabel2.anchorPoint = CGPointMake(0, 0);
    [self addChild:roleNameLabel2 z:1];
    
    double layerWidth  = winSize.width/2 - winSize.width/20;
    //double layerHeight = winSize.height*9/12;
    double layerHeight = moveSpeedLabel.boundingBox.size.height
                        + agileLabel.boundingBox.size.height
                        + defenseLabel.boundingBox.size.height
                        + attackLabel.boundingBox.size.height
                        + hpLabel.boundingBox.size.height
                        + roleLevelLabel.boundingBox.size.height
                        + roleNameLabel.boundingBox.size.height
                        + yPad *6;
    
    CCLayerColor *layer;
    
    if (needBg)
        layer = [CCLayerColor layerWithColor:ccc4(180, 180, 255, 225)];
    else
        layer = [CCLayerColor layerWithColor:ccc4(180, 180, 255, 0)];
    
    layer.contentSize = CGSizeMake(layerWidth, layerHeight);
    layer.position = point;
    [self addChild:layer z:-1];
}

-(void)clean {
    [self removeAllChildrenWithCleanup:YES];
}

-(NSString *)getNSStringFromint:(int)number {
    NSString *string = [NSString stringWithFormat:@"%d",number];
    return string;
}
@end
