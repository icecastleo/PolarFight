//
//  LineComponent.h
//  CastleFight
//
//  Created by  DAN on 13/7/29.
//
//

#import "Component.h"

@interface LineComponent : Component

@property (nonatomic,readonly) int currentLine;
@property (nonatomic,readonly) int nextLine;
@property (nonatomic,readonly) BOOL doesChangeLine;

-(void)didChange;
-(void)changeLine:(int)line;

// only for map when it adds a character.
-(void)instantlyChangeLine:(int)line;

@end
