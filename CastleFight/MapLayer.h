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

@interface MapLayer : CCLayer {
    int counts[2];
    

    BOOL isMove;
    BOOL isFollowing;
}

@property (readonly) NSMutableArray *characters;
@property (readonly) NSMutableArray *castles;
@property (readonly) MapCamera *cameraControl;
@property (readonly) int boundaryX, boundaryY;

-(id)initWithFile:(NSString *)file;

-(void)addCastle:(Character *)castle;
-(void)addCharacter:(Character *)character;
-(void)removeCharacter:(Character *)character;

-(void)moveCharacter:(Character *)character toPosition:(CGPoint)position isMove:(BOOL)move;
-(void)moveCharacter:(Character *)character byPosition:(CGPoint)position isMove:(BOOL)move;

@end
