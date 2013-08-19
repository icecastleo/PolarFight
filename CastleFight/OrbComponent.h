//
//  OrbComponent.h
//  CastleFight
//
//  Created by  浩翔 on 13/8/14.
//
//

#import "Component.h"

@interface OrbComponent : Component <SelectableComponentDelegate>

@property (nonatomic) OrbType type;
@property (nonatomic) CGPoint position; //position in the Board
@property (nonatomic,assign) Entity *board;

@property (nonatomic,readonly) NSDictionary *matchInfo;

-(id)initWithDictionary:(NSDictionary *)dic;

-(void)executeMatch:(int)number;

@end
