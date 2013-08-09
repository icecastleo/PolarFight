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
@property (nonatomic) BOOL hasDragLine;
@property (nonatomic) NSString *dragImage1;
@property (nonatomic) NSString *dragImage2;

-(id)initWithDictionary:(NSDictionary *)dic;

-(void)select;
-(void)unSelected;

@end
