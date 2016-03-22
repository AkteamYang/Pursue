//
//  AKTPublic.c
//  Pursue
//
//  Created by YaHaoo on 16/3/19.
//  Copyright © 2016年 YaHaoo. All rights reserved.
//

#include "AKTPublic.h"
/*
 * Safty compare with int float or double.
 */
bool aktValueCompare(double a, double b) {
    double delta = ABS((a-b));
    if (delta>1) {
        return false;
    }else{
        delta *= 1e6;
        if (delta>1) {
            return false;
        }else{
            return true;
        }
    }
}