//
//  MeasurementCell.m
//  microcavity
//
//  Created by Xiangyi Xu on 8/10/16.
//  Copyright © 2016 Xiangyi Xu. All rights reserved.
//

#import "MeasurementCell.h"
#import "MeasurementTag.h"

@implementation MeasurementCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setMeasurementTag:(MeasurementTag *)measurementTag
{
    _measurementTag = measurementTag;
    self.measurementTitle.text = measurementTag.measurement_title;
    self.measurementValue.text = measurementTag.measurement_result;

}



@end
