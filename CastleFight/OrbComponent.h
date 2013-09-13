//
//  OrbComponent.h
//  CastleFight
//
//  Created by  浩翔 on 13/8/14.
//
//

#import "Component.h"
#import "TouchComponent.h"

@class OrbBoardComponent,CharacterInitData;

@protocol OrbComponentDelegate <NSObject>
@optional
-(void)touchEndLine;
@end

@interface OrbComponent : Component <TouchComponentDelegate,OrbComponentDelegate>

@property (nonatomic,readonly) OrbColor originalColor;
@property (nonatomic) OrbColor color;
@property (nonatomic) NSString *type;
@property (nonatomic,assign) OrbBoardComponent *board;

@property (nonatomic,readonly) BOOL isMovable;
@property (nonatomic,readonly) BOOL isTappable;
@property (nonatomic,readonly) int team;
@property (nonatomic,assign) CharacterInitData *summonData;

-(id)initWithDictionary:(NSDictionary *)dic;

-(void)executeMatch:(int)number;

-(void)disappearAfterMatch;

-(NSDictionary *)findMatch;
-(void)matchClean:(NSDictionary *)matchDic;

@end
