/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   Time.h
 * Author: maria
 *
 * Created on 20 de febrero de 2018, 11:08
 */

#ifndef TIME_H
#define TIME_H

class Time {
public:

    Time(int h= 0, int m = 0, int s=0);
    
    int getHour() const; 
    void setHour(int h); 
    int getMinute() const; 
    void setMinute(int m); 
    int getSecond() const; 
    void setSecond(int s);
    void setTime(int h, int m, int s); 
    void print() const; 
    
private:
    
    int hour;  // 0- 23 
    int minute; // 0-59
    int second; // 0-59

};

#endif /* TIME_H */

