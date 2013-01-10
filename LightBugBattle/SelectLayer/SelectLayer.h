//
//  SelectLayer.h
//  LightBugBattle
//
//  Created by  浩翔 on 12/11/1.
//
//

#import "cocos2d.h"
#import "SWTableView.h"

@interface SelectLayer : CCLayer <SWTableViewDataSource,SWTableViewDelegate>{
	CCLayerColor   *backgroundLayer;
    SWTableView   *tableView;
    NSMutableArray * allRoleBases;
}

@property (nonatomic,strong) NSMutableArray *selectedRoles;

+(CCScene *) scene;

@end
