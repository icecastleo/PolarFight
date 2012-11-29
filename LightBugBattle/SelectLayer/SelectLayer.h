//
//  SelectLayer.h
//  LightBugBattle
//
//  Created by  浩翔 on 12/11/1.
//
//

#import "cocos2d.h"

@interface SelectLayer : CCLayerColor {
    
    NSMutableArray * allRoleBases;
}

@property (nonatomic,strong) NSMutableArray *selectedRoles;

+(CCScene *) scene;

@end
