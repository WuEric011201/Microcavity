//
//  MeasurementTag.h
//  microcavity
//
//  Created by Xiangyi Xu on 8/8/16.
//  Copyright © 2016 Xiangyi Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeasurementTag : NSObject

/** Measurement Title */
@property (nonatomic, copy) NSString *measurement_title;
/** Measurement Result */
@property (nonatomic, copy) NSString *measurement_result;


@end
