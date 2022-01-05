//
//  MeasurementMonitor.m
//  microcavity
//
//  Created by Xiangyi Xu on 8/11/16.
//  Copyright © 2016 Xiangyi Xu. All rights reserved.
//
#import "LineChartViewController.h"
#import "MeasurementMonitor.h"
#import "MeasurementCell.h"
#import "MeasurementTag.h"
#import "MeasurementList.h"
#import <MJExtension.h>
#import "AppDelegate.h"
#import "GlobalVars.h"
#import "Singleton.h"
#import "UdpSocket.h"

@interface MeasurementMonitor ()

/** Measurement Model Tags */
@property (nonatomic, strong) NSArray *tags;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MeasurementMonitor

static NSString * const MeasureTagsId = @"Cell";

extern WIFIDATA receivedWifiData;

extern double simulateData[333];

/** Is use simulate data */
extern bool isSimulateData;

/** Freqency range for 976nm/40mA Scan Current is corresponding to 25.2G*/
extern double frequencyRangeFor40mA;

/** Central freqency for 976nm laser is corresponding to 307377G*/
extern double centralfrequencyForLaser;

/** Is Calibrate Data ON */
extern bool isCalibrated ;

extern double spectrumDataAfterCalibration[333];

/** Singleton Mode */
SingletonM(MeasurementMonitor)

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self updateTags];
    
    [self initCollectionViewCell];

    
}

/** Init the defaulted measure items */
-(void)initmeasureItems
{
    GlobalVars *globals = [GlobalVars sharedInstance];    
    [globals.measureDictionary addObject:@{@"measurement_title": @"Peak-X",   @"measurement_result":  @"0.00GHz"}];
    [globals.measureDictionary addObject:@{@"measurement_title": @"Pk to Pk", @"measurement_result":  @"0.00mV"}];
    [globals.measureDictionary addObject:@{@"measurement_title": @"Bandwidth",@"measurement_result":  @"0.00GHz"}];
    [globals.measureDictionary addObject:@{@"measurement_title": @"Q-Factor", @"measurement_result":  @"0.00"}];
}

/** Update cell content in collectionview*/
- (void)updateTags
{
    GlobalVars *globals = [GlobalVars sharedInstance];
    self.tags = [MeasurementTag mj_objectArrayWithKeyValuesArray:globals.measureDictionary];
    [self.collectionView reloadData];    
}

/** Init the measure calculated result*/
- (void)updateMeasureData
{
    NSInteger index=0;
    double value=0;
    double spectrumYData[333];
    double spectrumXData[333];
    
    GlobalVars *globals = [GlobalVars sharedInstance];
    MeasurementList *measurementList=[[MeasurementList alloc] init];
    
    for (int i = 0; i < 333; i++)
    {
        if(isSimulateData)
        {
            spectrumXData[i] = i*frequencyRangeFor40mA/332;
            spectrumYData[i] = (double) (arc4random_uniform(2))+simulateData[i];
        }
        else
        {
            spectrumXData[i] = i*receivedWifiData.ModulateCurrent*frequencyRangeFor40mA/(40*332);
            if(isCalibrated){spectrumYData[i] = spectrumDataAfterCalibration[i];}
            else{spectrumYData[i] = receivedWifiData.spectrumData[i];}
        }
    }
    
    if([measurementList isExitMeasureItem:@"Peak-X"])
    {
       value = spectrumXData[[self arrayMinIndex:spectrumYData arraySize:333]];
       index = [measurementList measureItemIndex:@"Peak-X"];
       [globals.measureDictionary replaceObjectAtIndex:index withObject:@{@"measurement_title": @"Peak-X", @"measurement_result":[NSString stringWithFormat:@"%-.2fGHz",value]}];
    }
    if([measurementList isExitMeasureItem:@"Pk to Pk"])
    {
        value = [self arrayPeakToPeak:spectrumYData arraySize:333];
        index = [measurementList measureItemIndex:@"Pk to Pk"];
        [globals.measureDictionary replaceObjectAtIndex:index withObject:@{@"measurement_title": @"Pk to Pk", @"measurement_result":[NSString stringWithFormat:@"%-.2fmV",value]}];
    }
    if([measurementList isExitMeasureItem:@"Max"])
    {
        value = [self arrayMax:spectrumYData arraySize:333];
        index = [measurementList measureItemIndex:@"Max"];
        [globals.measureDictionary replaceObjectAtIndex:index withObject:@{@"measurement_title": @"Max", @"measurement_result":[NSString stringWithFormat:@"%-.2fmV",value]}];
    }
    if([measurementList isExitMeasureItem:@"Min"])
    {
        value = [self arrayMin:spectrumYData arraySize:333];
        index = [measurementList measureItemIndex:@"Min"];
        [globals.measureDictionary replaceObjectAtIndex:index withObject:@{@"measurement_title": @"Min", @"measurement_result":[NSString stringWithFormat:@"%-.2fmV",value]}];
    }
    if([measurementList isExitMeasureItem:@"Bandwidth"])
    {
        value = [self calculateBandwidth:spectrumXData arrayYValue:spectrumYData arraySize:333];
        index = [measurementList measureItemIndex:@"Bandwidth"];
        [globals.measureDictionary replaceObjectAtIndex:index withObject:@{@"measurement_title": @"Bandwidth", @"measurement_result":[NSString stringWithFormat:@"%-.2fGHz",value]}];
    }
    if([measurementList isExitMeasureItem:@"Q-Factor"])
    {
        value = [self calculateQFactor:spectrumXData arrayYValue:spectrumYData arraySize:333];
        index = [measurementList measureItemIndex:@"Q-Factor"];
        [globals.measureDictionary replaceObjectAtIndex:index withObject:@{@"measurement_title": @"Q-Factor", @"measurement_result":[NSString stringWithFormat:@"%-.2e",value]}];
    }
    [self updateTags];
    
}

- (double)calculateBandwidth:(double *) arrayX arrayYValue:(double *) arrayY arraySize: (int) size
{
    double middleYLevel=0;
    double leftpoint=0,rightpoint=0;
    int i=0,count=0;
    
    middleYLevel = [self arrayMin:arrayY arraySize:333]+[self arrayPeakToPeak:arrayY arraySize:333]/2;

    count=size;
    while(count--)
    {
        if(arrayY[i++]<middleYLevel)
        {
            leftpoint=arrayX[i];
            break;
        }
    }

    count=size;
    i=size-1;
    while(count--)
    {
        if(arrayY[i--]<middleYLevel)
        {
            rightpoint=arrayX[i];
            break;
        }
    }
    
    return rightpoint-leftpoint;
}

- (double)calculateQFactor:(double *) arrayX arrayYValue:(double *) arrayY arraySize: (int) size
{
    double QFactor =0;
    QFactor = centralfrequencyForLaser/[self calculateBandwidth:arrayX arrayYValue:arrayY arraySize:size];
    return QFactor;
}

- (double)arrayMax:(double *) array arraySize: (int) size
{
    double max=array[0];
    
    for(int i=0;i<size;i++)
    {
        if(array[i]>max)
        {
            max = array[i];
        }
    }
    
    return max;
}
     
- (double)arrayMin:(double *) array arraySize: (int) size
{
    double min=array[0];
        
    for(int i=0;i<size;i++)
    {
        if(array[i]<min)
        {
            min = array[i];
        }
    }
        
    return min;
}

- (int)arrayMaxIndex:(double *) array arraySize: (int) size
{
    double max=array[0];
    int index=0;
    
    for(int i=0;i<size;i++)
    {
        if(array[i]>max)
        {
            max = array[i];
            index = i;
        }
    }
    return index;
}

- (int)arrayMinIndex:(double *) array arraySize: (int) size
{
    double min=array[0];
    int index=0;
    
    for(int i=0;i<size;i++)
    {
        if(array[i]<min)
        {
            min = array[i];
            index=i;
        }
    }
    return index;
}

- (double)arrayPeakToPeak:(double *) array arraySize: (int) size
{
    double min=array[0];
    double max=array[0];
    double peaktopeak=0;
    
    for(int i=0;i<size;i++)
    {
        if(array[i]<min)
        {
            min = array[i];
        }
        if(array[i]>max)
        {
            max = array[i];
        }
    }
    
    peaktopeak=max-min;
    
    return peaktopeak;
}


- (void)initCollectionViewCell
{
    //Register Collection View Cell
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([MeasurementCell class]) bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:MeasureTagsId];
   
    //Init Collection View Flowlayout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];

    [flowLayout setItemSize:CGSizeMake(self.view.frame.size.width*0.5-1, self.view.frame.size.height*0.5-1)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
    [self.collectionView setCollectionViewLayout:flowLayout];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return self.tags.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   MeasurementCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MeasureTagsId forIndexPath:indexPath];
   cell.measurementTag = self.tags[indexPath.row];
   return cell;
}



@end
