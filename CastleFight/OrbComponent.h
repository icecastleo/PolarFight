//
//  OrbComponent.h
//  CastleFight
//
//  Created by  浩翔 on 13/8/14.
//
//

#import "Component.h"
#import "TouchComponent.h"

@class OrbBoardComponent,SummonComponent;

@interface OrbComponent : Component <TouchComponentDelegate>

@property (nonatomic,readonly) OrbColor originalColor;
@property (nonatomic) OrbColor color;
@property (nonatomic) NSString *type;
@property (nonatomic,assign) OrbBoardComponent *board;

@property (nonatomic,readonly) BOOL isMovable;
@property (nonatomic,readonly) BOOL isTappable;
@property (nonatomic,readonly) int team;
@property (nonatomic,assign) SummonComponent *summonData;

-(id)initWithDictionary:(NSDictionary *)dic;

-(void)executeMatch:(int)number;

-(void)disappearAfterMatch;
-(void)touchEndLine;

-(NSDictionary *)findMatch;
-(void)matchClean:(NSDictionary *)matchDic;

@end
