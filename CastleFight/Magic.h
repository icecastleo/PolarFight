//
//  Magic.h
//  CastleFight
//
//  Created by  浩翔 on 13/7/1.
//
//

#import <Foundation/Foundation.h>
#import "MagicComponent.h"
#import "Entity.h"
#import "MapLayer.h"
#import "Range.h"

@interface Magic : NSObject

@property (nonatomic) MapLayer *map;
@property (nonatomic) Entity *owner;
@property (nonatomic) NSDictionary *magicInformation;

-(void)active;

@end
