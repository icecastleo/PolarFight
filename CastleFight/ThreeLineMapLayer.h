//
//  ThreeLineMapLayer.h
//  CastleFight
//
//  Created by 朱 世光 on 13/4/29.
//
//

#import "MapLayer.h"

@interface ThreeLineMapLayer : MapLayer

-(void)moveEntity:(Entity *)entity toLine:(int)line;

@end
