//
//  SystemParametersMonitor.m
//  microcavity
//
//  Created by Xiangyi Xu on 8/2/16.
//  Copyright © 2016 Xiangyi Xu. All rights reserved.
//

#import "SystemParametersMonitor.h"
#import "UdpSocket.h"

@interface SystemParametersMonitor()

@property (weak, nonatomic) IBOutlet UILabel *wifiStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *ldStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *setCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *realCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *setTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *realTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *vBatteryLabel;
@property (weak, nonatomic) IBOutlet UILabel *vMCULabel;
@property (weak, nonatomic) IBOutlet UILabel *vLDLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *tecStatusLabel;


@end

@implementation SystemParametersMonitor

extern WIFIDATA receivedWifiData;

/** Is UDP Connected */
extern bool isUDPConnected;

/** Singleton Mode */
SingletonM(SystemParametersMonitor)

- (void)viewDidLoad
{
    [super viewDidLoad];
}

/** update system parameters monitor value */
-(void)updateSystemParametersMonitor
{
  if(isUDPConnected)
   {
     _wifiStatusLabel.text = @"Connect";
     _wifiStatusLabel.textColor = [UIColor greenColor];
   }
  else
    {
      _wifiStatusLabel.text = @"NoConnect";
      _wifiStatusLabel.textColor = [UIColor redColor];
    }
    
  if(receivedWifiData.LDStatus)
    {
      _ldStatusLabel.text = @"OFF";
      _ldStatusLabel.textColor = [UIColor redColor];
    }
  else
    {
        _ldStatusLabel.text = @"ON";
        _ldStatusLabel.textColor = [UIColor greenColor];
    }
    
  if(receivedWifiData.TECStatus)
    {
        _tecStatusLabel.text = @"OFF";
        _tecStatusLabel.textColor = [UIColor redColor];
    }
  else
    {
        _tecStatusLabel.text = @"ON";
        _tecStatusLabel.textColor = [UIColor greenColor];
    }
    
    _setCurrentLabel.text = [ NSString stringWithFormat:@"%-.2fmA",receivedWifiData.BiasCurrent];
    _realCurrentLabel.text =[ NSString stringWithFormat:@"%-.2fmA",receivedWifiData.I];
    _setTemperatureLabel.text =[ NSString stringWithFormat:@"%-.2f",receivedWifiData.Temperature];
    _realTemperatureLabel.text =[ NSString stringWithFormat:@"%-.2f",receivedWifiData.T];
    _vBatteryLabel.text =[ NSString stringWithFormat:@"%-.2fV",receivedWifiData.VS];
    _vMCULabel.text=[ NSString stringWithFormat:@"%-.2fV",receivedWifiData.VMCU];
    _vLDLabel.text=[ NSString stringWithFormat:@"%-.2fV",receivedWifiData.VLD];
    _scanCurrentLabel.text =[ NSString stringWithFormat:@"%-.2fmA",receivedWifiData.ModulateCurrent];

}

@end
