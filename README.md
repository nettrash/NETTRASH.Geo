#  NETTRASH.GEO

[![Build Status](https://travis-ci.org/nettrash/NETTRASH.Geo.svg?branch=master)](https://travis-ci.org/nettrash/NETTRASH.Geo)


## About  

[NETTRASH.GEO](https://apps.apple.com/us/app/nettrash-geo/id1463358981?l=ru&ls=1) is an application for tracking current geographical characteristics, such as location (coordinates), altitude according to satellite readings and calculated by the current atmospheric pressure indicator.  

Additionally, information about current weather and geocoding data on the ground is available in the application.  

And the most interesting, the application saves the parameter data locally on the device, allowing you to watch their change over time in graphical form.  

## Calculation  

![equation](http://latex.codecogs.com/gif.latex?P%3DP_0%20e%5E%5Cfrac%7B-M%20g%20h%7D%20%7BR%20T%7D)

where ![equation](http://latex.codecogs.com/gif.latex?P_0) pressure at sea level (Pa)  
![equation](http://latex.codecogs.com/gif.latex?P) is the pressure at height ![equation](http://latex.codecogs.com/gif.latex?h) (Pa)  
![equation](http://latex.codecogs.com/gif.latex?M) - molar mass of dry air,  
![equation](http://latex.codecogs.com/gif.latex?M%20%3D%200.029%20%5Cfrac%7BKg%7D%20%7Bmol%7D)  
![equation](http://latex.codecogs.com/gif.latex?g) - acceleration of free fall,  
![equation](http://latex.codecogs.com/gif.latex?g%20%3D%209.81%20%5Cfrac%7Bm%7D%20%7Bs%5E2%7D)  
![equation](http://latex.codecogs.com/gif.latex?R) is the universal gas constant,  
![equation](http://latex.codecogs.com/gif.latex?T%20%3D%20273.15%20%2B%20t),  
![equation](http://latex.codecogs.com/gif.latex?T) - absolute air temperature ![equation](http://latex.codecogs.com/gif.latex?K),  
![equation](http://latex.codecogs.com/gif.latex?t) - temperature in ![equation](http://latex.codecogs.com/gif.latex?C)
![equation](http://latex.codecogs.com/gif.latex?h) is the height m  

Convert the formula to calculate the height at a known pressure.    

![equation](http://latex.codecogs.com/gif.latex?%5Cfrac%7BP%7D%20%7BP_0%7D%20%3D%20e%5E%5Cfrac%7B-M%20g%20h%7D%20%7BR%20T%7D%24%20%24%5Crightarrow%24%20%24%5Cln%20%5Cfrac%7BP%7D%20%7BP_0%7D%20%3D%20%5Cfrac%7B_M%20g%20h%7D%20%7BR%20T%7D%24%20%24%5Crightarrow%24%20%24%7BR%20T%7D%20%5Cln%20%5Cfrac%7BP%7D%20%7BP_0%7D%20%3D%20-%7BM%20g%20h%7D%24%20%24%5Crightarrow%24%20%24h%20%3D%20%5Cfrac%7B%7BR%20T%7D%20%5Cln%20%5Cfrac%7BP%7D%20%7BP_0%7D%7D%20%7B-%7BM%20g%7D%7D)

Simplistically, you can write as: ![equation](http://latex.codecogs.com/gif.latex?P_h%20%3D%20P_0%2010%5E%7B-0.000052%20h%7D)  

![equation](http://latex.codecogs.com/gif.latex?P_h%20%3D%20P_0%2010%5E%7B-0.000052%20h%7D%24%20%24%5Crightarrow%24%20%24%5Cfrac%7BP_h%7D%20%7BP_0%7D%20%3D%2010%5E%7B-0.000052%20h%7D%24%20%24%5Crightarrow%24%20%24%5Clg%20%5Cfrac%7BP_h%7D%20%7BP_0%7D%20%3D%20%7B-0.000052%20h%7D%24%20%24%5Crightarrow%24%20%24h%20%3D%20%5Cfrac%7B%5Clg%20%5Cfrac%7BP_h%7D%20%7BP_0%7D%7D%20%7B-0.000052%7D%24%20%24%5Crightarrow%24%20%24h%20%3D%20%5Cfrac%7B%5Cln%20%5Cfrac%7BP_0%7D%20%7BP_h%7D%7D%20%7B0.000052%20%5Cln%2010%7D%24%20%24%5Crightarrow%24%20%24h%20%5Capprox%20%5Cfrac%7B%5Cln%20%5Cfrac%7BP_0%7D%20%7BP_h%7D%7D%20%7B0.00012%7D)

![equation](http://latex.codecogs.com/gif.latex?lg%20x%20%3D%20%5Cfrac%7B%5Cln%20x%7D%20%7Bln%2010%7D)  


![equation](http://latex.codecogs.com/gif.latex?%5Clog%20%5Cfrac%7Bx%7D%20%7By%7D%20%3D%20-%5Clog%20%5Cfrac%7By%7D%20%7Bx%7D)  


## Compass Points

| POINT | DEGREE FROM | DEGREE TO |
|-|-|-|
| NORD | 338 | 22 |
| NORD EAST | 23 | 67 |
| EAST | 68 | 112 |
| SOUTH EAST | 113 | 157 |
| SOUTH | 158 | 202 |
| SOUTH WEST | 203 | 247 |
| WEST | 248 | 292 |
| NORD WEST | 293 | 337 |
|-|-|-|
