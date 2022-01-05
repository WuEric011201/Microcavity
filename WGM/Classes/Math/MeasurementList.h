//
//  MeasurementList.h
//  microcavity
//
//  Created by Xiangyi Xu on 8/28/16.
//  Copyright © 2016 Xiangyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MeasurementList : UIViewController

-(BOOL)isExitMeasureItem:(NSString*)title;
- (NSInteger)measureItemIndex:(NSString*)title;

@end
