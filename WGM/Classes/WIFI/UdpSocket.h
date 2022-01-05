//
//  UdpSocket.h
//  microcavity
//
//  Created by Xiangyi Xu on 11/21/16.
//  Copyright © 2016 Xiangyi Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"
#import "Singleton.h"

@interface UdpSocket : NSObject <GCDAsyncUdpSocketDelegate>

{
  GCDAsyncUdpSocket *udpSocket;
   
    
}

@property (nonatomic, copy)NSString * clientIP;
@property (nonatomic, assign)uint16_t clientPort;

/** Timer */
@property (nonatomic, strong) NSTimer *timer;

/* WIFIDataStructure. */

typedef struct
{
  int LDStatus;
  int TECStatus;
  double   Temperature;    //Set Temperature
  double   BiasCurrent;    //Set LD Current
  double   ModulateCurrent;//set LD Modulate Current
  double   backupParameter;
  double   VS;             //Real Power Voltage
  double   VMCU;           //Real MCU Voltage
  double   I;              //Real LD Current
  double   T;              //Real LD Temperature
  double   VLD;            //Real LD Voltage
  double   spectrumData[333];
    
}WIFIDATA;


SingletonH(UdpSocket)

- (void)initSocket;
- (void)udpConnect;
- (void)udpDisconnect;
- (void)sendMessage:(NSString *)message;

@end
