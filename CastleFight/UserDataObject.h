//
//  UserDataObject.h
//  CastleFight
//
//  Created by  浩翔 on 13/3/18.
//
//

#import <Foundation/Foundation.h>

@class Character;

@interface UserDataObject : NSObject

@property (nonatomic) NSArray *playerCharacterArray;
@property (nonatomic) Character *playerHero;
@property (nonatomic) Character *playerCastle;

@property (nonatomic) NSString *money;
@property (nonatomic) NSArray *items;

@end
