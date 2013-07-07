//
//  SelectableComponent.h
//  CastleFight
//
//  Created by  浩翔 on 13/6/18.
//
//

#import "Component.h"

@interface SelectableComponent : Component

@property (nonatomic) BOOL canSelect;

-(void)show;
-(void)unSelected;

@end
