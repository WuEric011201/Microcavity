//
//  GlobalVars.h
//  microcavity
//
//  Created by Xiangyi Xu on 9/4/16.
//  Copyright © 2016 Xiangyi Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalVars : NSObject
{
    NSMutableArray *_measureDictionary;
}

+ (GlobalVars *)sharedInstance;

@property(strong, nonatomic, readwrite) NSMutableArray *measureDictionary;

- (void)calculateSpectrumDataAfterCalibration;

@end
