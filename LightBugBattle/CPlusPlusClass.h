//
//  CPlusPlusClass.h
//  LightBugBattle
//
//  Created by 朱 世光 on 13/2/19.
//
//

#ifndef __LightBugBattle__CPlusPlusClass__
#define __LightBugBattle__CPlusPlusClass__

#include <iostream>

class CPlusPlusClass {
public:
    CPlusPlusClass();
    virtual ~CPlusPlusClass();
    void func();
    void setInt (int i);
    
private:
    int m_i;
};

#endif /* defined(__LightBugBattle__CPlusPlusClass__) */