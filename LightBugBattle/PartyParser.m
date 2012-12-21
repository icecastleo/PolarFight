//
//  PartyParser.m
//  LightBugBattle
//
//  Created by  浩翔 on 12/11/12.
//
//

#import "PartyParser.h"
#import "GDataXMLNode.h"
#import "Character.h"
#import "XmlParser.h"
#import "Role.h"

@implementation PartyParser

//TODO: not finish saveParty yet
+ (void)saveParty{
  
}

+ (NSMutableArray *)getRolesArrayFromXMLFile
{
    NSString *filePath = [self dataFilePath:@"Party.xml" forSave:NO];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    
    XmlParser *parser = [[XmlParser alloc] init];
    
//    Role *role = [[Role alloc] init];
    
    NSString *str = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    
//    NSMutableArray *rolesArray = [parser fromXml:str withObject:role];
    //============
//    NSLog(@"userArray :: %@", rolesArray);
//
//    for (Role *roo in rolesArray) {
//        NSLog(@"name :: %@",roo.name);
//        NSLog(@"picture :: %@",roo.picture);
//        NSLog(@"type :: %@",roo.type);
//        NSLog(@"maxHp :: %@",roo.maxHp);
//        NSLog(@"roleId ::%@",roo.roleId);
//    }
    //============  
//    return rolesArray;
    return nil;
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

//TODO: parsing
+ (NSArray *)loadParty {
    
    NSString *filePath = [self dataFilePath:@"Party.xml" forSave:NO];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&error];
    if (doc == nil) { return nil; }
    
    //NSLog(@"%@", doc.rootElement);
    
//    Party *party = [[[Party alloc] init] autorelease];
    NSArray *partyMembers = [doc nodesForXPath:@"//party/character" error:nil];
    for (GDataXMLElement *partyMember in partyMembers) {
        
        // Let's fill these in!
//        Attributes -> Attributes
//        <skill range="">
//          <effects>
//              <effect></effect>
//          </effects>
//        </skill>
//        <passiveskill>
//            <effects>
//                <effect></effect>
//            </effects>
//        </passiveskill>
        
        for (GDataXMLNode *attribute in partyMember.attributes) {
            NSLog(@"Tag name :: %@",partyMember.name);
            NSLog(@"attribute.name :: %@",attribute.name);
            NSLog(@"attribute.value :: %@",attribute.stringValue);
        }
//        
//        // Name
//        NSArray *names = [partyMember elementsForName:@"Attributes"];
//        if (names.count > 0) {
//            GDataXMLElement *firstName = (GDataXMLElement *) [names objectAtIndex:0];
//            name = firstName.stringValue;
//        } else continue;
//        
        
//        Character *role = [[Character alloc] initWithName:name fileName:picFileName roleType:roleType  player:player level:level maxHp:maxHp hp:hp attack:attack defense:defense speed:speed moveSpeed:moveSpeed moveTime:moveTime];
        
//        [party.players addObject:role];
    }
    
//    return party;
    return nil;
}

+ (GDataXMLElement *)getNodeFromXmlFile:(NSString *)fileName TagName:(NSString *)tagName tagId:(NSString *)tagId
{
    //ex: fileName = @"Party.xml"
    NSString *filePath = [self dataFilePath:fileName forSave:NO];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&error];
    if (doc == nil) { return nil; }
    
    NSString *xPath = [[NSString alloc] initWithFormat:@"//%@",tagName];
    NSArray *elements = [doc nodesForXPath:xPath error:nil];
    
    for (GDataXMLElement *element in elements) {
        for (GDataXMLNode *attribute in element.attributes) {
//            NSLog(@"Tag name :: %@",element.name);
//            NSLog(@"attribute.name :: %@",attribute.name);
//            NSLog(@"attribute.value :: %@",attribute.stringValue);
            if ([attribute.name isEqualToString:@"id"]) {
                if ([attribute.stringValue isEqualToString:tagId]) {
                    return [element copy];
                }
            }
        }
    }
    return nil;
}

@end
