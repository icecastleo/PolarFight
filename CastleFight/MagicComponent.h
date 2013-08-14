//
//  MagicComponent.h
//  CastleFight
//
//  Created by  浩翔 on 13/7/2.
//
//

#import "Component.h"
//#import "Attribute.h"

@class Attribute;

@interface MagicComponent : Component <SelectableComponentDelegate>

@property (nonatomic,readonly) Attribute *damage;
@property (nonatomic,readonly) NSString *name;
@property (nonatomic,readonly) NSDictionary *images;
@property (nonatomic,readonly) CGSize rangeSize;

@property (nonatomic) Entity *spellCaster;
@property (nonatomic,readonly) BOOL canActive;
@property (nonatomic,readonly) NSArray *path;

// might have a cooldown component then donot need these.
@property (nonatomic) float cooldown;
@property (nonatomic) float currentCooldown;

-(id)initWithDictionary:(NSDictionary *)dic;

-(void)activeWithPath:(NSArray *)path;
-(void)didExecute;

@end
