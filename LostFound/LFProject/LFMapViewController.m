//
//  LFMapViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 02/03/2015.
//
//

#import <Parse/Parse.h>
#import "LFMapViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface LFMapViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@end

@implementation LFMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
    //    [self.locationManager requestWhenInUseAuthorization];
    //}
    
    //[self.locationManager requestWhenInUseAuthorization];
    //[self.locationManager requestWhenInUseAuthorization];
    
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    
    //if(authorizationStatus == kCLAuthorizationStatusAuthorized ||
       // authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
       //// authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"Here");
        
        //[self.locationManager startUpdatingLocation];
        //_MapName.showsUserLocation = YES;
    
    
    // Start location updates
    [self.locationManager startUpdatingLocation];
    
    // Cache any current location info
    CLLocation *currentLocation = self.locationManager.location;
    
    if(currentLocation) {
        self.currentLocation = currentLocation;
    }

    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude), MKCoordinateSpanMake(10, 10));
    
    //_mapView.showsUserLocation = YES;
    
    NSLog(@"latitude %+.6f, longitude %+.6f\n", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    [self startStandardUpdates];
    //}
}

- (void)viewWillAppear:(BOOL)animated {
    /*CLLocationCoordinate2D initialLocation;
    initialLocation.latitude = _currentLocation.coordinate.latitude;
    initialLocation.longitude= _currentLocation.coordinate.longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(initialLocation, 1000, 1000);
    */

    [_mapView setRegion:_mapView.region animated:NO];
}

- (void)startStandardUpdates {
    [self.locationManager startUpdatingLocation];
    
    CLLocation *currentLocation = self.locationManager.location;
    if (currentLocation) {
        self.currentLocation = currentLocation;
        NSLog(@"latitude %+.6f, longitude %+.6f\n", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    }
}

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
    NSLog(@"latitude %+.6f, longitude %+.6f\n", _currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    switch (status) {
        case kCLAuthorizationStatusAuthorized:
        {
            NSLog(@"kCLAuthorizationStatusAuthorized, YEEEEERRRRRRRRRRRR");
            
            // Re-enable the post button if it was disabled before.
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [self.locationManager startUpdatingLocation];
        }
            break;
        case kCLAuthorizationStatusDenied:
        {
            NSLog(@"kCLAuthorizationStatusDenied");
            
            //Alert user to allow location services
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Lost & Found can’t access your current location.\n\nTo view nearby listing or create a listing at your current location, turn on access for Lost & Found to your location in the Settings under Location Services." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
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
