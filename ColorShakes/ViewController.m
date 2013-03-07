//
//  ViewController.m
//  ColorShakes
//
//  Created by Aaron Jay on 3/6/13.
//  Copyright (c) 2013 Aaron Jay. All rights reserved.
//

#import "ViewController.h"

#import <CoreMotion/CoreMotion.h>
#include <time.h>

@implementation ViewController

@synthesize lblAuthor;
@synthesize lblColor;
@synthesize lblInstructions;
@synthesize lblTitle;

@synthesize accelerometer;


CMMotionManager *motionManager;
NSMutableArray *XHistory;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.accelerometer = [UIAccelerometer sharedAccelerometer];
    self.accelerometer.updateInterval = UpdateInterval;
    self.accelerometer.delegate = self;
    
    XHistory = [[NSMutableArray alloc] initWithCapacity:HistoryLength];
    YHistory = [[NSMutableArray alloc] initWithCapacity:HistoryLength];
    ZHistory = [[NSMutableArray alloc] initWithCapacity:HistoryLength];

    backgroundColors[0] = [UIColor whiteColor];
    backgroundColors[1] = [UIColor blueColor];
    backgroundColors[2] = [UIColor greenColor];
    backgroundColors[3] = [UIColor redColor];
    backgroundColors[4] = [UIColor yellowColor];
    backgroundColors[5] = [UIColor purpleColor];
    backgroundColors[6] = [UIColor blackColor];
    backgroundColors[7] = [UIColor grayColor];
    
    ColorNames[0] = @"White";
    ColorNames[1] = @"Blue";
    ColorNames[2] = @"Green";
    ColorNames[3] = @"Red";
    ColorNames[4] = @"Yellow";
    ColorNames[5] = @"Purple";
    ColorNames[6] = @"Black";
    ColorNames[7] = @"Gray";
    
    textColors[0] = [UIColor blackColor];
    textColors[1] = [UIColor yellowColor];
    textColors[2] = [UIColor whiteColor];
    textColors[3] = [UIColor whiteColor];
    textColors[4] = [UIColor blackColor];
    textColors[5] = [UIColor whiteColor];
    textColors[6] = [UIColor whiteColor];
    textColors[7] = [UIColor whiteColor];
    
    currentColorIndex = 0;
    
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    [XHistory insertObject:[NSNumber numberWithFloat:acceleration.x] atIndex:0];
    [YHistory insertObject:[NSNumber numberWithFloat:acceleration.y] atIndex:0];
    [ZHistory insertObject:[NSNumber numberWithFloat:acceleration.z] atIndex:0];
    if (HistoryLength < [XHistory count]) {
        [XHistory removeObjectAtIndex:HistoryLength];
        [YHistory removeObjectAtIndex:HistoryLength];
        [ZHistory removeObjectAtIndex:HistoryLength];
    }
    
    if (MinShakeInterval < CACurrentMediaTime() - LastShake) { // avoid back to back shakes
        if (checkShake(XHistory) || checkShake(YHistory) || checkShake(ZHistory)) {
            [XHistory removeAllObjects];
            [YHistory removeAllObjects];
            [ZHistory removeAllObjects];
            LastShake = CACurrentMediaTime(); // save to current value
            int nextColorIndex = currentColorIndex;
            int arraySize = sizeof(backgroundColors) / sizeof(backgroundColors[0]);
            while (nextColorIndex == currentColorIndex) {
                nextColorIndex = arc4random_uniform(arraySize);
            }
            currentColorIndex = nextColorIndex;
            self.view.backgroundColor = backgroundColors[currentColorIndex];
            self.lblAuthor.textColor = textColors[currentColorIndex];
            self.lblColor.textColor = textColors[currentColorIndex];
            self.lblInstructions.textColor = textColors[currentColorIndex];
            self.lblTitle.textColor = textColors[currentColorIndex];
            self.lblColor.text = ColorNames[currentColorIndex];
        }
    }
}

bool checkShake(NSMutableArray *array) {
    float minValue = [[array objectAtIndex:0] floatValue];
    float maxValue = [[array objectAtIndex:0] floatValue];
    
    for (int i = 1; i < [array count]; i++) {
        float thisValue = [[array objectAtIndex:i] floatValue];
        if (thisValue < minValue) {
            minValue = thisValue;
        }
        if (maxValue < thisValue) {
            maxValue = thisValue;
        }
    }
    return (ShakeThreshold < maxValue - minValue);
}


@end

