//
//  Armor.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/6.
//
//

#import <Foundation/Foundation.h>
#import "Constant.h"
@class Character;

@interface Armor : NSObject {
    ArmorType type;
}

@property (weak, nonatomic) Character* character;

-(id)initWithArmorType:(int)aType;

@end
