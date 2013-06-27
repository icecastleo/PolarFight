//
//  testMagic.h
//  CastleFight
//
//  Created by  DAN on 13/6/25.
//
//

#import <Foundation/Foundation.h>
#import "Entity.h"
#import "MapLayer.h"
#import "Range.h"

@interface testMagic : NSObject

@property (nonatomic) MapLayer *map;
@property (nonatomic) Entity *owner;
@property (nonatomic) NSDictionary *information;

-(void)active;

@end
