//
//  CharacterHeadView.m
//  LightBugBattle
//
//  Created by  浩翔 on 13/1/17.
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
        _character = character;
    }
    return self;
}

@end
