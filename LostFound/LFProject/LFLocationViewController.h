//
//  LFLocationViewController.h
//  LostFound
//
//  Created by Adam O'Flynn on 14/03/2015.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>

@interface LFLocationViewController : UIViewController
    <MKMapViewDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *locationView;
@property (nonatomic, strong) MKPointAnnotation *listingLoc;
@property (nonatomic, strong) PFGeoPoint *loc;

@end
