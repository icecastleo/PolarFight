//
//  CharacterQueue.m
//  LightBugBattle
//
//  Created by  浩翔 on 13/1/16.
//
//

#import "CharacterQueue.h"
#import "CharacterQueueObject.h"
#import "Character.h"


@interface CharacterQueue()
@property (atomic, strong) NSMutableArray *queue;
@end

@implementation CharacterQueue
//static const int distance = NSIntegerMax;

-(id)init {
    if ((self = [super init])) {
        [self clear];
    }
    
    return self;
}
/*
-(id)initWithPlayer1Array:(NSArray *)player1 andPlayer2Array:(NSArray *)player2 {
    if ((self = [super init])) {
        [self clear];
        for (Character *cha in player1) {
            [self addCharacter:cha];
        }
        for (Character *cha in player2) {
            [self addCharacter:cha];
        }
        [self setCharacterQueueObjectTime];
        [self sortQueue];
    }
    
    return self;
}
//*/
-(id)initWithCharacterArrayWithRandomTime:(NSArray *)characters {
    if ((self = [super init])) {
        [self clear];
        for (Character *cha in characters) {
            [self addCharacter:cha];
        }
        [self setRandomCharacterQueueObjectTime];
        [self sortQueue];
    }
    
    return self;
}

-(void)clear {
    self.queue = [[NSMutableArray alloc] init];
}

#pragma mark - PriorityQueue

-(void)addCharacter:(Character *)newCharacter {
    CharacterQueueObject *newObject = [[CharacterQueueObject alloc] init];
    newObject.character = newCharacter;
    [newObject setCharacterQueueObjectTime];
    NSUInteger insertIndex = [self getInsertIndexForCharacter:newCharacter withAnimated:NO];

    [self.queue insertObject:newObject atIndex:insertIndex];
    [self.delegate redrawQueueBar];
}

-(Character *)pop {
    CharacterQueueObject * firstObject = [self first];
    Character *firstCharacter = firstObject.character;
    
    if (!firstCharacter) {
        NSAssert(firstCharacter != nil, @"firstCharacter should not nil??");
        return nil;
    }
    [self removeCharacter:firstCharacter withAnimated:NO];
    [self nextTurn:firstObject.time];
    
    return firstCharacter;
}

-(void)removeCharacter:(Character *)character withAnimated:(BOOL)animated{
    BOOL hasRemoved = NO;
    for (CharacterQueueObject *object in self.queue) {
        if ([object hasTheSameCharacter:character]) {
            [self.queue removeObject:object];
            hasRemoved = YES;
            break;
        }
    }
    if (!hasRemoved) {
        //CCLOG(@"The character isn't in the queue.");
    }
    [self.delegate removeCharacter:character withAnimated:animated];
}

-(CharacterQueueObject *)first {
    if (self.queue.count < 1) return nil;
    CharacterQueueObject *firstObject = [self.queue objectAtIndex:0];
    
    return firstObject;
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
        [obj setCharacterQueueObjectTime];
    }
}

-(void)nextTurn:(NSInteger)number {
    for (CharacterQueueObject *obj in self.queue) {
        [obj timeDecrease:number];
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
-(NSUInteger)getInsertIndexForCharacter:(Character *)newCharacter withAnimated:(BOOL)animated{
    CharacterQueueObject *newObject = [[CharacterQueueObject alloc] init];
    newObject.character = newCharacter;
    [newObject setCharacterQueueObjectTime];
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
    [self.delegate insertCharacterAtIndex:insertIndex withAnimated:animated];
    
    return insertIndex;
}

-(NSArray *)currentCharacterQueueArray {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    int count = [self count];
    for (int i=0; i<count; i++) {
        CharacterQueueObject *obj = [self.queue objectAtIndex:i];
        Character *character = obj.character;
        [tempArray addObject:character];
    }
    
    return [tempArray copy];
}

-(void)setRandomCharacterQueueObjectTime {
    for (CharacterQueueObject *obj in self.queue) {
        [obj setCharacterQueueObjectTimeWithaVariable];
    }
}

@end
