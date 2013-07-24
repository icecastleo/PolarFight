//
//  Magic.h
//  CastleFight
//
//  Created by  浩翔 on 13/7/1.
//
//

#import <Foundation/Foundation.h>
#import "Entity.h"
#import "MapLayer.h"
#import "Range.h"

@interface Magic : NSObject

@property (nonatomic) MapLayer *map;
@property (nonatomic) Entity *owner;
@property (nonatomic) NSDictionary *magicInformation;

@property (nonatomic) CGSize rangeSize;

-(id)initWithMagicInformation:(NSDictionary *)magicInfo;
-(void)active;

@end
