//
//  SelectableComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/18.
//
//

#import "SelectableComponent.h"
#import "RenderComponent.h"

#define kStrokeTag 99999

@interface SelectableComponent()
@property (nonatomic, readonly) NSString *cid;
@property (nonatomic, readonly) int level;
@property (nonatomic, readonly) int team;
//*// test only
@property (nonatomic) int testTimes;
@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL showed;
//*/
@end

@implementation SelectableComponent

-(id)initWithCid:(NSString *)cid Level:(int)level Team:(int)team {
    if (self = [super init]) {
        _cid = cid;
        _level = level;
        _team = team;
    }
    return self;
}

/*// test only
-(void)receiveEvent:(EventType)type Message:(id)message {
    if (self.testTimes < 100 && !self.selected) {
        self.testTimes ++;
        return;
    }
    if (type == kEventIsMoveForbidden){
        [message setObject:[NSNumber numberWithBool:YES] forKey:@"kEventIsMoveForbidden"];
    } else if (type == kEventIsActiveSkillForbidden) {
        [message setObject:[NSNumber numberWithBool:YES] forKey:@"kEventIsActiveSkillForbidden"];
    }
}
//*/
-(void)show {
    NSLog(@"show");
    if (self.showed) {
        [self unSelected];
    }
    self.selected = YES;
    self.showed = YES;
    RenderComponent *render = (RenderComponent *)[self.entity getComponentOfClass:[RenderComponent class]];
    
    CCSprite *sprite = [[CCSprite alloc] initWithTexture:render.sprite.texture];
    [sprite setTextureRect:render.sprite.textureRect];
    
    [sprite removeChildByTag:kStrokeTag cleanup:YES];
//
    CCRenderTexture * stroke  = [self createStroke:sprite size:3 color:ccYELLOW];
    [render.sprite addChild:stroke z:-1 tag:kStrokeTag];
}

-(void)unSelected {
    NSLog(@"unSelected");
    self.selected = NO;
    self.showed = NO;
    RenderComponent *render = (RenderComponent *)[self.entity getComponentOfClass:[RenderComponent class]];
    [render.sprite removeChildByTag:kStrokeTag cleanup:YES];
}

-(CCRenderTexture*) createStroke: (CCSprite *)label   size:(float)size   color:(ccColor3B)cor
{
    CCRenderTexture* rt = [CCRenderTexture renderTextureWithWidth:label.texture.contentSize.width+size*2  height:label.texture.contentSize.height+size*2];
    CGPoint originalPos = [label position];
    ccColor3B originalColor = [label color];
    BOOL originalVisibility = [label visible];
    [label setColor:cor];
    [label setVisible:YES];
    ccBlendFunc originalBlend = [label blendFunc];
    [label setBlendFunc:(ccBlendFunc) { GL_SRC_ALPHA, GL_ONE }];
    CGPoint bottomLeft = ccp(label.texture.contentSize.width * label.anchorPoint.x + size, label.texture.contentSize.height * label.anchorPoint.y + size);
    
    [rt begin];
    for (int i=0; i<360; i+=30) // you should optimize that for your needs
    {
        [label setPosition:ccp(bottomLeft.x + sin(CC_DEGREES_TO_RADIANS(i))*size, bottomLeft.y + cos(CC_DEGREES_TO_RADIANS(i))*size)];
        [label visit];
    }
    [rt end];
    [label setPosition:originalPos];
    [label setColor:originalColor];
    [label setBlendFunc:originalBlend];
    [label setVisible:originalVisibility];
    [rt setPosition:ccp([label boundingBox].size.width/2+6,[label boundingBox].size.height/2)];
    
    return rt;
}

/*
+(CCRenderTexture*) createStroke: (CCLabelTTF*) label   size:(float)size   color:(ccColor3B)cor
{
    CCRenderTexture* rt = [CCRenderTexture renderTextureWithWidth:label.texture.contentSize.width+size*2  height:label.texture.contentSize.height+size*2];
    CGPoint originalPos = [label position];
    ccColor3B originalColor = [label color];
    BOOL originalVisibility = [label visible];
    [label setColor:cor];
    [label setVisible:YES];
    ccBlendFunc originalBlend = [label blendFunc];
    [label setBlendFunc:(ccBlendFunc) { GL_SRC_ALPHA, GL_ONE }];
    CGPoint bottomLeft = ccp(label.texture.contentSize.width * label.anchorPoint.x + size, label.texture.contentSize.height * label.anchorPoint.y + size);
    CGPoint positionOffset = ccp(label.texture.contentSize.width * label.anchorPoint.x - label.texture.contentSize.width/2,label.texture.contentSize.height * label.anchorPoint.y - label.texture.contentSize.height/2);
    CGPoint position = ccpSub(originalPos, positionOffset);
    
    [rt begin];
    for (int i=0; i<360; i+=30) // you should optimize that for your needs
    {
        [label setPosition:ccp(bottomLeft.x + sin(CC_DEGREES_TO_RADIANS(i))*size, bottomLeft.y + cos(CC_DEGREES_TO_RADIANS(i))*size)];
        [label visit];
    }
    [rt end];
    [label setPosition:originalPos];
    [label setColor:originalColor];
    [label setBlendFunc:originalBlend];
    [label setVisible:originalVisibility];
    [rt setPosition:position];
    return rt;
}
//*/
@end
