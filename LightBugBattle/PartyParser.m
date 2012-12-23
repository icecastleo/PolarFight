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
+ (void)saveParty{
  
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

+ (GDataXMLElement *)getNodeFromXmlFile:(NSString *)fileName tagName:(NSString *)tagName tagId:(NSString *)tagId
{
    //ex: fileName = @"Save.xml"
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
