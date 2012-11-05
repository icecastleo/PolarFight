//
//  SelectLayer.h
//  LightBugBattle
//
//  Created by  浩翔 on 12/11/1.
//
//

#import "cocos2d.h"

//@class Character;

@interface SelectLayer : CCLayerColor { //CCLayer
    
    NSMutableArray * allRoleBases;
}

@property (nonatomic,retain) NSMutableArray *selectedRoles;

+(CCScene *) scene;

-(void) addCharacter:(CCSprite*)character toPosition:(CGPoint)position;

@end
