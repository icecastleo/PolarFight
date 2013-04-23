//
//  ShopUnitSprite.h
//  CastleFight
//
//  Created by 朱 世光 on 13/4/11.
//
//

#import "ShopFrameSprite.h"

@class Character;
@interface ShopUnitSprite : ShopFrameSprite {
    CCLabelBMFont *lv;
    
    CCSprite *hp_bar;    
    CCLabelBMFont *hp_font;    
    CCSprite *pow_bar;    
    CCLabelBMFont *pow_font;
    
    CCSprite *hp_next_bar;    
    CCLabelBMFont *hp_next_font;
    CCSprite *pow_next_bar;
    CCLabelBMFont *pow_next_font;
    
    CCMenuItemSprite *upgrade;
    CCLabelBMFont *diamond_font;
    
    CCMenu *menu;
}
@property (readonly) Character *character;

-(id)initWithCharacter:(Character *)aCharacter;

@end
