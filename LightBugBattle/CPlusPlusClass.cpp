//
//  CPlusPlusClass.mm
//  LightBugBattle
//
//  Created by 朱 世光 on 13/2/19.
//
//

#include <stdio.h>
#include "CPlusPlusClass.h"

CPlusPlusClass::CPlusPlusClass() : m_i(0)
{
    printf("CPlusPlusClass::CPlusPlusClass()\n");
    func();
}

CPlusPlusClass::~CPlusPlusClass()
{
    printf("CPlusPlusClass::~CPlusPlusClass()\n");
}

void CPlusPlusClass::func() {
    printf("CPlusPlusClass func print: %d\n", m_i);
}

void CPlusPlusClass::setInt(int i) {
    m_i = i;
}