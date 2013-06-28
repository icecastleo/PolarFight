//
//  MapLayer.h
//  CastleFight
//
//  Created by 朱 世光 on 13/3/1.
//
//

#import "CCLayer.h"
#import "MapCamera.h"
#import "Character.h"
#import "Entity.h"

@interface MapLayer : CCLayer {

}

@property (readonly) MapCamera *cameraControl;
@property (readonly) int boundaryX, boundaryY;
@property (readonly) int maxChildZ;

-(id)initWithName:(NSString *)name;
-(void)setMap:(NSString *)name;

-(void)addEntity:(Entity *)entity;
-(void)addEntity:(Entity *)entity toPosition:(CGPoint)position;
-(void)moveEntity:(Entity *)entity toPosition:(CGPoint)position boundaryLimit:(BOOL)limit;
-(void)moveEntity:(Entity *)entity byPosition:(CGPoint)position boundaryLimit:(BOOL)limit;
-(void)knockOutEntity:(Entity *)entity byPosition:(CGPoint)position boundaryLimit:(BOOL)limit;

@end
