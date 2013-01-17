//
//  CharacterQueue.m
//  LightBugBattle
//
//  Created by  浩翔 on 13/1/16.
//
//

#import "CharacterQueue.h"
#import "Character.h"

@implementation CharacterQueueObject
@synthesize time = _time;

-(void)setCharacterQueueObjectTime:(NSUInteger)distance {
    int agile = [self.character getAttribute:kCharacterAttributeAgile].value;
    _time = distance/agile;
}
-(void)timeDecrease {
    if (self.time > 1) {
        _time--;
    }else {
        _time = 0;
    }
}
-(BOOL)hasTheSameCharacter:(Character *)newCharacter {
    if (self.character == newCharacter) {
        return YES;
    }
    return NO;
}
@end

@interface CharacterQueue() {
    int distance;
}

@property (atomic, strong) NSMutableArray *queue;
@end

@implementation CharacterQueue
@synthesize queue = _queue;

static const int defaultDistance = 9999;

int lcm(int a,int b) {
    if (a==0 || b==0) {
        return 0;
    }
    int n;
    for(n=a; n<=a*b;n++) {
        if(n%a == 0 && n%b == 0)
            return n;
    }
    return 0;
}

-(id)init {
    if ((self = [super init])) {
        [self clear];
        distance = defaultDistance;
    }
    
    return self;
}

-(id)initWithPlayer1Array:(NSArray *)player1 andPlayer2Array:(NSArray *)player2 {
    if ((self = [super init])) {
        [self clear];
        for (Character *cha in player1) {
            [self addCharacter:cha];
        }
        for (Character *cha in player2) {
            [self addCharacter:cha];
        }
        distance = 1;
        for (CharacterQueueObject *obj in self.queue) {
            int agile = [obj.character getAttribute:kCharacterAttributeAgile].value;
            distance = lcm(distance,agile);
        }
        if (distance == 0) {
            distance = defaultDistance;
        }
        [self setCharacterQueueObjectTime];
        
//        for (CharacterQueueObject *obj in self.queue) {
//            NSLog(@"%d player's %@ Agile :: %d",obj.character.player,obj.character.name,[obj.character getAttribute:kCharacterAttributeAgile].value );
//        }
//        NSLog(@"============================");
        
        [self sortQueue];
        
//        for (CharacterQueueObject *obj in self.queue) {
//            NSLog(@"%d player's %@ Agile :: %d",obj.character.player,obj.character.name,[obj.character getAttribute:kCharacterAttributeAgile].value );
//        }
    }
    
    return self;
}

-(void)clear {
    self.queue = [[NSMutableArray alloc] init];
}

#pragma mark - JCPriorityQueue

-(void)addCharacter:(Character *)newCharacter {
    CharacterQueueObject *newObject = [[CharacterQueueObject alloc] init];
    newObject.character = newCharacter;
    [newObject setCharacterQueueObjectTime:distance];
    NSUInteger insertIndex = [self getInsertIndexForCharacter:newCharacter];

    [self.queue insertObject:newObject atIndex:insertIndex];
//    for (CharacterQueueObject *obj in self.queue) {
//        NSLog(@"%d player's %@ time :: %d",obj.character.player,obj.character.name,obj.time);
//    }
//    NSLog(@"============================");
}

-(Character *)pop {
    Character * firstObject = [self first];
    
    if (!firstObject) {
        return nil;
    }
    [self removeCharacter:firstObject];
    [self nextTurn];
//    for (CharacterQueueObject *obj in self.queue) {
//        NSLog(@"%d player's %@ time :: %d",obj.character.player,obj.character.name,obj.time);
//    }
//    NSLog(@"============pop================");
    return firstObject;
}

-(void)removeCharacter:(Character *)character {
    BOOL hasRemoved = NO;
    for (CharacterQueueObject *object in self.queue) {
        if ([object hasTheSameCharacter:character]) {
            [self.queue removeObject:object];
            hasRemoved = YES;
            break;
        }
    }
    if (!hasRemoved) {
        CCLOG(@"The character isn't in the queue.");
    }
}

-(Character *)first {
    if (self.queue.count < 1) return nil;
    CharacterQueueObject *firstObject = [self.queue objectAtIndex:0];
    Character *firstCharacter = firstObject.character;
    
    return firstCharacter;
}

-(NSUInteger)count {
    return self.queue.count;
}

-(NSString *)description {
    return [[self queue] description];
}

-(NSUInteger)lastIndex {
    if (self.queue.count > 0) 
        return self.queue.count - 1;
    
    return 0;
}

-(void)setCharacterQueueObjectTime {
    for (CharacterQueueObject *obj in self.queue) {
        [obj setCharacterQueueObjectTime:distance];
    }
}

-(void)nextTurn {
    for (CharacterQueueObject *obj in self.queue) {
        [obj timeDecrease];
    }
}

-(BOOL)compareAgileWithCharacter1:(CharacterQueueObject *)object1 andCharacter2:(CharacterQueueObject *)object2 {
    int time1 = object1.time;
    int time2 = object2.time;
    
    return (time1 > time2);
}

// Ascending Array
-(void)sortQueue {
    [self.queue sortUsingComparator:^NSComparisonResult(CharacterQueueObject * obj1, CharacterQueueObject * obj2) {
        
        if( ![self compareAgileWithCharacter1:obj1 andCharacter2:obj2]) {
            return NSOrderedAscending;
        }
        else if ( [self compareAgileWithCharacter1:obj1 andCharacter2:obj2] ) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
}

#pragma mark Custom Functions
-(NSUInteger)getInsertIndexForCharacter:(Character *)newCharacter {
    CharacterQueueObject *newObject = [[CharacterQueueObject alloc] init];
    newObject.character = newCharacter;
    [newObject setCharacterQueueObjectTime:distance];
    NSUInteger last_index = [self lastIndex];
    NSUInteger insertIndex = [self count];
    
    if (last_index < [self count]) {
        CharacterQueueObject *lastObj = [self.queue objectAtIndex:last_index];
        
        while ([self compareAgileWithCharacter1:lastObj andCharacter2:newObject]) {
            insertIndex = last_index;
            if ( 0 < last_index) {
                last_index--;
                lastObj = [self.queue objectAtIndex:last_index];
            }else {
                break;
            }
        }
    }
    return insertIndex;
}

-(NSUInteger)getInsertIndexAndAddCharacter:(Character *)newCharacter {
    NSUInteger insertIndex = [self getInsertIndexForCharacter:newCharacter];
    [self addCharacter:newCharacter];
    return insertIndex;
}

@end
