//
//  BattleCatMapLayer.h
//  CastleFight
//
//  Created by 朱 世光 on 13/4/29.
//
//

#import "MapLayer.h"

@interface BattleCatMapLayer : MapLayer {
    BOOL isMove;
    BOOL isFollow;
}
@property (readonly, weak) Character *hero;

@end
