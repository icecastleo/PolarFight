//
//  OrbSkill.h
//  CastleFight
//
//  Created by  浩翔 on 13/10/1.
//
//

#import <Foundation/Foundation.h>
#import "Entity.h"

typedef enum {
    OrbSkillTypePrepareBattle = 0,
    OrbSkillTypeDuringBattle,
    OrbSkillTypeAfterBattle,
    OrbSkillTypeOthers
} OrbSkillType;

@protocol OrbSkillDelegate <NSObject>
@optional
-(int)characterBonusCount;
-(void)affectOnEntity:(Entity *)entity;
-(float)bonusMana;
-(float)bonusReward;
@end

@interface OrbSkill : NSObject <OrbSkillDelegate> {
@protected
    BOOL _isActivated;
    OrbSkillType _skillType;
}

@property (nonatomic,readonly) BOOL isActivated;
@property (nonatomic,readonly) OrbSkillType skillType;
@property (nonatomic,readonly) int level;

-(id)initWithLevel:(int)level;
-(BOOL)isActivated:(NSDictionary *)orbInfo;

@end
