#import <version.h>
#import "Header.h"

// Tweak's bundle for AutoplayPlus Localizations support - @arichorn
NSBundle *AutoplayPlusBundle() {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
 	dispatch_once(&onceToken, ^{
        NSString *tweakBundlePath = [[NSBundle mainBundle] pathForResource:@"AutoplayPlus" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:tweakBundlePath];
    });
    return bundle;
}
NSBundle *tweakBundle = AutoplayPlusBundle();

//
BOOL disableAutoplay() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"disableAutoplay"];

BOOL hideAutoplaySwitch() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"hideAutoplaySwitch_enabled"];

// Hide Autoplay switch
%hook YTMainAppControlsOverlayView
- (void)setAutoplaySwitchButtonRenderer:(id)arg1 { // hide Autoplay
    if (hideAutoplaySwitch()) {}
    else { return %orig; }
}
%end

// Disable Autoplay Switch doesn't work at the moment so don't bother trying until I find methods for it.