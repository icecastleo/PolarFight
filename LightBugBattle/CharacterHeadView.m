//
//  CharacterHeadView.m
//  LightBugBattle
//
//  Created by  DAN on 13/1/17.
//
//

#import "CharacterHeadView.h"
#import "Character.h"

@interface CharacterHeadView()
@property (readonly) NSString *imageFileName;
@end

@implementation CharacterHeadView

-(id)initWithCharacter:(Character *)character {
    if (!character) {
        NSAssert(character !=nil , @"character's headImage should not nil.");
        return nil;
    }
    if (self = [super initWithFile:character.headImageFileName]) {
        _imageFileName = character.headImageFileName;
    }
    return self;
}

@end
