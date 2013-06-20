//
//  SelectableComponent.h
//  CastleFight
//
//  Created by  浩翔 on 13/6/18.
//
//

#import "Component.h"

@interface SelectableComponent : Component

-(id)initWithCid:(NSString *)cid Level:(int)level Team:(int)team;
-(void)show;
-(void)unSelected;

@end
