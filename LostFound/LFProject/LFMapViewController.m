//
//  LFMapViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 02/03/2015.
//
//

#import <Parse/Parse.h>
#import "LFMapViewController.h"

@interface LFMapViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@end

@implementation LFMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.locationManager requestWhenInUseAuthorization];
    
    // Start location updates
    [self.locationManager startUpdatingLocation];
    
    // Cache any current location info
    CLLocation *currentLocation = self.locationManager.location;
    
    if(currentLocation) {
        self.currentLocation = currentLocation;
    }

    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude), MKCoordinateSpanMake(10, 10));
    //region.center = self.mapView.userLocation.coordinate;
    //region.span = MKCoordinateSpanMake(0.1, 0.1);
    
    //region = [mapView regionThatFits:region];
    //[mapView setRegion:region animated:YES];

    //ctrpoint = MKCoordinateRegionMake(CLLocationCoordinate2DMake(CLLocationDegrees(currentLocation)), MKCoordinateSpan span);
    //CLLocationCoordinate2DMake(<#CLLocationDegrees latitude#>, <#CLLocationDegrees longitude#>)
    
    _mapView.showsUserLocation = YES;
    //ctrpoint.latitude = 53.58448;
    //ctrpoint.longitude =-8.93772;
    CLLocationCoordinate2D ctrpoint = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:ctrpoint];
    [annotation setTitle:@"Title"]; //You can set the subtitle too
    [self.mapView addAnnotation:annotation];
    
    [self startStandardUpdates];
}

/*- (IBAction)zoomIn:(id)sender {
    MKUserLocation *userLocation = _mapView.userLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (
                                        userLocation.location.coordinate, 20000, 20000);
    [_mapView setRegion:region animated:NO];
}
 */

- (IBAction)changeMapType:(id)sender {
    if (_mapView.mapType == MKMapTypeStandard)
        _mapView.mapType = MKMapTypeSatellite;
    else
        _mapView.mapType = MKMapTypeStandard;
}

- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    }
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    switch (status) {
        case kCLAuthorizationStatusAuthorized:
        {
            NSLog(@"kCLAuthorizationStatusAuthorized");
            
            // Re-enable the post button if it was disabled before.
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [self.locationManager startUpdatingLocation];
        }
            break;
        case kCLAuthorizationStatusDenied:
        {
            NSLog(@"kCLAuthorizationStatusDenied");
            
            //Alert user to allow location services
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Lost & Found can’t access your current location.\n\nTo view nearby posts or create a post at your current location, turn on access for Lost & Found to your location in the Settings under Location Services." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            
            // Disable the post button.
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
            break;
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"kCLAuthorizationStatusNotDetermined");
        }
            break;
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"kCLAuthorizationStatusRestricted");
        }
            break;
        default:break;
    }
}

- (void)startStandardUpdates {
    [self.locationManager startUpdatingLocation];
    
    CLLocation *currentLocation = self.locationManager.location;
    if (currentLocation) {
        self.currentLocation = currentLocation;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
