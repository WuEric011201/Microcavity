//
//  ViewController.m
//  microcavity
//
//  Created by Xiangyi Xu on 7/30/16.
//  Copyright © 2016 Xiangyi Xu. All rights reserved.
//

#import "ViewController.h"
#import "microcavity_Bridging_Header.h"
#import "microcavity-Swift.h"
#import "LineChartViewController.h"
#import "DemoBaseViewController.h"
#import "SystemParametersMonitor.h"
#import "MeasurementMonitor.h"
#import "MeasurementList.h"
#import "StringProcess.h"
#import "screenShot.h"
#import "UdpSocket.h"
#import <AudioToolbox/AudioToolbox.h>


@interface ViewController()

@property (nonatomic,weak) IBOutlet NSLayoutConstraint *button1X;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *button2X;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *button3X;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *button4X;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *button5X;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *button6X;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *button7X;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *button8X;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *button9X;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *button10X;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *button11X;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *button12X;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *button13X;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *button14X;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *button15X;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *button16X;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *button17X;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *button18X;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *button19X;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *button20X;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *button21X;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *button22X;


@property (weak, nonatomic) IBOutlet UIButton *runStopButton;
@property (weak, nonatomic) IBOutlet UIButton *simulateButton;
@property (weak, nonatomic) IBOutlet UIButton *ldButton;
@property (weak, nonatomic) IBOutlet UIButton *tecButton;
@property (weak, nonatomic) IBOutlet UIButton *fixYButton;
@property (weak, nonatomic) IBOutlet UIButton *screenButton;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UIButton *tAddButton;
@property (weak, nonatomic) IBOutlet UIButton *tMinusButton;
@property (weak, nonatomic) IBOutlet UIButton *iAddButton;
@property (weak, nonatomic) IBOutlet UIButton *iMinusButton;
@property (weak, nonatomic) IBOutlet UIButton *setTButton;
@property (weak, nonatomic) IBOutlet UIButton *setIButton;
@property (weak, nonatomic) IBOutlet UIButton *setScanButton;
@property (weak, nonatomic) IBOutlet UIButton *saveSetButton;
@property (weak, nonatomic) IBOutlet UIButton *calstatusButton;
@property (weak, nonatomic) IBOutlet UIButton *gpsButton;

//@property(nonatomic,retain) CLLocationManager* locationmanager;

/** Timer */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController


extern double simulateData[333];
extern double yData[333];
extern WIFIDATA receivedWifiData;

/** Popup View Status */
bool measurePopupViewFlag = false;

/** Is use simulate data */
bool isSimulateData = false;

/** Is UDP Connected */
extern bool isUDPConnected;

/** Is Calibrate Data ON */
bool isCalibrated = true;

extern double spectrumDataAfterCalibration[333];

/** Freqency range for 976nm/40mA Scan Current is corresponding to 25.2G*/
extern double frequencyRangeFor40mA;

/** Singleton Mode */
SingletonM(ViewController)

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self transmissionspectrumViewLoad];
    [self systemParametersMonitorViewLoad];
    [self measurementMonitorViewLoad];
    [self initButton];
   
    
    [[UdpSocket sharedUdpSocket] initSocket];
 
}

/** When the MainStoryboard is appeared, clear the data from the chart */
- (void)viewDidAppear:(BOOL)animated
{
    [[LineChartViewController sharedLineChartViewController] clearChart];
    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    BOOL flag = NO;
    flag = (BOOL)[defaults objectForKey:@"Agree"];
    if(!flag)
    {
        [self licensepopup];
    }
    else
    {
        
    }
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}
/** popup license agreement*/

- (void)licensepopup
{
    
    //Initalize UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Copyright © 2017 Washington University in St. Louis" message:@"Washington University (“WU”) hereby grants to you a revocable, non-transferable, non-exclusive,royalty-free, non-commercial license to download, install and use microCavity (“SOFTWARE”), on a single mobile device owned and controlled by you. The SOFTWARE may not be distributed, shared, or transferred to any third party. This license can be terminated at any time and does not grant any rights or licenses to any other patents, copyrights, or other forms of intellectual property owned or controlled by WU. YOU AGREE THAT THE SOFTWARE PROVIDED HEREUNDER IS EXPERIMENTAL AND IS PROVIDED “AS IS”, WITHOUT ANY WARRANTY OF ANY KIND, EXPRESSED OR IMPLIED, INCLUDING WITHOUT LIMITATION WARRANTIES OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE, OR NON-INFRINGEMENT OF ANY THIRD-PARTY PATENT, COPYRIGHT, OR ANY OTHER THIRD-PARTY RIGHT.  IN NO EVENT SHALL THE CREATORS OF THE SOFTWARE OR WU BE LIABLE FOR ANY DIRECT, INDIRECT, SPECIAL, OR CONSEQUENTIAL DAMAGES ARISING OUT OF OR IN ANY WAY CONNECTED WITH THE SOFTWARE, THE USE OF THE SOFTWARE, OR THIS AGREEMENT, WHETHER IN BREACH OF CONTRACT, TORT OR OTHERWISE, EVEN IF SUCH PARTY IS ADVISED OF THE POSSIBILITY OF SUCH DAMAGES "
                                          
     preferredStyle:UIAlertControllerStyleAlert];
    
    //Create actions
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Agree" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        [defaults setBool: YES forKey:@"Agree"];
        [defaults synchronize];    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Disagree" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        exit(0);     }];
    
    //Add actions
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    //Present UIAlertController
    [self presentViewController:alertController animated:YES completion:nil];
    
}


/** Init Button */
-(void)initButton
{

    _fixYButton.backgroundColor = [UIColor lightGrayColor];
    [_fixYButton setTitle:@"AutoY" forState:UIControlStateNormal];
    
    _ldButton.backgroundColor = [UIColor lightGrayColor];
    [_ldButton setTitle:@"LD OFF" forState:UIControlStateNormal];
    
    _tecButton.backgroundColor = [UIColor lightGrayColor];
    [_tecButton setTitle:@"TEC OFF" forState:UIControlStateNormal];
    
    _connectButton.backgroundColor = [UIColor lightGrayColor];
    [_connectButton setTitle:@"Connect" forState:UIControlStateNormal];
    
    _runStopButton.backgroundColor = [UIColor redColor];
    
    _calstatusButton.backgroundColor = [UIColor greenColor];
    [_calstatusButton setTitle:@"Cal ON" forState:UIControlStateNormal];

    _gpsButton.backgroundColor = [UIColor lightGrayColor];
    [_gpsButton setTitle:@"GPS OFF" forState:UIControlStateNormal];
    
    [self setLaserOperationButton:false];
    
}

/** Load transmission spectrum chart view */
-(void)transmissionspectrumViewLoad
{
    LineChartViewController *transmissionspectrumView=[[LineChartViewController alloc] init];
    [self addChildViewController:transmissionspectrumView];
    [self updateViewConstraints];
    transmissionspectrumView.view.frame = CGRectMake(3, 36, (self.button1X.constant+6)*8-6, self.view.frame.size.height-(36)*2);
    [self.view addSubview:transmissionspectrumView.view];
}

/** Load SystemParametersMonitor view */
-(void)systemParametersMonitorViewLoad
{
    SystemParametersMonitor *systemParametersMonitorView=[[SystemParametersMonitor alloc] init];
    [self addChildViewController:systemParametersMonitorView];
    systemParametersMonitorView.view.frame = CGRectMake((self.button1X.constant+6)*8, 36, self.view.frame.size.width-(self.button1X.constant+6)*8-3, (self.view.frame.size.height-72)*0.8);
    [self.view addSubview:systemParametersMonitorView.view];
}

/** Load measurementMonitor view */
-(void)measurementMonitorViewLoad
{
    MeasurementMonitor *measurementMonitorView=[[MeasurementMonitor alloc] init];
    [self addChildViewController:measurementMonitorView];
    measurementMonitorView.view.frame = CGRectMake((self.button1X.constant+6)*8, 36+(self.view.frame.size.height-72)*0.8+1, self.view.frame.size.width-(self.button1X.constant+6)*8-3, (self.view.frame.size.height-72)*0.2-1);
    [measurementMonitorView viewDidLoad];
    
    [[MeasurementMonitor sharedMeasurementMonitor] initmeasureItems];
    [[MeasurementMonitor sharedMeasurementMonitor] updateTags];
    
    [self.view addSubview:measurementMonitorView.view];
    
}

/** Update button constrains */
-(void)updateViewConstraints
{
    [self autoArrangeButtonWidthConstraints:@[self.button1X,
                                              self.button2X,
                                              self.button3X,
                                              self.button4X,
                                              self.button5X,
                                              self.button6X,
                                              self.button7X,
                                              self.button8X,
                                              self.button9X,
                                              self.button10X,
                                              self.button11X]];
    
    [self autoArrangeButtonWidthConstraints:@[self.button12X,
                                              self.button13X,
                                              self.button14X,
                                              self.button15X,
                                              self.button16X,
                                              self.button17X,
                                              self.button18X,
                                              self.button19X,
                                              self.button20X,
                                              self.button21X,
                                              self.button22X]];
     
    [super updateViewConstraints];
}

/** Update button status, include LD and TEC */
-(void)updateLDTECButtonStatus
{
    if(receivedWifiData.LDStatus)
    {
        _ldButton.backgroundColor = [UIColor lightGrayColor];
        [_ldButton setTitle:@"LD OFF" forState:UIControlStateNormal];
    }
    else
    {
        _ldButton.backgroundColor = [UIColor greenColor];
        [_ldButton setTitle:@"LD ON" forState:UIControlStateNormal];
    }
    
    if(receivedWifiData.TECStatus)
    {
        _tecButton.backgroundColor = [UIColor lightGrayColor];
        [_tecButton setTitle:@"TEC OFF" forState:UIControlStateNormal];
    }
    else
    {
        _tecButton.backgroundColor = [UIColor greenColor];
        [_tecButton setTitle:@"TEC ON" forState:UIControlStateNormal];
    }
    
}

/** Update button status when losing UDP connection, including run/stop and connect button */
-(void)updateButtonStatusUDPDisconnect
{
    _connectButton.backgroundColor = [UIColor lightGrayColor];
    if(!isSimulateData)
    {
      [self stopTimer];
      _runStopButton.backgroundColor = [UIColor redColor];
    }

}

/** Update button status when UDP is connected, including connect button */
-(void)updateButtonStatusUDPConnect
{
    _connectButton.backgroundColor = [UIColor greenColor];
    
}

/** Enable or disbale the Laser Setting Button */
-(void)setLaserOperationButton:(BOOL) status
{

    _ldButton.enabled = status;
    _tecButton.enabled =status;
    _iAddButton.enabled = status;
    _iMinusButton.enabled = status;
    _tAddButton.enabled = status;
    _tMinusButton.enabled = status;
    _setIButton.enabled = status;
    _setTButton.enabled = status;
    _setScanButton.enabled = status;
    _saveSetButton.enabled = status;

}

/** Auto set button width */
-(void)autoArrangeButtonWidthConstraints:(NSArray *)constraintArray
{
    CGFloat width=(self.view.frame.size.width-6-(6*(constraintArray.count-1)))/(constraintArray.count);
    for(int i=0;i<constraintArray.count;i++)
    {
        NSLayoutConstraint *constraint=constraintArray[i];
        constraint.constant=width;
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** Connect to UDP */
- (IBAction)connectToUDP:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    if([self checkButtonStatus:_connectButton unfunctionedColor:[UIColor lightGrayColor] functionedColor:[UIColor greenColor]])
    {
        [[UdpSocket sharedUdpSocket] udpDisconnect];
        _connectButton.backgroundColor = [UIColor lightGrayColor];
    }
    else
    {
        [[UdpSocket sharedUdpSocket] udpConnect];
        _connectButton.backgroundColor = [UIColor greenColor];

    }

    
}

/** Require single waveform */
- (IBAction)acquireSingleFrame:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    if(_runStopButton.backgroundColor == [UIColor greenColor])
    {
        _runStopButton.backgroundColor = [UIColor redColor];
        [self stopTimer];

    }
    else if(isUDPConnected|isSimulateData)
    {
        [self updateData];
    }
    
   AudioServicesPlaySystemSound(1117);  //begin_video_record.caf

}

/** Autoscale Chart */
- (IBAction)autoScaleChart:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    AudioServicesPlaySystemSound(1117);
    [[LineChartViewController sharedLineChartViewController] autoScale];
}

/** Fix Y or Auto Y Axis */
- (IBAction)yAxisOperate:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    if([self checkButtonStatus:_fixYButton unfunctionedColor:[UIColor lightGrayColor] functionedColor:[UIColor greenColor]])
        {
          [[LineChartViewController sharedLineChartViewController] autoAjustYScale];
          AudioServicesPlaySystemSound(1118);

        }
    else
       {
         [[LineChartViewController sharedLineChartViewController] fixYScale];
         AudioServicesPlaySystemSound(1117);
       }
    [self switchButtonStatus:_fixYButton unfunctionedColor:[UIColor lightGrayColor] functionedColor:[UIColor greenColor] unfunctionedTitleLabel:@"AutoY" functionedTitleLabel:@"FixY" ];
}


/** Require continuous waveform */
- (IBAction)acquireContinuousFrame:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    if(_runStopButton.backgroundColor == [UIColor greenColor])
      {
        _runStopButton.backgroundColor = [UIColor redColor];
        [self stopTimer];
        AudioServicesPlaySystemSound(1118);  //end_video_record.caf
      }
    else if(isUDPConnected|isSimulateData)
      {
        _runStopButton.backgroundColor = [UIColor greenColor];
        [self startTimer];
        AudioServicesPlaySystemSound(1117);  //begin_video_record.caf
      }
    
}

/** Start a timer to update the chart data continuously */
- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateData) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/** Stop a timer to stop updating the chart data continuously */
- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

/** Update the chart data*/
- (void)updateData
{
//    CFTimeInterval begin = CFAbsoluteTimeGetCurrent();
    MeasurementMonitor *measurementMonitor = [[MeasurementMonitor alloc] init];
    [[LineChartViewController sharedLineChartViewController] updateChartData];
    [[SystemParametersMonitor sharedSystemParametersMonitor] updateSystemParametersMonitor];
    [measurementMonitor updateMeasureData];

//    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
//    NSLog(@"%f", end - begin);

}

/** Simulate the transmission spectrum */
- (IBAction)simulateSpectrum:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    
    if(_simulateButton.backgroundColor == [UIColor greenColor])
    {
        _simulateButton.backgroundColor = [UIColor redColor];
        _runStopButton.backgroundColor  = [UIColor redColor];
        isSimulateData = false;
        [self stopTimer];
        AudioServicesPlaySystemSound(1118);  //end_video_record.caf
    }
    else
    {
        [self stopTimer];
        _simulateButton.backgroundColor = [UIColor greenColor];
        _runStopButton.backgroundColor  = [UIColor greenColor];
        isSimulateData = true;
        [self startTimer];
        AudioServicesPlaySystemSound(1117);  //begin_video_record.caf
        
    }
}

/** Choose the measurement parameters */
- (IBAction)MeasureList:(id)sender
{
    float X=(self.button1X.constant+6)*9-208;
    float Y=(self.view.frame.size.height-36-95)-((self.view.frame.size.height-72)*0.2-1);
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    if(measurePopupViewFlag == false)
    {
      MeasurementList *measureList = [[MeasurementList alloc] init];
      [measureList willMoveToParentViewController:self];
      [self addChildViewController:measureList];
      measureList.view.frame = CGRectMake(X,Y,208,95);
      [self.view addSubview:measureList.view];
      [measureList didMoveToParentViewController:self];

      measurePopupViewFlag = true;

    }
    else
    {        
     UIViewController *vc = [self.childViewControllers lastObject];
        
     [vc willMoveToParentViewController:nil];
     [vc.view removeFromSuperview];
     [vc removeFromParentViewController];
     measurePopupViewFlag = false;
        
    }
    
}

/** close all the popup view */
- (void)closePopupView
{
    NSInteger popupViewNumber=self.childViewControllers.count-3;
    if(popupViewNumber>0)
    {
        for(int i=0;i<popupViewNumber;i++)
        {
            UIViewController *vc = [self.childViewControllers lastObject];
            
            [vc willMoveToParentViewController:nil];
            [vc.view removeFromSuperview];
            [vc removeFromParentViewController];
        }
        
     measurePopupViewFlag = false;
        
    }

}

/** switch button status between the function and unfunction */
- (void) switchButtonStatus:(UIButton*)button unfunctionedColor:(UIColor*)unfunctionedColor functionedColor:(UIColor*)functionedColor unfunctionedTitleLabel:(NSString*)unfunctionedTitleLabel functionedTitleLabel:(NSString*)functionedTitleLabel
{
    if(CGColorGetNumberOfComponents(button.backgroundColor.CGColor) == CGColorGetNumberOfComponents(functionedColor.CGColor))
    {
        button.backgroundColor = unfunctionedColor;
        [button setTitle:unfunctionedTitleLabel forState:UIControlStateNormal];

    }
    
    else if(CGColorGetNumberOfComponents(button.backgroundColor.CGColor) == CGColorGetNumberOfComponents(unfunctionedColor.CGColor))
    {
        button.backgroundColor = functionedColor;
        [button setTitle:functionedTitleLabel forState:UIControlStateNormal];
        
    }
    
    else
    {
        
    }

}


/** check the function or unfunction of button */
- (BOOL) checkButtonStatus:(UIButton*)button unfunctionedColor:(UIColor*)unfunctionedColor functionedColor:(UIColor*)functionedColor
{
    bool function = false;
    
    if(CGColorGetNumberOfComponents(button.backgroundColor.CGColor) == CGColorGetNumberOfComponents(functionedColor.CGColor))
    {
       function = true;

    }
    else if(CGColorGetNumberOfComponents(button.backgroundColor.CGColor) == CGColorGetNumberOfComponents(unfunctionedColor.CGColor))
    {
       function = false;
    }
    
    else
    {
         
    }
    
    return function;
}


/** Control the status of LD */
- (IBAction)laserControl:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    if([self checkButtonStatus:_ldButton unfunctionedColor:[UIColor lightGrayColor] functionedColor:[UIColor greenColor]])
    {
        for(int i=0;i<10;i++)
        {
         [[UdpSocket sharedUdpSocket] sendMessage:@"XYLDOFFZC"];
        }
        _ldButton.backgroundColor = [UIColor lightGrayColor];
         [_ldButton setTitle:@"LD OFF" forState:UIControlStateNormal];
        AudioServicesPlaySystemSound(1118);

    }
    else
    {
        for(int i=0;i<10;i++)
        {
         [[UdpSocket sharedUdpSocket] sendMessage:@"XYLDONZC"];
        }
        _ldButton.backgroundColor = [UIColor greenColor];
         [_ldButton setTitle:@"LD ON" forState:UIControlStateNormal];
        
        AudioServicesPlaySystemSound(1117);
        
    }
}


/** Control the status of TEC */
- (IBAction)tecControl:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    if([self checkButtonStatus:_tecButton unfunctionedColor:[UIColor lightGrayColor] functionedColor:[UIColor greenColor]])
    {
        for(int i=0; i<10;i++)
        {
         [[UdpSocket sharedUdpSocket] sendMessage:@"XYTECOFFZC"];
        }

        _tecButton.backgroundColor = [UIColor lightGrayColor];
        [_tecButton setTitle:@"TEC OFF" forState:UIControlStateNormal];
        AudioServicesPlaySystemSound(1118);
        
    }
    else
    {
        for(int i=0; i<10;i++)
        {
         [[UdpSocket sharedUdpSocket] sendMessage:@"XYTECONZC"];
        }

        _tecButton.backgroundColor = [UIColor greenColor];
        [_tecButton setTitle:@"TEC ON" forState:UIControlStateNormal];
        
        AudioServicesPlaySystemSound(1117);
        
    }
  
}

/** increase the laser temperature by one step */
- (IBAction)increaseTemperature:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    [[UdpSocket sharedUdpSocket] sendMessage:[NSString stringWithFormat:@"XYLD+TZC"]];
    AudioServicesPlaySystemSound(1103);  //Tink.caf
}

/** decrease the laser temperature by one step */
- (IBAction)decreaseTemperature:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    [[UdpSocket sharedUdpSocket] sendMessage:[NSString stringWithFormat:@"XYLD-TZC"]];
    AudioServicesPlaySystemSound(1103);  //Tink.caf
}

/** increase the laser Current by one step */
- (IBAction)increaseCurrent:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    [[UdpSocket sharedUdpSocket] sendMessage:[NSString stringWithFormat:@"XYLD+IZC"]];
    AudioServicesPlaySystemSound(1103);  //Tink.caf
}

/** decrease the laser Current by one step */
- (IBAction)decreaseCurrent:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    [[UdpSocket sharedUdpSocket] sendMessage:[NSString stringWithFormat:@"XYLD-IZC"]];
    AudioServicesPlaySystemSound(1103);  //Tink.caf
}

/** capture screen picture */
- (IBAction)captureScreen:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    _screenButton.enabled = NO;
    AudioServicesPlaySystemSound(1108);  //photoShutter.caf
    screenShot *captureScreen = [[screenShot alloc] init];
    [captureScreen screenShot];
    
    _screenButton.enabled = YES;
       
}

/** For Future Use */
- (IBAction)getGPS:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    
    if([self checkButtonStatus:_gpsButton unfunctionedColor:[UIColor lightGrayColor] functionedColor:[UIColor greenColor]])
    {
        [[LineChartViewController sharedLineChartViewController] turnOFFGPS];
        _gpsButton.backgroundColor = [UIColor lightGrayColor];
        [_gpsButton setTitle:@"GPS OFF" forState:UIControlStateNormal];
        AudioServicesPlaySystemSound(1118);
    }
    else
    {
        [[LineChartViewController sharedLineChartViewController] turnONGPS];
        _gpsButton.backgroundColor = [UIColor greenColor];
        [_gpsButton setTitle:@"GPS ON" forState:UIControlStateNormal];
        AudioServicesPlaySystemSound(1117);
        
    }

}



/** Link to website */
- (IBAction)help:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    
    NSURL *url = [ [ NSURL alloc ] initWithString: @"http://www.ese.wustl.edu/~yang/"];
    [[UIApplication sharedApplication] openURL:url];
    
}

/** Copy Data To Clipborad */
- (IBAction)copyData:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
   
    NSMutableArray *arrayY = [NSMutableArray array];
    NSString *stringY;
    
    NSMutableArray *arrayX = [NSMutableArray array];
    NSString *stringX;

    NSString *string;
   
    if(isCalibrated)
    {
        if(isSimulateData)
        {
            for(int i=0;i<333;i++)
            {
                [arrayX addObject:[ NSString stringWithFormat:@"%-8.3f",i*frequencyRangeFor40mA/332]];
                [arrayY addObject:[ NSString stringWithFormat:@"%-8.3f",simulateData[i]]];
            }
        }
        else
        {
          for(int i=0;i<333;i++)
           {
               [arrayX addObject:[ NSString stringWithFormat:@"%-8.3f",i*receivedWifiData.ModulateCurrent*frequencyRangeFor40mA/(40*332)]];
               [arrayY addObject:[ NSString stringWithFormat:@"%-8.3f",spectrumDataAfterCalibration[i]]];
           }            
        }
        
    }
    else
    {
        if(isSimulateData)
        {
            for(int i=0;i<333;i++)
            {
                [arrayX addObject:[ NSString stringWithFormat:@"%-8.3f",i*frequencyRangeFor40mA/332]];
                [arrayY addObject:[ NSString stringWithFormat:@"%-8.3f",simulateData[i]]];
            }
        }
        else
        {
          for(int i=0;i<333;i++)
           {
            [arrayX addObject:[ NSString stringWithFormat:@"%-8.3f",i*receivedWifiData.ModulateCurrent*frequencyRangeFor40mA/(40*332)]];
            [arrayY addObject:[ NSString stringWithFormat:@"%-8.3f",receivedWifiData.spectrumData[i]]];
           }
        }
        
    }

    stringX = [arrayX componentsJoinedByString:@","];
    stringY = [arrayY componentsJoinedByString:@","];
    
    string = [@"Frequency:" stringByAppendingString:stringX];
    string = [string stringByAppendingString:@"\n"];
    string = [string stringByAppendingString:@"Amplitude:"];
    string = [string stringByAppendingString:stringY];

    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = string;

    AudioServicesPlaySystemSound(1117);  //begin_video_record.caf
    
}

/** Turn ON OFF calibration data*/
- (IBAction)switchCalibrateDataEffect:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    if([self checkButtonStatus:_calstatusButton unfunctionedColor:[UIColor lightGrayColor] functionedColor:[UIColor greenColor]])
    {
        isCalibrated = false;
        _calstatusButton.backgroundColor = [UIColor lightGrayColor];
        [_calstatusButton setTitle:@"Cal OFF" forState:UIControlStateNormal];
        AudioServicesPlaySystemSound(1118);
    }
    else
    {
        isCalibrated = true;
        _calstatusButton.backgroundColor = [UIColor greenColor];
        [_calstatusButton setTitle:@"Cal ON" forState:UIControlStateNormal];
        AudioServicesPlaySystemSound(1117);
    }
}


/** set the laser temperature */
- (IBAction)setTemperature:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    
    //Initalize UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Set Temperature" message:@"Range: 10-50C" preferredStyle:UIAlertControllerStyleAlert];
    
    //Create text for temperature input
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textColor = [UIColor blueColor];
        textField.text = [NSString stringWithFormat:@"%.2f",receivedWifiData.Temperature];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange_TEMP:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    
    //Create actions
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *temperature = alertController.textFields.firstObject;
        NSString *setString;
        setString =[ NSString stringWithFormat:@"%-8.2f",[temperature.text floatValue]];
        for(int i=0;i<10;i++)
            {
             [[UdpSocket sharedUdpSocket] sendMessage:[NSString stringWithFormat:@"XYLT:%@ZC",setString]];
            }
        AudioServicesPlaySystemSound(1103);  //Tink.caf
        
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    if(receivedWifiData.Temperature<=50&&receivedWifiData.Temperature>=0)
    {
        okAction.enabled = YES;
    }
    else
    {
        okAction.enabled = NO;
    }
    
    //Add actions
   [alertController addAction:cancelAction];
   [alertController addAction:okAction];
    
    //Present UIAlertController
   [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)alertTextFieldDidChange_TEMP:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *temperature = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        
       //Check input number
        StringProcess *stringProcess = [[StringProcess alloc] init];
        okAction.enabled = [stringProcess textFieldDecimalNumberJudge:temperature decimalNumbers:2 maxInput:50.0 minInput:10.0];

    }
}


/** set the laser current */
- (IBAction)setCurrent:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    
    //Initalize UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Set Current" message:@"Range: 0-180mA" preferredStyle:UIAlertControllerStyleAlert];
    
    //Create text for current input
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textColor = [UIColor blueColor];
        textField.text = [NSString stringWithFormat:@"%.2f",receivedWifiData.BiasCurrent];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange_CURRENT:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    
    //Create actions
       UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *current = alertController.textFields.firstObject;
        NSString *setString;
        setString =[ NSString stringWithFormat:@"%-8.2f",[current.text floatValue]];
      for(int i=0;i<10;i++)
      {
       [[UdpSocket sharedUdpSocket] sendMessage:[NSString stringWithFormat:@"XYLI:%@ZC",setString]];
      }
      AudioServicesPlaySystemSound(1103);  //Tink.caf
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    if(receivedWifiData.BiasCurrent<=180&&receivedWifiData.BiasCurrent>=0)
    {
        okAction.enabled = YES;
    }
    else
    {
        okAction.enabled = NO;
    }
    
    //Add actions
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    //Present UIAlertController
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)alertTextFieldDidChange_CURRENT:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *current = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        
       //Check input number
        StringProcess *stringProcess = [[StringProcess alloc] init];
        okAction.enabled = [stringProcess textFieldDecimalNumberJudge:current decimalNumbers:2 maxInput:180.0 minInput:0.0];
        
    }
}
- (IBAction)setScanCurrent:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    
    //Initalize UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Set Scan Current" message:@"Range: 0-40mA" preferredStyle:UIAlertControllerStyleAlert];
    
    //Create text for scan current input
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textColor = [UIColor blueColor];
        textField.text = [NSString stringWithFormat:@"%.0f",receivedWifiData.ModulateCurrent];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange_SCANCURRENT:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    
    //Create actions
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    UITextField *current = alertController.textFields.firstObject;
    NSString *setString;
    setString =[ NSString stringWithFormat:@"%-8.0f",[current.text floatValue]];
    for(int i=0;i<10;i++)
    {
     [[UdpSocket sharedUdpSocket] sendMessage:[NSString stringWithFormat:@"XYSI:%@ZC",setString]];
    }
    AudioServicesPlaySystemSound(1103);  //Tink.caf
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    
    if(receivedWifiData.ModulateCurrent<=40&&receivedWifiData.ModulateCurrent>=0)
    {
      okAction.enabled = YES;
    }
    else
    {
      okAction.enabled = NO;
    }
   
    //Add actions
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    //Present UIAlertController
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)alertTextFieldDidChange_SCANCURRENT:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *current = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        
        //Check input number
        StringProcess *stringProcess = [[StringProcess alloc] init];
        okAction.enabled = [stringProcess textFieldDecimalNumberJudge:current decimalNumbers:0 maxInput:40.0 minInput:0.0];
        
    }
}
- (IBAction)saveSetToFlash:(id)sender
{
    [self closePopupView];
    [[DemoBaseViewController sharedDemoBaseViewController] removeTableView];
    _screenButton.enabled = NO;
    for(int i=0;i<5;i++)
    {
     [[UdpSocket sharedUdpSocket] sendMessage:@"XYFLASHZC"];
    }
    AudioServicesPlaySystemSound(1117);  //begin_video_record.caf
    [NSThread sleepForTimeInterval:0.5];
    _screenButton.enabled = YES;
}

@end
