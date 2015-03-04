//
//  LFMapViewController.h
//  LostFound
//
//  Created by Adam O'Flynn on 02/03/2015.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LFMapViewController : UIViewController
                <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

//- (IBAction)zoomIn:(id)sender;
- (IBAction)changeMapType:(id)sender;

@end
