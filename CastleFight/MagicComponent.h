//
//  MagicComponent.h
//  CastleFight
//
//  Created by  DAN on 13/7/2.
//
//

#import "Component.h"
#import "Attribute.h"

@interface MagicComponent : Component

@property (nonatomic,readonly) Attribute *damage;
@property (nonatomic,readonly) NSString *name;
@property (nonatomic,readonly) NSDictionary *images;

@property (nonatomic) Entity *spellCaster;
@property (nonatomic,readonly) BOOL canActive;
@property (nonatomic,readonly) NSArray *path;

// might have a cooldown component then donot need these.
@property (nonatomic) float cooldown;
@property (nonatomic) float currentCooldown;

-(id)initWithDamageAttribute:(Attribute *)damage andMagicName:(NSString*)name andNeedImages:(NSDictionary *)images;

-(void)activeWithPath:(NSArray *)path;
-(void)didExecute;

@end
