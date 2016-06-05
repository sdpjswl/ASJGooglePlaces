# ASJGooglePlaces

This library is a collection of classes that act as a wrapper around a few features of the Google Places API and the Directions API. To use Google's Places API in your project, you need to have an API key from the [API console](https://code.google.com/apis/console). You can however use the Directions API without a key. In the example project, it has been used to display a polyline between two places. Note that you will need an API key to run the example project.

To set up, `#import "ASJConstants.h"` in AppDelegate.m and add this in your `didFinishLaunchingWithOptions:` method:
```
[[ASJConstants sharedInstance] setApiKey:@"your API key"];
```

### ASJPlaceID

```
- (void)asjPlaceIDForPlaceNamed:(NSString *)place
                    completion:(void (^)(ASJResponseStatusCode statusCode, NSString *placeID))completion;
```
Provide a name of a place and get the corresponding place ID in the completion. Returns `nil` if none was found.

### ASJPlaceDetails

```
- (void)asjPlaceDetailsForPlaceNamed:(NSString *)place
					  completion:(void (^)(ASJResponseStatusCode statusCode, ASJDetails *placeDetails))completion;
```
```
- (void)asjPlaceDetailsForPlaceID:(NSString *)placeID
					completion:(void (^)(ASJResponseStatusCode statusCode, ASJDetails *placeDetails))completion;
```
Provide a name of a place and get the corresponding place details in a `ASJDetails` object in the completion. Will return `nil` if no details are available. You can also request place details using the place ID.

For both methods, the following information can be fetched depending on their availability:
- Place ID
- Place name
- Address
- Phone
- Website
- Coordinates
- Photos

### ASJPlacePhotos

```
- (void)asjPlacePhotosForPlaceNamed:(NSString *)place
					  completion:(void (^)(ASJResponseStatusCode statusCode, NSArray *placePhotos))completion;
```
This method returns an array of `ASJPhoto`s for a provided place name. It will return `nil` if there are no available photos for the place.

### ASJAutocomplete

```
- (void)asjAutocompleteForInput:(NSString *)input
					completion:(void (^)(ASJResponseStatusCode statusCode, NSArray *places))completion;
```
For a provided input, this method returns an array of `ASJPlace`s that match the input. Google will by default provide five places at a time.

To control the minimum length of the input before the autocomplete query should run, use this property:
```
@property (nonatomic) NSUInteger minimumInputLength;
```


### ASJDirections

```
- (void)asjDirectionsPolylineFromOriginNamed:(NSString *)origin
						   destinationNamed:(NSString *)destination
							completion:(void (^)(ASJResponseStatusCode statusCode, ASJOriginDestination *directionDetails))completion;
```
```
- (void)asjDirectionsPolylineFromOrigin:(CLLocationCoordinate2D)origin
				   destination:(CLLocationCoordinate2D)destination
					completion:(void (^)(ASJResponseStatusCode statusCode, ASJOriginDestination *directionDetails))completion;
```
These methods get the directions polyline between two places; an 'origin' and a 'destination'. They can be provided either as `NSString`s or by their coordinates. Both methods will return an `ASJOriginDestination` object that contains the following information:
- Name of 'origin'
- Name of 'destination'
- Coordinates of 'origin'
- Coordinates of 'destination'
- Polyline between the two places

The polyline can be used to draw a `GMSPolyline` between the two places on a `GMSMapView`. You will need to use the Google Maps SDK for this and will need a key from the [Google API console](https://code.google.com/apis/console).

### To-do

- Add documentation to methods

# Credits

- To Deepti Walde for adding code to get all available directions

# License

ASJGooglePlaces is available under the MIT license. See the LICENSE file for more info.
