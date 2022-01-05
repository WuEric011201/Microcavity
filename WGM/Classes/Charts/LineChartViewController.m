//
//  LineChartViewController.m
//
//  Created by Xiangyi Xu on 31/7/16.
//  https://github.com/danielgindi/Charts
//

#import "LineChartViewController.h"
#import "microcavity_Bridging_Header.h"
#import "microcavity-Swift.h"
#import "GlobalVars.h"
#import "UdpSocket.h"
#import <CoreLocation/CoreLocation.h>

@interface LineChartViewController () <ChartViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) IBOutlet LineChartView *chartView;
@property (weak, nonatomic) IBOutlet UILabel *gpsInfo;





@end

@implementation LineChartViewController

extern double simulateData[333];
extern WIFIDATA receivedWifiData;

/** Is use simulate data */
extern bool isSimulateData;

/** Is UDP Connected */
extern bool isUDPConnected;

/** Freqency range for 976nm/40mA Scan Current is corresponding to 25.2G*/
double frequencyRangeFor40mA = 25.2;

/** Central freqency for 976nm laser is corresponding to 307377G*/
double centralfrequencyForLaser = 307377;

/** Is Calibrate Data ON */
extern bool isCalibrated ;

extern double spectrumDataAfterCalibration[333];

/** Singleton Mode */
SingletonM(LineChartViewController)


CLLocationManager *lm;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Transmission Spectrum";
    self.options = @[
                     @{@"key": @"toggleFilled", @"label": @"Toggle Filled"},
                     @{@"key": @"clearChart", @"label": @"Clear Chart"},
                     @{@"key": @"animateX", @"label": @"Animate X"},
                     @{@"key": @"animateY", @"label": @"Animate Y"},
                     @{@"key": @"animateXY", @"label": @"Animate XY"},
                     @{@"key": @"toggleCircles", @"label": @"Toggle Circles"},
                     ];
    
    _chartView.delegate = self;
    _chartView.chartDescription.enabled = NO;
    
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.pinchZoomEnabled = YES;
    _chartView.drawGridBackgroundEnabled = NO;
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.gridLineWidth = 0.8;
    xAxis.gridLineDashLengths = @[@1.f, @1.f];
    xAxis.labelPosition = XAxisLabelPositionBottomInside;
    xAxis.labelTextColor= UIColor.whiteColor;
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.gridLineWidth = 0.8;
    leftAxis.gridLineDashLengths = @[@1.f, @1.f];
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.labelTextColor = UIColor.whiteColor;

    _chartView.rightAxis.enabled = NO;

    _chartView.highlightPerTapEnabled = YES;
    
    [self updateChartData];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateChartData
{
    if (self.shouldHideData)
    {
        _chartView.data = nil;
        return;
    }
    
    [self setDataCount:333];  //TOTAL RECEIVED 333 Points

}

- (void)setDataCount:(int)count
{
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    GlobalVars *globals = [[GlobalVars alloc] init];    
    [globals calculateSpectrumDataAfterCalibration];
    
    for (int i = 0; i < count; i++)
    {
        double valY=0;
        double valX=0;
        if(isSimulateData)
        {
          valX = i*frequencyRangeFor40mA/(count-1);
          valY = (double) (arc4random_uniform(2))+simulateData[i];
        }
        else
        {
          valX = i*receivedWifiData.ModulateCurrent*frequencyRangeFor40mA/(40*(count-1));
          if(isCalibrated){valY = spectrumDataAfterCalibration[i];}
          else{valY = receivedWifiData.spectrumData[i];}

        }
        [values addObject:[[ChartDataEntry alloc] initWithX:valX y:valY]];
    }
    
    LineChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        set1.values = values;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithValues:values  label:@"Transmission Spectrum"];
        [set1 setColor:UIColor.greenColor alpha:1];
        [set1 setCircleColor:UIColor.redColor];
        set1.lineWidth = 2.0;
        set1.circleRadius = 3.0;
        set1.drawCircleHoleEnabled = NO;
        set1.valueFont = [UIFont systemFontOfSize:9.f];
        
        NSArray *gradientColors = @[
                                    (id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor
                                    ];
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        
        set1.fillAlpha = 1.f;
        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
        set1.drawFilledEnabled = NO;
        
        set1.drawCirclesEnabled =NO;
        set1.drawValuesEnabled=NO;
        set1.drawCirclesEnabled =NO;
        
        [set1 setDrawHighlightIndicators:NO];
        
        CGGradientRelease(gradient);
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        
        _chartView.data = data;
    }
    
}


- (void)optionTapped:(NSString *)key
{

    if ([key isEqualToString:@"toggleCoordinate"])
    {
        [_chartView setNeedsDisplay];
        return;
    }
    
    if ([key isEqualToString:@"toggleFilled"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawFilledEnabled = !set.isDrawFilledEnabled;
        }
        
        [_chartView setNeedsDisplay];
        return;
    }
    
    if ([key isEqualToString:@"toggleCircles"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawCirclesEnabled = !set.isDrawCirclesEnabled;
        }
        
        [_chartView setNeedsDisplay];
        return;
    }
    
    if ([key isEqualToString:@"toggleCubic"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawCubicEnabled = !set.isDrawCubicEnabled;
        }
        
        [_chartView setNeedsDisplay];
        return;
    }

    if ([key isEqualToString:@"toggleStepped"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawSteppedEnabled = !set.isDrawSteppedEnabled;
        }

        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleHorizontalCubic"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.mode = set.mode == LineChartModeCubicBezier ? LineChartModeHorizontalBezier : LineChartModeCubicBezier;
        }
        
        [_chartView setNeedsDisplay];
        return;
    }

    [super handleOption:key forChartView:_chartView];
}

#pragma mark - Actions

- (void)autoScale
{
    [_chartView fitScreen];
    [_chartView setNeedsDisplay];
}

- (void)autoAjustYScale
{
    [_chartView.leftAxis resetCustomAxisMax];
    [_chartView.leftAxis resetCustomAxisMin];
    [_chartView setNeedsDisplay];
}

- (void)fixYScale
{
    [_chartView.leftAxis setAxisMinValue:_chartView.leftAxis.axisMinimum ];
    [_chartView.leftAxis setAxisMaxValue:_chartView.leftAxis.axisMaximum ];
    [_chartView setNeedsDisplay];
}

- (void)clearChart
{
    [_chartView clearValues];
}


- (void)turnONGPS
{
    lm = [[CLLocationManager alloc] init];
    lm.delegate = self;
    lm.desiredAccuracy = kCLLocationAccuracyBest;
    lm.distanceFilter = kCLDistanceFilterNone;
   
    if([lm respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
      [lm requestAlwaysAuthorization];
      [lm requestWhenInUseAuthorization];
    }
    
    [lm startUpdatingLocation];
}

- (void)turnOFFGPS
{
    [lm stopUpdatingLocation];
    _gpsInfo.text = @"";
}

- (void) locationManager: (CLLocationManager *) manager
     didUpdateToLocation: (CLLocation *) newLocation
            fromLocation: (CLLocation *) oldLocation{
    NSString *lat = [[NSString alloc] initWithFormat:@"%g",
                     newLocation.coordinate.latitude];

    NSString *lng = [[NSString alloc] initWithFormat:@"%g",
                     newLocation.coordinate.longitude];
    _gpsInfo.text = [NSString stringWithFormat:@"GPS Latitude: %@ Longitude: %@",lat,lng];

}

- (void) locationManager: (CLLocationManager *) manager
        didFailWithError: (NSError *) error {
    
    _gpsInfo.text = @"GPS Signal Loss!";

}
#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
//    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
//    NSLog(@"chartValueNothingSelected");
}

@end
