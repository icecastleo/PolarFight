//
//  PartyParser.m
//  LightBugBattle
//
//  Created by  浩翔 on 12/11/12.
//
//

#import "PartyParser.h"
#import "Party.h"
#import "GDataXMLNode.h"
#import "Character.h"

@implementation PartyParser

//TODO: not finish saveParty yet
+ (void)saveParty:(Party *)party {
/*
    GDataXMLElement * partyElement = [GDataXMLNode elementWithName:@"Party"];
    
    for(Character *player in party.players) {
        
        GDataXMLElement * playerElement =
        [GDataXMLNode elementWithName:@"Player"];
        GDataXMLElement * nameElement =
        [GDataXMLNode elementWithName:@"Name" stringValue:player.name];
        GDataXMLElement * levelElement =
        [GDataXMLNode elementWithName:@"Level" stringValue:
         [NSString stringWithFormat:@"%d", player.level]];
        NSString *classString;
        if (player.roleType == Hero) {
            classString = @"Hero";
        } else if (player.roleType == Soldier) {
            classString = @"Soldier";
        }
        
        GDataXMLElement * classElement =
        [GDataXMLNode elementWithName:@"Type" stringValue:classString];
        
        [playerElement addChild:nameElement];
        [playerElement addChild:levelElement];
        [playerElement addChild:classElement];
        [partyElement addChild:playerElement];
    }
    
    GDataXMLDocument *document = [[[GDataXMLDocument alloc]
                                   initWithRootElement:partyElement] autorelease];
    NSData *xmlData = document.XMLData;
    
    NSString *filePath = [self dataFilePath:TRUE];
    NSLog(@"Saving xml data to %@...", filePath);
    [xmlData writeToFile:filePath atomically:YES];
//*/   
}


+ (NSString *)dataFilePath:(BOOL)forSave
{
    //the app directory path not bundle //bundle is readonly
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:@"Party.xml"];
    if (forSave ||
        [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        return documentsPath;
    } else {
        return [[NSBundle mainBundle] pathForResource:@"Party" ofType:@"xml"];
    }
}

+ (Party *)loadPartyFromType:(int)type withPlayer:(int)player{
    
    NSString *xPath;
    switch (type) {
        case Hero:
            xPath = @"//Party/Player[@type='hero']";
            break;
        case Soldier:
            xPath = @"//Party/Player[@type='soldier']";
            break;
        case Monster:
            xPath = @"//Party/Player[@type='monster']";
            break;
        default:
            return nil;
    }
    
    NSString *filePath = [self dataFilePath:FALSE];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&error];
    if (doc == nil) { return nil; }
    
    //NSLog(@"%@", doc.rootElement);
    
    Party *party = [[[Party alloc] init] autorelease];
    NSArray *partyMembers = [doc nodesForXPath:xPath error:nil];
    for (GDataXMLElement *partyMember in partyMembers) {
        
        // Let's fill these in!
        NSString *name;
        NSString *picFileName;
        CharacterType roleType;
        //int player;
        int level;
        int maxHp;
        int hp;
        int attack;
        int defense;
        int speed;
        int moveSpeed;
        int moveTime;
        
        // Name
        NSArray *names = [partyMember elementsForName:@"Name"];
        if (names.count > 0) {
            GDataXMLElement *firstName = (GDataXMLElement *) [names objectAtIndex:0];
            name = firstName.stringValue;
        } else continue;
        
        // Picture
        NSArray *pictures = [partyMember elementsForName:@"Picture"];
        if (pictures.count > 0) {
            GDataXMLElement *firstPicture = (GDataXMLElement *) [pictures objectAtIndex:0];
            picFileName = firstPicture.stringValue;
        }
        
        /*
        // Player
        NSArray *players = [partyMember elementsForName:@"Player"];
        if (players.count > 0) {
            GDataXMLElement *firstPlayers = (GDataXMLElement *) [players objectAtIndex:0];
            player = firstPlayers.stringValue.intValue;
        } else continue;
        //*/
        
        // Type
        NSArray *types = [partyMember elementsForName:@"Type"];
        if (types.count > 0) {
            GDataXMLElement *firstType = (GDataXMLElement *) [types objectAtIndex:0];
            if ([firstType.stringValue caseInsensitiveCompare:@"Hero"]
                == NSOrderedSame) {
                roleType = Hero;
            } else if ([firstType.stringValue caseInsensitiveCompare:@"Soldier"]
                       == NSOrderedSame) {
                roleType = Soldier;
            } else {
                continue;
            }
        } else continue;
        
        // Level
        NSArray *levels = [partyMember elementsForName:@"Level"];
        if (levels.count > 0) {
            GDataXMLElement *firstLevel = (GDataXMLElement *) [levels objectAtIndex:0];
            level = firstLevel.stringValue.intValue;
        } else continue;
        
        // MaxHp
        NSArray *maxHps = [partyMember elementsForName:@"MaxHp"];
        if (maxHps.count > 0) {
            GDataXMLElement *firstMaxHp = (GDataXMLElement *) [maxHps objectAtIndex:0];
            maxHp = firstMaxHp.stringValue.intValue;
        } else continue;
        
        // Hp
        NSArray *hps = [partyMember elementsForName:@"Hp"];
        if (hps.count > 0) {
            GDataXMLElement *firstHp = (GDataXMLElement *) [hps objectAtIndex:0];
            hp = firstHp.stringValue.intValue;
        } else continue;
        
        // Attack
        NSArray *attacks = [partyMember elementsForName:@"Attack"];
        if (attacks.count > 0) {
            GDataXMLElement *firstAttack = (GDataXMLElement *) [attacks objectAtIndex:0];
            attack = firstAttack.stringValue.intValue;
        } else continue;
        
        // Defense
        NSArray *defenses = [partyMember elementsForName:@"Defense"];
        if (defenses.count > 0) {
            GDataXMLElement *firstDefense = (GDataXMLElement *) [defenses objectAtIndex:0];
            defense = firstDefense.stringValue.intValue;
        } else continue;
        
        // Speed
        NSArray *speeds = [partyMember elementsForName:@"Speed"];
        if (speeds.count > 0) {
            GDataXMLElement *firstSpeed = (GDataXMLElement *) [speeds objectAtIndex:0];
            speed = firstSpeed.stringValue.intValue;
        } else continue;
        
        // MoveSpeed
        NSArray *moveSpeeds = [partyMember elementsForName:@"MoveSpeed"];
        if (moveSpeeds.count > 0) {
            GDataXMLElement *firstMoveSpeeds = (GDataXMLElement *) [moveSpeeds objectAtIndex:0];
            moveSpeed = firstMoveSpeeds.stringValue.intValue;
        } else continue;
        
        // MoveSpeed
        NSArray *moveTimes = [partyMember elementsForName:@"MoveTime"];
        if (moveTimes.count > 0) {
            GDataXMLElement *firstMoveTime = (GDataXMLElement *) [moveTimes objectAtIndex:0];
            moveTime = firstMoveTime.stringValue.intValue;
        } else continue;
        
        Character *role = [[Character alloc] initWithName:[name copy] fileName:[picFileName copy]];
        
        role.roleType = roleType;
        role.player = player;
        role.level = level;
        role.maxHp = maxHp;
        role.hp = hp;
        role.attack = attack;
        role.defense = defense;
        role.speed = speed;
        role.moveSpeed = moveSpeed;
        role.moveTime = moveTime;
        
        [party.players addObject:role];
    }
    
    [doc release];
    [xmlData release];
    return party;
    
}


@end
