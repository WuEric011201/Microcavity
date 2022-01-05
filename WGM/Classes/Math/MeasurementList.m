//
//  MeasurementList.m
//  microcavity
//
//  Created by Xiangyi Xu on 8/28/16.
//  Copyright © 2016 Xiangyi Xu. All rights reserved.
//

#import "MeasurementList.h"
#import "GlobalVars.h"
#import "MeasurementMonitor.h"
#import <AudioToolbox/AudioToolbox.h>


@interface MeasurementList ()
@property (weak, nonatomic) IBOutlet UIButton *bandwidth;
@property (weak, nonatomic) IBOutlet UIButton *qfactor;
@property (weak, nonatomic) IBOutlet UIButton *peakX;
@property (weak, nonatomic) IBOutlet UIButton *pKtopK;
@property (weak, nonatomic) IBOutlet UIButton *max;
@property (weak, nonatomic) IBOutlet UIButton *min;


@end

@implementation MeasurementList

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initbuttonBackgroundColor:_bandwidth];
    [self initbuttonBackgroundColor:_qfactor];
    [self initbuttonBackgroundColor:_peakX];
    [self initbuttonBackgroundColor:_pKtopK];
    [self initbuttonBackgroundColor:_max];
    [self initbuttonBackgroundColor:_min];

}

/** Initialize the measure button background */
- (void) initbuttonBackgroundColor:(UIButton*)button
{
    if([self isExitMeasureItem:button.currentTitle])
    {
        button.backgroundColor = [UIColor greenColor];
    }
    else
    {
        button.backgroundColor = [UIColor whiteColor];
    }
    
}

/** Judge whether the measureItem is in the measure list */
-(BOOL)isExitMeasureItem:(NSString*)title
{
    bool existFlag = false;
    GlobalVars *globals = [GlobalVars sharedInstance];
    for(int i=0;i<globals.measureDictionary.count; i++)
    {
      if([[globals.measureDictionary[i] valueForKey:@"measurement_title"] isEqualToString:title])
       {
        existFlag = true;
       }
      else
       {

       }
    }
    return existFlag;
}

/** Search the index of measureItem in the measure list */
- (NSInteger)measureItemIndex:(NSString*)title
{
    NSInteger index=0;
    GlobalVars *globals = [GlobalVars sharedInstance];
    for(int i=0;i<globals.measureDictionary.count; i++)
    {
        if([[globals.measureDictionary[i] valueForKey:@"measurement_title"] isEqualToString:title])
        {
          index = i;
        }
        else
        {
            
        }
    }
    return index;
   
}

/** Add measureItem to the Collectionview */
- (void) addMeasureItemtoCollectionview:(UIButton*)button
{
    GlobalVars *globals = [GlobalVars sharedInstance];
    if(button.backgroundColor !=[UIColor greenColor])
    {
        button.backgroundColor = [UIColor greenColor];
        [globals.measureDictionary addObject:@{@"measurement_title": button.currentTitle, @"measurement_result":@"0.00"}];
        AudioServicesPlaySystemSound(1117);  
        
    }
    else
    {
        button.backgroundColor = [UIColor whiteColor];
        [globals.measureDictionary removeObjectAtIndex:[self measureItemIndex:button.currentTitle]];
        AudioServicesPlaySystemSound(1118);
    }
    
    [[MeasurementMonitor sharedMeasurementMonitor] updateTags];

}

- (IBAction)operateBandwidth:(id)sender
{
    [self addMeasureItemtoCollectionview:_bandwidth];
    
}

- (IBAction)operateQFactor:(id)sender
{
    [self addMeasureItemtoCollectionview:_qfactor];
    
}

- (IBAction)operatePeakX:(id)sender
{
    [self addMeasureItemtoCollectionview:_peakX];
    
}

- (IBAction)operatePktoPk:(id)sender
{
    [self addMeasureItemtoCollectionview:_pKtopK];
    
}

- (IBAction)operateMax:(id)sender
{
    [self addMeasureItemtoCollectionview:_max];
    
}

- (IBAction)operateMin:(id)sender
{
    [self addMeasureItemtoCollectionview:_min];

    
}

@end
    
