//
//  Annotation.h
//  raaly
//
//  Created by João Matos on 2/15/15.
//  Copyright (c) 2015 João Matos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle;
@end

