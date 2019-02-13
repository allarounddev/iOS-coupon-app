//
//  Annotation.m
//  raaly
//
//  Created by João Matos on 2/15/15.
//  Copyright (c) 2015 João Matos. All rights reserved.
//

#import "Annotation.h"
#import "TAbInfoClassViewController.h"
@interface Annotation ()
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *test;

@end

@implementation Annotation


-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle  {
    if ((self = [super init])) {
        self.coordinate = coordinate;
        self.title = title;
        self.subtitle = subtitle;
    }
    return self;
}

@end
