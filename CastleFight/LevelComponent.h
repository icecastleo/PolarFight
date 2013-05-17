//
//  LevelComponent.h
//  CastleFight
//
//  Created by 朱 世光 on 13/5/2.
//
//

#import "Component.h"
#import "Attribute.h"

@interface LevelComponent : Component {
    
}

@property (nonatomic) int level;

-(id)initWithLevel:(int)level;

@end
