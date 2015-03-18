//
//  LFLocationViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 14/03/2015.
//
//

#import "LFLocationViewController.h"
#import "LFCreateListingViewController.h"
#import <Parse/Parse.h>


@interface LFLocationViewController ()

@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) PFGeoPoint *loc;

@end

@implementation LFLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* Open the map on location */
    CLLocationCoordinate2D location = self.locationView.userLocation.coordinate;
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    if(TARGET_IPHONE_SIMULATOR) {
        location.latitude  =  51.5072;
        location.longitude = 0.1275;
        self.locationView.userLocation.coordinate = location;
    } else {
        location.latitude  =  self.locationView.userLocation.location.coordinate.latitude;
        location.longitude =  self.locationView.userLocation.location.coordinate.longitude;
    }
    
    span.latitudeDelta = 0.001;
    span.longitudeDelta = 0.002;
    
    region.span = span;
    region.center = location;
    
    [self.locationView setRegion:region animated:YES];
    [self.locationView regionThatFits:region];
    [self.locationView setZoomEnabled:YES];
    [self.locationView setScrollEnabled:YES];
    [self addGestureRecogniserToMapView];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView *pinView = nil;
    pinView.pinColor = MKPinAnnotationColorRed;
    pinView.canShowCallout = NO;
    pinView.animatesDrop = YES;
    return pinView;
}

- (void)addGestureRecogniserToMapView{
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(addPinToMap:)];
    lpgr.minimumPressDuration = 0.5;
    [self.locationView addGestureRecognizer:lpgr];
    NSLog(@"Gesture should be working");
    
}

- (void)addPinToMap:(UIGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    if (self.locationView.annotations.count > 1){
        NSLog(@"Should delete");
        [self.locationView removeAnnotations:self.locationView.annotations];
    }
    CGPoint touchPoint = [gestureRecognizer locationInView:self.locationView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.locationView convertPoint:touchPoint toCoordinateFromView:self.locationView];
    
    self.listingLoc = [[MKPointAnnotation alloc]init];
    
    self.listingLoc.coordinate = touchMapCoordinate;
    
    [self.locationView addAnnotation:self.listingLoc];
    
    NSLog(@"%f %f", self.listingLoc.coordinate.latitude, self.listingLoc.coordinate.longitude);
    NSLog(@"%lu Annotations", (unsigned long)self.locationView.annotations.count);
    //[listingLoc release];
    self.loc = [PFGeoPoint geoPointWithLatitude:self.listingLoc.coordinate.latitude longitude:self.listingLoc.coordinate.longitude];
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)sendLocation:(id)sender {
    NSLog(@"send location %f %f", self.listingLoc.coordinate.latitude, self.listingLoc.coordinate.longitude);
    //self.loc.latitude = self.listingLoc.coordinate.latitude;
    //self.loc.longitude = self.listingLoc.coordinate.longitude;
    NSLog(@"%f %f",self.loc.latitude, self.loc.longitude);
    [self performSegueWithIdentifier:@"sendLocation" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[LFCreateListingViewController class]]) {
        LFCreateListingViewController *mainViewConroller = segue.destinationViewController;
            mainViewConroller.loc = self.loc;
        
        NSLog(@"%f %f",self.loc.latitude, self.loc.longitude);
        NSLog(@"%f %f",mainViewConroller.loc.latitude, mainViewConroller.loc.longitude);
    }
    
}

@end
