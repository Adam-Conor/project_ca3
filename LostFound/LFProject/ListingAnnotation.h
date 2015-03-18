//
//  ListingAnnotation.h
//  LostFound
//
//  Created by Adam O'Flynn on 18/03/2015.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ListingAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    NSString *objectID;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *objectID;

@end

