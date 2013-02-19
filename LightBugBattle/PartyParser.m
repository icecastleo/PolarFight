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

@implementation PartyParser

//TODO: not finish saveParty yet
+ (void)saveParty:(NSArray *)party fileName:(NSString *)fileName {
    GDataXMLElement * partyElement = [GDataXMLNode elementWithName:@"party"];
    int i=0;
    for (Character *character in party) {
        GDataXMLElement * characterElement =
        [GDataXMLNode elementWithName:@"character"];
        NSString *count = [NSString stringWithFormat:@"%03d",i];
        [characterElement addAttribute:[GDataXMLNode elementWithName:@"ol" stringValue:count]];
        
        [characterElement addAttribute:[GDataXMLNode elementWithName:@"id" stringValue:character.characterId]];
        NSString *levelString = [NSString stringWithFormat:@"%d",character.level];
        [characterElement addAttribute:[GDataXMLNode elementWithName:@"level" stringValue:levelString]];
        [partyElement addChild:characterElement];
        i=i+1;
    }
    GDataXMLDocument *document = [[GDataXMLDocument alloc]
                                   initWithRootElement:partyElement];
    NSData *xmlData = document.XMLData;
    
    NSString *filePath = [self dataFilePath:fileName forSave:TRUE];
    NSLog(@"Saving xml data to %@...", filePath);
    [xmlData writeToFile:filePath atomically:YES];
}

+ (NSString *)dataFilePath:(NSString *)fileName forSave:(BOOL)save
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

+ (GDataXMLElement *)getNodeFromXmlFile:(NSString *)fileName tagName:(NSString *)tagName tagAttributeName:(NSString *)tagAttributeName tagAttributeValue:(NSString *)tagAttributeValue
{
    //ex: fileName = @"AllCharacter.xml"
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
            if ([attribute.name isEqualToString:tagAttributeName]) {
                if ([attribute.stringValue isEqualToString:tagAttributeValue]) {
                    return [element copy];
                }
            }
        }
    }
    return nil;
}

+ (NSArray *)getAllNodeFromXmlFile:(NSString *)fileName tagName:(NSString *)tagName tagAttributeName:(NSString *)tagAttributeName {
    //ex: fileName = @"AllCharacter.xml"
    NSString *filePath = [self dataFilePath:fileName forSave:NO];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&error];
    if (doc == nil) { return nil; }
    
    NSString *xPath = [[NSString alloc] initWithFormat:@"//%@",tagName];
    NSArray *elements = [doc nodesForXPath:xPath error:nil];
    
    NSMutableArray *characterIdArray = [[NSMutableArray alloc] init];
    
    for (GDataXMLElement *element in elements) {
        for (GDataXMLNode *attribute in element.attributes) {
            if ([attribute.name isEqualToString:tagAttributeName]) {
                [characterIdArray addObject:attribute.stringValue];
            }
        }
    }
    
    return characterIdArray; //(NSString *)CharacterIds are in the array. 
}

+ (NSArray *)getAllAimationPlistFromCharacterName:(NSString *)name {
    
    NSString *directory = [NSString stringWithFormat:@"%@/Animations",name];
    NSArray *directoryAndFileNames = [[NSBundle mainBundle] pathsForResourcesOfType:@"plist" inDirectory:directory];
    
    NSMutableArray *fileNames = [NSMutableArray array];
    for (NSString *path in directoryAndFileNames) {
        NSArray *fileArray = [path componentsSeparatedByString:@"/"];
        NSString *fileName = [fileArray lastObject];
        [fileNames addObject:fileName];
    }
    
//    NSLog(@"Animations: %@",fileNames);
    return fileNames;
}

+ (NSArray *)getAllSoundsPlistFromCharacterName:(NSString *)name {
    
    NSString *directory = [NSString stringWithFormat:@"%@/Sounds",name];
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:directory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = [[NSError alloc] init];
    NSArray *fileNames = [fileManager contentsOfDirectoryAtPath:path error:&error];
    
//    NSMutableArray *directoryAndFileNames = [NSMutableArray array];
//    for (NSString * fileName in fileNames) {
//        NSString *direcotryAndFileName = [path stringByAppendingPathComponent:fileName];
//        [directoryAndFileNames addObject:direcotryAndFileName];
//    }
    
//    NSLog(@"Sounds: %@",fileNames);
    return fileNames;
}

@end
