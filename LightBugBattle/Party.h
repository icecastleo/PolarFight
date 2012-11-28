//
//  Party.h
//  LightBugBattle
//
//  Created by  浩翔 on 12/11/10.
//
//

#import <Foundation/Foundation.h>

@class Role, Character;

@interface Party : NSObject

@property (nonatomic, copy) NSMutableArray *roles;
@property (nonatomic, copy) NSMutableArray *players;

- (Role *)basicRoleFromName:(NSString *)name;

//- (Character *)characterFromName:(NSString *)name player:(int)pNumber;

@end
