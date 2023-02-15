/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   Time.cpp
 * Author: maria
 * 
 * Created on 20 de febrero de 2018, 11:08
 */

#include <iostream>
#include <iomanip>  // get_time put_time functions
#include <stdexcept> // per manegar excepcions
#include "Time.h"

using namespace std; 

Time::Time(int h, int m, int s){
    this->setHour(h); 
    this->setMinute(m);
    this->setSecond(s); 
}


int Time::getHour() const{
    return this->hour;
}

void Time::setHour(int h){
    if (h>=0 && h<=23 ) {
        this->hour = h; 
    } else { 
        throw invalid_argument("Invalid hora ! ha d'estar entre 0-23"); 
    }
}

int Time:: getMinute() const{
    return this->minute;
}

void Time::setMinute(int m){
    if (m >=0 && m <=59 ){
        this->minute = m; 
    } else {
        throw invalid_argument("Invalid minut ! ha d'estar entre 0-59"); 
    }
}

int Time::getSecond() const{
    return this->second;
}

void Time::setSecond(int s){
     if (s >=0 && s <=59 ){
        this->second = s; 
    } else {
        throw invalid_argument("Invalid segon ! ha d'estar entre 0-59"); 
    }
}

void Time::setTime(int h, int m, int s)
{   
    setHour(h);
    setMinute(m);
    setSecond(s); 

}

void Time::print() const
{
    cout << setfill('0');
    cout << setw(2) << hour << ":" 
         << setw(2) << minute << ":" 
         << setw(2) << second << endl; 
} 
