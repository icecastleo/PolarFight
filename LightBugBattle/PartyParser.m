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

+ (NSMutableArray *)getRolesArrayFromXMLFile
{
    NSString *filePath = [self dataFilePath:@"Party.xml" forSave:NO];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    
    XmlParser *parser = [[XmlParser alloc] init];
    
    Role *role = [[Role alloc] init];
    
    NSString *str = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    
    NSMutableArray *rolesArray = [parser fromXml:str withObject:role];
    
//    NSLog(@"userArray :: %@", rolesArray);
//    
//    for (Role *roo in rolesArray) {
//        NSLog(@"name :: %@",roo.name);
//        NSLog(@"picture :: %@",roo.picture);
//        NSLog(@"type :: %@",roo.type);
//        NSLog(@"maxHp :: %@",roo.maxHp);
//        NSLog(@"roleId ::%@",roo.roleId);
//    }
    
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
