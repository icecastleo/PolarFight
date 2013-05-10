//
//  GameCenterLayer.m
//  CastleFight
//
//  Created by  DAN on 13/4/23.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "GameCenterLayer.h"
#import "FileManager.h"
#import "AppDelegate.h"

@implementation GameCenterLayer

-(id) init
{
	if (self = [super init])
	{
        GameCenterManager *gkHelper = [FileManager sharedFileManager].gameCenterManager;
		gkHelper.delegate = self;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCMenuItem *showLeaderboard = [CCMenuItemFont itemWithString:@"Show LeaderBoard" target:gkHelper selector:@selector(showLeaderboard)];
        
        CCMenuItem *showAchievement = [CCMenuItemFont itemWithString:@"Show Achievement" target:gkHelper selector:@selector(showAchievements)];
        
        CCMenuItem *resetAchievement = [CCMenuItemFont itemWithString:@"Reset Achievement" target:gkHelper selector:@selector(resetAchievements)];
        
        CCMenu *menu = [CCMenu menuWithItems:showLeaderboard,showAchievement,resetAchievement, nil];
        
        [menu alignItemsVerticallyWithPadding:30];
		[menu setPosition:ccp(size.width/2, size.height/2)];
		
		// Add the menu to the layer
		[self addChild:menu];
        
        // continuously check for walking
//		[self scheduleUpdate];
	}
	return self;
}

-(void)showAchievements {
    
}

-(void) update:(ccTime)delta
{
	// Report time-based achievement, simply try to update achievement every second.
	// The first few attempts will fail because the local player hasn't signed in yet. The failed attempts will be cached.
	/*
    totalTime += delta;
	if (totalTime > 1.0f)
	{
		totalTime = 0.0f;
		
		NSString* playedTenSeconds = @"PlayedForTenSecs";
		GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
		GKAchievement* achievement = [gkHelper getAchievementByID:playedTenSeconds];
		if (achievement.completed == NO)
		{
			float percent = achievement.percentComplete + 10;
			[gkHelper reportAchievementWithID:playedTenSeconds percentComplete:percent];
		}
	}
    //*/
}

#pragma mark GameKitHelper delegate methods

-(void) onLocalPlayerAuthenticationChanged
{
	GKLocalPlayer* localPlayer = GKLocalPlayer.localPlayer;
	CCLOG(@"LocalPlayer isAuthenticated changed to: %@", localPlayer.authenticated ? @"YES" : @"NO");
	
	if (localPlayer.authenticated)
	{
		GameCenterManager* gkHelper = [FileManager sharedFileManager].gameCenterManager;
		[gkHelper getLocalPlayerFriends];
	}
}

-(void) onFriendListReceived:(NSArray*)friends
{
	CCLOG(@"onFriendListReceived: %@", friends.description);
	
	GameCenterManager* gkHelper = [FileManager sharedFileManager].gameCenterManager;
	
	if (friends.count > 0)
	{
		[gkHelper getPlayerInfo:friends];
	}
	else
	{
		[gkHelper submitScore:1234 category:@"Playtime"];
	}
}

//FIXME: Do we need this?
-(void) onPlayerInfoReceived:(NSArray*)players
{
	CCLOG(@"onPlayerInfoReceived: %@", players.description);
	
	for (GKPlayer* gkPlayer in players)
	{
		CCLOG(@"PlayerID: %@, Alias: %@, isFriend: %i", gkPlayer.playerID, gkPlayer.alias, gkPlayer.isFriend);
	}
	
	GameCenterManager* gkHelper = [FileManager sharedFileManager].gameCenterManager;
	[gkHelper submitScore:1234 category:@"Playtime"];
}

#pragma mark Leaderboard
-(void) onScoresSubmitted:(BOOL)success
{
	CCLOG(@"onScoresSubmitted: %@", success ? @"YES" : @"NO");
	
	if (success)
	{
		GameCenterManager* gkHelper = [FileManager sharedFileManager].gameCenterManager;
		[gkHelper retrieveTopTenAllTimeGlobalScores];
	}
}

-(void) onScoresReceived:(NSArray*)scores
{
	CCLOG(@"onScoresReceived: %@", scores.description);
	GameCenterManager* gkHelper = [FileManager sharedFileManager].gameCenterManager;
	[gkHelper showLeaderboard];
}

-(void) onLeaderboardViewDismissed
{
	CCLOG(@"onLeaderboardViewDismissed");
}

#pragma mark Achievements

-(void) onAchievementReported:(GKAchievement*)achievement
{
	CCLOG(@"onAchievementReported: %@", achievement);
}

-(void) onAchievementsLoaded:(NSDictionary*)achievements
{
	CCLOG(@"onLocalPlayerAchievementsLoaded: %@", achievements.description);
}

-(void) onResetAchievements:(BOOL)success
{
	CCLOG(@"onResetAchievements: %@", success ? @"YES" : @"NO");
}

-(void) onAchievementsViewDismissed
{
	CCLOG(@"onAchievementsViewDismissed");
}

@end
