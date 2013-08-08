//
//  ThreeLineMapLayer.h
//  CastleFight
//
//  Created by 朱 世光 on 13/4/29.
//
//

#import "MapLayer.h"

@interface ThreeLineMapLayer : MapLayer

@property (readonly) BOOL isSelectLineOccupied;

-(void)addEntity:(Entity *)entity line:(int)line;
-(void)moveEntity:(Entity *)entity toLine:(int)line;
-(BOOL)canSummonCharacterInThisArea:(CGPoint)position;
-(int)positionConvertToLine:(CGPoint)position ;

@end
