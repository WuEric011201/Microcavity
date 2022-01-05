//
//  UdpSocket.m
//  microcavity
//
//  Created by Xiangyi Xu on 11/21/16.
//  Copyright © 2016 Xiangyi Xu. All rights reserved.
//

#import "UdpSocket.h"
#import "GCDAsyncUdpSocket.h"
#import "Singleton.h"
#import "ViewController.h"
#import "LineChartViewController.h"
#import "SystemParametersMonitor.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation UdpSocket

/** Singleton Mode */
SingletonM(UdpSocket)

WIFIDATA receivedWifiData;

/** Is UDP Connected */
bool isUDPConnected = false;

/** Is use simulate data */
extern bool isSimulateData;


/** Init a UDP Socket*/
- (void)initSocket
{
    udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    receivedWifiData.LDStatus = 1;
    receivedWifiData.TECStatus = 1;
}

/** UDP Connect*/
- (void)udpConnect
{  
    [udpSocket close];
    
    NSError *error = nil;
    
    if (![udpSocket bindToPort:8086 error:&error])
    {
        NSLog(@"Error starting server (bind): %@", error);
        return;
    }

    if (![udpSocket beginReceiving:&error])
        
    {
        [udpSocket close];
        
        NSLog(@"Error starting server (recv): %@", error);
        return;
    }
    else
    {
        [self startTimer:0.5];
        isUDPConnected = true;
    }
    
    AudioServicesPlaySystemSound(1113);  //begin_record.caf

}

/** UDP Disconnect*/
- (void)udpDisconnect
{
    [udpSocket close];
    isUDPConnected = false;
    [self stopTimer];
    [self loseUDPConnectionOperation];
    [[ViewController sharedViewController] setLaserOperationButton:false];
    [[SystemParametersMonitor sharedSystemParametersMonitor] updateSystemParametersMonitor];
    AudioServicesPlaySystemSound(1114);  //end_record.caf
}

/** Start a timer to update the chart data continuously */
- (void)startTimer:(NSTimeInterval)ti
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(udpReceiveTimeout) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/** Send UDP Data */
- (void)sendMessage:(NSString *)message
{
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:self.clientIP port:self.clientPort withTimeout:-1 tag:0];
}



/** Stop a timer to stop updating the chart data continuously */
- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

/** UDP Receiving time is out*/
- (void)udpReceiveTimeout
{
//   NSLog(@"udpReceiveTimeout");
    
  [[ViewController sharedViewController] setLaserOperationButton:false];
    
  isUDPConnected = false;
  if(!isSimulateData)
    {
        [[LineChartViewController sharedLineChartViewController] clearChart];
    }
  [[ViewController sharedViewController] updateButtonStatusUDPDisconnect];
  
  [self udpDisconnect];
    
  AudioServicesPlaySystemSound(1114);  //end_record.caf

}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    [self stopTimer];
    isUDPConnected = true;
    NSString * ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    
    self.clientIP = ip;
    self.clientPort = port;

    
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (msg)
    {
        [self convertWifiStringToWIFIDATA:msg];
        [[SystemParametersMonitor sharedSystemParametersMonitor] updateSystemParametersMonitor];
        [[ViewController sharedViewController] setLaserOperationButton:true];
        [[ViewController sharedViewController] updateButtonStatusUDPConnect];
        
//        NSLog(@"LDStatus:%d",receivedWifiData.LDStatus);
//        NSLog(@"TECStatus:%d",receivedWifiData.TECStatus);
//        NSLog(@"Temperature:%e",receivedWifiData.Temperature);
//        NSLog(@"BiasCurrent:%e",receivedWifiData.BiasCurrent);
//        NSLog(@"ModulateCurrent:%e",receivedWifiData.ModulateCurrent);
        
//        NSLog(@"VS:%e",receivedWifiData.VS);
//        NSLog(@"VMCU:%e",receivedWifiData.VMCU);
//        NSLog(@"I:%e",receivedWifiData.I);
//        NSLog(@"T:%e",receivedWifiData.T);
//        NSLog(@"VLD:%e",receivedWifiData.VLD);
//        NSLog(@"spectrumData[0]:%e",receivedWifiData.spectrumData[0]);
//        NSLog(@"spectrumData[332]:%e",receivedWifiData.spectrumData[332]);
    }
    else
    {
        NSLog(@"Error converting received data into UTF-8 String");
    }

    
    [self startTimer:3];
    
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
//    NSLog(@"UDP disconnect");
    [self loseUDPConnectionOperation];
   
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
//    NSLog(@"send fail");

}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
//    NSLog(@"send success");

}

/** If losing UDP connection, update the UIButton and clear chart*/
-(void)loseUDPConnectionOperation
{
//    NSLog(@"UDP LOSES Connection");
    
    isUDPConnected = false;
    if(!isSimulateData)
    {
        [[LineChartViewController sharedLineChartViewController] clearChart];
    }
    [[ViewController sharedViewController] updateButtonStatusUDPDisconnect];
    
    
}

/** allocate received string to WIFIDATA structure*/
- (void)convertWifiStringToWIFIDATA:(NSString *)dataString
{
    receivedWifiData.LDStatus    = [[dataString substringWithRange:NSMakeRange(0, 1)] intValue];
    receivedWifiData.TECStatus   = [[dataString substringWithRange:NSMakeRange(1, 1)] intValue];
    receivedWifiData.Temperature = [[dataString substringWithRange:NSMakeRange(2, 8)] doubleValue];
    receivedWifiData.BiasCurrent = [[dataString substringWithRange:NSMakeRange(10, 8)] doubleValue];
    receivedWifiData.ModulateCurrent = [[dataString substringWithRange:NSMakeRange(18, 8)] doubleValue];
    receivedWifiData.VS = [[dataString substringWithRange:NSMakeRange(34, 8)] doubleValue];
    receivedWifiData.VMCU = [[dataString substringWithRange:NSMakeRange(42, 8)] doubleValue];
    receivedWifiData.I = [[dataString substringWithRange:NSMakeRange(50, 8)] doubleValue];
    receivedWifiData.T = [[dataString substringWithRange:NSMakeRange(58, 8)] doubleValue];
    receivedWifiData.VLD = [[dataString substringWithRange:NSMakeRange(66, 8)] doubleValue];
    
    for(int i=0; i<333; i++)
    {
        unsigned int temp=0;
        [[NSScanner scannerWithString:[dataString substringWithRange:NSMakeRange(74+4*i, 4)]] scanHexInt:&temp];
        receivedWifiData.spectrumData[i]= temp;
    }
}

@end
