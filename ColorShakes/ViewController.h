//
//  ViewController.h
//  ColorShakes
//
//  Created by Aaron Jay on 3/6/13.
//  Copyright (c) 2013 Aaron Jay. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HistoryLength  5
#define UpdateInterval  0.1
#define ShakeThreshold  0.1
#define MinShakeInterval 1 

@interface ViewController : UIViewController <UIAccelerometerDelegate>


@property (nonatomic, retain) UIAccelerometer *accelerometer;
@property (strong, nonatomic) IBOutlet UILabel *lblAuthor;
@property (strong, nonatomic) IBOutlet UILabel *lblColor;
@property (strong, nonatomic) IBOutlet UILabel *lblInstructions;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

bool checkShake(NSMutableArray *array);

@end


NSMutableArray *XHistory;
NSMutableArray *YHistory;
NSMutableArray *ZHistory;

CFTimeInterval LastShake = 0;

UIColor *backgroundColors[8];
UIColor *textColors[8];
NSString *ColorNames[8];

int currentColorIndex;

