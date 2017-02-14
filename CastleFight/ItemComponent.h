//
//  ItemComponent.h
//  CastleFight
//
//  Created by  浩翔 on 13/10/10.
//
//

#import "Component.h"
#import "TouchComponent.h"

@interface ItemComponent : Component <TouchComponentDelegate>

@property (nonatomic) NSString *itemId;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSDictionary *images;
@property (nonatomic, readonly) NSString *effect;
@property (nonatomic, assign) Entity *owner;
@property (nonatomic, readonly) int price;
@property (nonatomic, readonly) int maxCount;
@property (nonatomic) int count;

-(id)initWithDictionary:(NSDictionary *)dic;

-(void)active;

@end
