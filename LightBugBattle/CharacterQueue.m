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
@property NSMutableArray *queue;
@end

@implementation CharacterQueue
@dynamic count;

//static const int distance = NSIntegerMax;

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
        _queue = [[NSMutableArray alloc] init];

        for (Character *cha in characters) {
            [self addCharacter:cha];
        }
        [self setRandomCharacterQueueObjectTime];
        [self sortQueue];
    }
    return self;
}

#pragma mark - PriorityQueue

-(int)count {
    return _queue.count;
}

-(void)addCharacter:(Character *)newCharacter {
    CharacterQueueObject *newObject = [[CharacterQueueObject alloc] init];
    newObject.character = newCharacter;
    [newObject setCharacterQueueObjectTime];
    
    NSUInteger insertIndex = [self getIndexForCharacterQueueObject:newObject];

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

-(NSString *)description {
    return [[self queue] description];
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

-(int)compareCharacterQueueObject:(CharacterQueueObject *)object1 andObject:(CharacterQueueObject *)object2 {    
    if (object1.time > object2.time) {
        return NSOrderedDescending;
    } else if (object1.time == object2.time) {
        return NSOrderedSame;
    } else {
        return NSOrderedAscending;
    }
}

// Ascending Array
-(void)sortQueue {
    [self.queue sortUsingComparator:^NSComparisonResult(CharacterQueueObject * obj1, CharacterQueueObject * obj2) {
        return [self compareCharacterQueueObject:obj1 andObject:obj2];
    }];
}

-(NSUInteger)getIndexForCharacterQueueObject:(CharacterQueueObject *)object {
    if (self.count == 0) {
        return 0;
    }
    
    for (NSUInteger index = self.count; index > 0; index--) {
        CharacterQueueObject *temp = [self.queue objectAtIndex:index - 1];
        
        if ([self compareCharacterQueueObject:temp andObject:object] <= 0) {
            return index;
        }
    }
    // Object is the fatest
    return 0;
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
