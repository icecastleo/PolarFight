//
//  Constant.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/31.
//
//

#ifndef LightBugBattle_Constant_h
#define LightBugBattle_Constant_h

#ifdef __cplusplus
#define CLS_DEF(clsname) class clsname
#else
#define CLS_DEF(clsname) @class clsname
#endif

#define kGameSettingFps 30

#define PTM_RATIO 32
#define kPhisicsFixtureGroupEntity -1;
#define kPhisicsFixtureGroupRange -2;
// For debug
#define kPhisicalDebugDraw 0

//For SummonType
#define kSummonTypeNormal 1
#define kSummonTypeStock 2
#define kSummonTypeStockOnce 3

// For map
#define kMapPathFloor 50
#define kMapPathHeight 65
#define kMapPathRandomHeight 15
#define kMapPathMaxLine 3
#define kMapStartDistance 50

// For Character make collision CGPath
#define kCollisionPointRange 25

// For touch dispatcher
#define kTouchPriotiryPause -256

// It is not used since 'SneakyJoystick' is a library
#define kTouchPriotiryDpad 1
#define kTouchPriorityBattleController 2
#define kTouchPriorityMap 3

// For Aura and PassiveSkill
#define kAuraInterval 0.4
#define kPassiveSkillDuration 0.5
#define kPassiveSkillInterval 0.1

// For knock out effect
#define kKnoutOutCount 10
#define kKnoutOutRatio 0.9

// For character move
#define kMoveMultiplier 2

// Shadow
#define kShadowPositionEnable 1
// For debug
#define kShadowVisible 0

// Divisor can't be 0
#define kShadowWidthScale 0.75
#define kShadowHeightScale 0.125

// For CCNode child's tag
#define kDrawPathTag 9876
#define kDrawPathRangeSprite 9877
#define kCostLabelTag 9878
#define kLevelLabelTag 9879
#define kSelectedImageTag 9880

//For Achievement System
#define ACTIVE_IF_GREATER_THAN @">"
#define ACTIVE_IF_LESS_THAN @"<"
#define ACTIVE_IF_EQUALS_TO @"=="

#define kAnimationActionTag 5

#define kAISystemUpdateInterval 0.5

//For Orbs
#define kOrbBoardRows 4
#define kOrbBoardColumns 20
#define kOrbBoardWidth 320
#define kOrbBoardHeight 250
#define kOrb_XPad 4
#define kOrb_YPad 1
#define kOrb_XSIZE 30 //pixels
#define kOrb_YSIZE 30 //pixels
#define kOrbBoardMinBorder 0

typedef enum {
    kAnimationTypeUniqueCharacter,
    kAnimationTypeNormalCharacter,
} AnimationType;

typedef enum {
    kGameStateRoundStart,
    kGameStateCharacterMove,
    kGameStateRoundEnd,
} GameState;

typedef enum {
    // Fluid attributes
    kCharacterAttributeHp,
    kCharacterAttributeMp,
    
    // For seperation.
    kCharacterAttributeFluidBoundary,
    
    // Other attributes.
    kCharacterAttributeAttack,
    kCharacterAttributeDefense,
    
    // For seperation.
    kCharacterAttributeUpdateBoundary,
    
    kCharacterAttributeAgile,
    kCharacterAttributeSpeed,
    kCharacterAttributeTime,
    
    // For upgrade
    kCharacterAttributeUpdatePrice,
} CharacterAttributeType;

typedef enum {
    kCharacterStateUseSkill,
    kCharacterStateGetDamage,
    kCharacterStateMove,
    kCharacterStateIdle,
    kCharacterStateDead
} CharacterState;

typedef enum {
    kDamageTypeNormal,
    kDamageTypeFire,
    kDamageTypeIce,
    kDamageTypeBomb,
    kDamageTypePoison,
    kDamageTypeHeal,
    kDamageTypeKnockOut
} DamageType;

typedef enum {
    kDamageSourceMelee,
    kDamageSourceRanged,
    kDamageSourcePassiveSkill,
} DamageSource;

typedef enum {
    kArmorNoraml,
} ArmorType;

//typedef enum {
////    statusUnknown,
//    // TimeStatus
//    statusPoison,
//    
//    statusTypeLine = 50,
//    // AuraStatus
//    statusAttackBuff,
//} StatusType;

typedef enum {
    statusPoison,
} TimeStatusType;

typedef enum {
    statusAttackBuff,
} AuraStatusType;

typedef enum {
    OrbNull = 0,
    OrbRed,
    OrbBlue,
    OrbGreen,
    OrbYellow,
    OrbPurple,
    OrbPink,
    OrbBottom
} OrbType;

#import "ccTypes.h"

//! AliceBlue color (240,248,255)
static const ccColor3B ccALICEBLUE={240,248,255};
//! AntiqueWhite color (250,235,215)
static const ccColor3B ccANTIQUEWHITE={250,235,215};
//! Aqua color (0,255,255)
static const ccColor3B ccAQUA={0,255,255};
//! Aquamarine color (127,255,212)
static const ccColor3B ccAQUAMARINE={127,255,212};
//! Azure color (240,255,255)
static const ccColor3B ccAZURE={240,255,255};
//! Beige color (245,245,220)
static const ccColor3B ccBEIGE={245,245,220};
//! Bisque color (255,228,196)
static const ccColor3B ccBISQUE={255,228,196};
//! BlanchedAlmond color (255,235,205)
static const ccColor3B ccBLANCHEDALMOND={255,235,205};
//! BlueViolet color (138,43,226)
static const ccColor3B ccBLUEVIOLET={138,43,226};
//! Brown color (165,42,42)
static const ccColor3B ccBROWN={165,42,42};
//! BurlyWood color (222,184,135)
static const ccColor3B ccBURLYWOOD={222,184,135};
//! CadetBlue color (95,158,160)
static const ccColor3B ccCADETBLUE={95,158,160};
//! Chartreuse color (127,255,0)
static const ccColor3B ccCHARTREUSE={127,255,0};
//! Chocolate color (210,105,30)
static const ccColor3B ccCHOCOLATE={210,105,30};
//! Coral color (255,127,80)
static const ccColor3B ccCORAL={255,127,80};
//! CornflowerBlue color (100,149,237)
static const ccColor3B ccCORNFLOWERBLUE={100,149,237};
//! Cornsilk color (255,248,220)
static const ccColor3B ccCORNSILK={255,248,220};
//! Crimson color (220,20,60)
static const ccColor3B ccCRIMSON={220,20,60};
//! Cyan color (0,255,255)
static const ccColor3B ccCYAN={0,255,255};
//! DarkBlue color (0,0,139)
static const ccColor3B ccDARKBLUE={0,0,139};
//! DarkCyan color (0,139,139)
static const ccColor3B ccDARKCYAN={0,139,139};
//! DarkGoldenRod color (184,134,11)
static const ccColor3B ccDARKGOLDENROD={184,134,11};
//! DarkGray color (169,169,169)
static const ccColor3B ccDARKGRAY={169,169,169};
//! DarkGreen color (0,100,0)
static const ccColor3B ccDARKGREEN={0,100,0};
//! DarkKhaki color (189,183,107)
static const ccColor3B ccDARKKHAKI={189,183,107};
//! DarkMagenta color (139,0,139)
static const ccColor3B ccDARKMAGENTA={139,0,139};
//! DarkOliveGreen color (85,107,47)
static const ccColor3B ccDARKOLIVEGREEN={85,107,47};
//! Darkorange color (255,140,0)
static const ccColor3B ccDARKORANGE={255,140,0};
//! DarkOrchid color (153,50,204)
static const ccColor3B ccDARKORCHID={153,50,204};
//! DarkRed color (139,0,0)
static const ccColor3B ccDARKRED={139,0,0};
//! DarkSalmon color (233,150,122)
static const ccColor3B ccDARKSALMON={233,150,122};
//! DarkSeaGreen color (143,188,143)
static const ccColor3B ccDARKSEAGREEN={143,188,143};
//! DarkSlateBlue color (72,61,139)
static const ccColor3B ccDARKSLATEBLUE={72,61,139};
//! DarkSlateGray color (47,79,79)
static const ccColor3B ccDARKSLATEGRAY={47,79,79};
//! DarkTurquoise color (0,206,209)
static const ccColor3B ccDARKTURQUOISE={0,206,209};
//! DarkViolet color (148,0,211)
static const ccColor3B ccDARKVIOLET={148,0,211};
//! DeepPink color (255,20,147)
static const ccColor3B ccDEEPPINK={255,20,147};
//! DeepSkyBlue color (0,191,255)
static const ccColor3B ccDEEPSKYBLUE={0,191,255};
//! DimGray color (105,105,105)
static const ccColor3B ccDIMGRAY={105,105,105};
//! DodgerBlue color (30,144,255)
static const ccColor3B ccDODGERBLUE={30,144,255};
//! FireBrick color (178,34,34)
static const ccColor3B ccFIREBRICK={178,34,34};
//! FloralWhite color (255,250,240)
static const ccColor3B ccFLORALWHITE={255,250,240};
//! ForestGreen color (34,139,34)
static const ccColor3B ccFORESTGREEN={34,139,34};
//! Fuchsia color (255,0,255)
static const ccColor3B ccFUCHSIA={255,0,255};
//! Gainsboro color (220,220,220)
static const ccColor3B ccGAINSBORO={220,220,220};
//! GhostWhite color (248,248,255)
static const ccColor3B ccGHOSTWHITE={248,248,255};
//! Gold color (255,215,0)
static const ccColor3B ccGOLD={255,215,0};
//! GoldenRod color (218,165,32)
static const ccColor3B ccGOLDENROD={218,165,32};
//! GreenYellow color (173,255,47)
static const ccColor3B ccGREENYELLOW={173,255,47};
//! HoneyDew color (240,255,240)
static const ccColor3B ccHONEYDEW={240,255,240};
//! HotPink color (255,105,180)
static const ccColor3B ccHOTPINK={255,105,180};
//! IndianRed color (205,92,92)
static const ccColor3B ccINDIANRED={205,92,92};
//! Indigo color (75,0,130)
static const ccColor3B ccINDIGO={75,0,130};
//! Ivory color (255,255,240)
static const ccColor3B ccIVORY={255,255,240};
//! Khaki color (240,230,140)
static const ccColor3B ccKHAKI={240,230,140};
//! Lavender color (230,230,250)
static const ccColor3B ccLAVENDER={230,230,250};
//! LavenderBlush color (255,240,245)
static const ccColor3B ccLAVENDERBLUSH={255,240,245};
//! LawnGreen color (124,252,0)
static const ccColor3B ccLAWNGREEN={124,252,0};
//! LemonChiffon color (255,250,205)
static const ccColor3B ccLEMONCHIFFON={255,250,205};
//! LightBlue color (173,216,230)
static const ccColor3B ccLIGHTBLUE={173,216,230};
//! LightCoral color (240,128,128)
static const ccColor3B ccLIGHTCORAL={240,128,128};
//! LightCyan color (224,255,255)
static const ccColor3B ccLIGHTCYAN={224,255,255};
//! LightGoldenRodYellow color (250,250,210)
static const ccColor3B ccLIGHTGOLDENRODYELLOW={250,250,210};
//! LightGrey color (211,211,211)
static const ccColor3B ccLIGHTGREY={211,211,211};
//! LightGreen color (144,238,144)
static const ccColor3B ccLIGHTGREEN={144,238,144};
//! LightPink color (255,182,193)
static const ccColor3B ccLIGHTPINK={255,182,193};
//! LightSalmon color (255,160,122)
static const ccColor3B ccLIGHTSALMON={255,160,122};
//! LightSeaGreen color (32,178,170)
static const ccColor3B ccLIGHTSEAGREEN={32,178,170};
//! LightSkyBlue color (135,206,250)
static const ccColor3B ccLIGHTSKYBLUE={135,206,250};
//! LightSlateGray color (119,136,153)
static const ccColor3B ccLIGHTSLATEGRAY={119,136,153};
//! LightSteelBlue color (176,196,222)
static const ccColor3B ccLIGHTSTEELBLUE={176,196,222};
//! LightYellow color (255,255,224)
static const ccColor3B ccLIGHTYELLOW={255,255,224};
//! Lime color (0,255,0)
static const ccColor3B ccLIME={0,255,0};
//! LimeGreen color (50,205,50)
static const ccColor3B ccLIMEGREEN={50,205,50};
//! Linen color (250,240,230)
static const ccColor3B ccLINEN={250,240,230};
//! Maroon color (128,0,0)
static const ccColor3B ccMAROON={128,0,0};
//! MediumAquaMarine color (102,205,170)
static const ccColor3B ccMEDIUMAQUAMARINE={102,205,170};
//! MediumBlue color (0,0,205)
static const ccColor3B ccMEDIUMBLUE={0,0,205};
//! MediumOrchid color (186,85,211)
static const ccColor3B ccMEDIUMORCHID={186,85,211};
//! MediumPurple color (147,112,216)
static const ccColor3B ccMEDIUMPURPLE={147,112,216};
//! MediumSeaGreen color (60,179,113)
static const ccColor3B ccMEDIUMSEAGREEN={60,179,113};
//! MediumSlateBlue color (123,104,238)
static const ccColor3B ccMEDIUMSLATEBLUE={123,104,238};
//! MediumSpringGreen color (0,250,154)
static const ccColor3B ccMEDIUMSPRINGGREEN={0,250,154};
//! MediumTurquoise color (72,209,204)
static const ccColor3B ccMEDIUMTURQUOISE={72,209,204};
//! MediumVioletRed color (199,21,133)
static const ccColor3B ccMEDIUMVIOLETRED={199,21,133};
//! MidnightBlue color (25,25,112)
static const ccColor3B ccMIDNIGHTBLUE={25,25,112};
//! MintCream color (245,255,250)
static const ccColor3B ccMINTCREAM={245,255,250};
//! MistyRose color (255,228,225)
static const ccColor3B ccMISTYROSE={255,228,225};
//! Moccasin color (255,228,181)
static const ccColor3B ccMOCCASIN={255,228,181};
//! NavajoWhite color (255,222,173)
static const ccColor3B ccNAVAJOWHITE={255,222,173};
//! Navy color (0,0,128)
static const ccColor3B ccNAVY={0,0,128};
//! OldLace color (253,245,230)
static const ccColor3B ccOLDLACE={253,245,230};
//! Olive color (128,128,0)
static const ccColor3B ccOLIVE={128,128,0};
//! OliveDrab color (107,142,35)
static const ccColor3B ccOLIVEDRAB={107,142,35};
//! OrangeRed color (255,69,0)
static const ccColor3B ccORANGERED={255,69,0};
//! Orchid color (218,112,214)
static const ccColor3B ccORCHID={218,112,214};
//! PaleGoldenRod color (238,232,170)
static const ccColor3B ccPALEGOLDENROD={238,232,170};
//! PaleGreen color (152,251,152)
static const ccColor3B ccPALEGREEN={152,251,152};
//! PaleTurquoise color (175,238,238)
static const ccColor3B ccPALETURQUOISE={175,238,238};
//! PaleVioletRed color (216,112,147)
static const ccColor3B ccPALEVIOLETRED={216,112,147};
//! PapayaWhip color (255,239,213)
static const ccColor3B ccPAPAYAWHIP={255,239,213};
//! PeachPuff color (255,218,185)
static const ccColor3B ccPEACHPUFF={255,218,185};
//! Peru color (205,133,63)
static const ccColor3B ccPERU={205,133,63};
//! Pink color (255,192,203)
static const ccColor3B ccPINK={255,192,203};
//! Plum color (221,160,221)
static const ccColor3B ccPLUM={221,160,221};
//! PowderBlue color (176,224,230)
static const ccColor3B ccPOWDERBLUE={176,224,230};
//! Purple color (128,0,128)
static const ccColor3B ccPURPLE={128,0,128};
//! RosyBrown color (188,143,143)
static const ccColor3B ccROSYBROWN={188,143,143};
//! RoyalBlue color (65,105,225)
static const ccColor3B ccROYALBLUE={65,105,225};
//! SaddleBrown color (139,69,19)
static const ccColor3B ccSADDLEBROWN={139,69,19};
//! Salmon color (250,128,114)
static const ccColor3B ccSALMON={250,128,114};
//! SandyBrown color (244,164,96)
static const ccColor3B ccSANDYBROWN={244,164,96};
//! SeaGreen color (46,139,87)
static const ccColor3B ccSEAGREEN={46,139,87};
//! SeaShell color (255,245,238)
static const ccColor3B ccSEASHELL={255,245,238};
//! Sienna color (160,82,45)
static const ccColor3B ccSIENNA={160,82,45};
//! Silver color (192,192,192)
static const ccColor3B ccSILVER={192,192,192};
//! SkyBlue color (135,206,235)
static const ccColor3B ccSKYBLUE={135,206,235};
//! SlateBlue color (106,90,205)
static const ccColor3B ccSLATEBLUE={106,90,205};
//! SlateGray color (112,128,144)
static const ccColor3B ccSLATEGRAY={112,128,144};
//! Snow color (255,250,250)
static const ccColor3B ccSNOW={255,250,250};
//! SpringGreen color (0,255,127)
static const ccColor3B ccSPRINGGREEN={0,255,127};
//! SteelBlue color (70,130,180)
static const ccColor3B ccSTEELBLUE={70,130,180};
//! Tan color (210,180,140)
static const ccColor3B ccTAN={210,180,140};
//! Teal color (0,128,128)
static const ccColor3B ccTEAL={0,128,128};
//! Thistle color (216,191,216)
static const ccColor3B ccTHISTLE={216,191,216};
//! Tomato color (255,99,71)
static const ccColor3B ccTOMATO={255,99,71};
//! Turquoise color (64,224,208)
static const ccColor3B ccTURQUOISE={64,224,208};
//! Violet color (238,130,238)
static const ccColor3B ccVIOLET={238,130,238};
//! Wheat color (245,222,179)
static const ccColor3B ccWHEAT={245,222,179};
//! WhiteSmoke color (245,245,245)
static const ccColor3B ccWHITESMOKE={245,245,245};
//! YellowGreen color (154,205,50)
static const ccColor3B ccYELLOWGREEN={154,205,50};

#endif
