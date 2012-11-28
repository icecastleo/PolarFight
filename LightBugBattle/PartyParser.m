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
#import "XmlParser.h"
#import "Role.h"


#define MaxHpKey @"MaxHp"
#define HpKey @"Hp"
#define RoleTypeKey @"RoleType"
#define PlayerKey @"Player"
#define LevelKey @"Level"
#define AttackKey @"Attack"
#define DefenseKey @"Defense"
#define SpeedKey @"Speed"
#define MoveSpeedKey @"MoveSpeed"
#define MoveTimeKey @"MoveTime"

@interface PartyParser()
{
    
}

@end

@implementation PartyParser
@synthesize doc = _doc;

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

+ (Party *)loadParty{
    
    Party *party = [[[Party alloc] init] autorelease];
    NSMutableArray *roles = [PartyParser getRolesArrayFromXMLFile];
    party.roles = roles;
    
    return party;
    
}
//======================

+ (NSMutableArray *)getRolesArrayFromXMLFile
{
    NSString *filePath = [self dataFilePath:@"Party.xml" forSave:NO];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    
    XmlParser *parser = [[[XmlParser alloc] init] autorelease];
    
    Role *role = [[[Role alloc] init] autorelease];
    
    NSString *str = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    
    NSMutableArray *rolesArray = [parser fromXml:str withObject:role];
    
    NSLog(@"userArray :: %@", rolesArray);
    
    for (Role *roo in rolesArray) {
        NSLog(@"name :: %@",roo.name);
        NSLog(@"picture :: %@",roo.picture);
        NSLog(@"type :: %@",roo.type);
        NSLog(@"maxHp :: %@",roo.maxHp);
        NSLog(@"roleId ::%@",roo.roleId);
    }
    
    return rolesArray;
}

+ (NSString *)dataFilePath:(NSString *) fileName forSave:(BOOL) save
{
    if (!fileName)
    {
        fileName = @"Default.xml";
    }
    
    //the app directory path not bundle //bundle is readonly
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSArray *fileArray = [fileName componentsSeparatedByString:@"."];
    NSString *fname = [fileArray objectAtIndex:0];
    NSString *ftype = [fileArray lastObject];
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    if (save ||
        [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        return documentsPath;
    } else {
        return [[NSBundle mainBundle] pathForResource:fname ofType:ftype];
    }
}

@end
