//
//  SystemParametersMonitor.h
//  microcavity
//
//  Created by Xiangyi Xu on 8/2/16.
//  Copyright © 2016 Xiangyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface SystemParametersMonitor : UIViewController

/** Singleton Mode */
SingletonH(SystemParametersMonitor)


-(void)updateSystemParametersMonitor;

@end
