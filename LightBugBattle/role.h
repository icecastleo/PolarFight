//
//  role.h
//  LightBugBattle
//
//  Created by  浩翔 on 12/11/27.
//
//

#import <Foundation/Foundation.h>

@interface Role : NSObject
{
@protected
    NSString *name;
    NSString *Picture;
    NSString *Type;
    NSNumber *Level;
    NSNumber *MaxHp;
    NSNumber *Hp;
    NSNumber *Attack;
    NSNumber *Defense;
    NSNumber *Speed;
    NSNumber *MoveSpeed;
    NSNumber *MoveTime;
    NSString *roleId;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSNumber *level;
@property (nonatomic, copy) NSNumber *maxHp;
@property (nonatomic, copy) NSNumber *hp;
@property (nonatomic, copy) NSNumber *attack;
@property (nonatomic, copy) NSNumber *defense;
@property (nonatomic, copy) NSNumber *speed;
@property (nonatomic, copy) NSNumber *moveSpeed;
@property (nonatomic, copy) NSNumber *moveTime;
@property (nonatomic, copy) NSString *roleId;

@end
