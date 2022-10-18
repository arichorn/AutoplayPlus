#import "Tweaks/YouTubeHeader/YTSettingsViewController.h"
#import "Tweaks/YouTubeHeader/YTSettingsSectionItem.h"
#import "Tweaks/YouTubeHeader/YTSettingsSectionItemManager.h"
#import "Header.h"

@interface YTSettingsSectionItemManager (YouPiP)
- (void)updateAutoplayPlusSectionWithEntry:(id)entry;
@end

static const NSInteger AutoplayPlusSection = 600;

extern NSBundle *AutoplayPlusBundle();
extern BOOL disableAutoplay();
extern BOOL hideAutoplaySwitch();

// Settings (AutoplayPlusSection)
%hook YTAppSettingsPresentationData
+ (NSArray *)settingsCategoryOrder {
    NSArray *order = %orig;
    NSMutableArray *mutableOrder = [order mutableCopy];
    NSUInteger insertIndex = [order indexOfObject:@(1)];
    if (insertIndex != NSNotFound)
        [mutableOrder insertObject:@(AutoplayPlusSection) atIndex:insertIndex + 1];
    return mutableOrder;
}
%end

%hook YTSettingsSectionItemManager
%new 
- (void)updateAutoplayPlusSectionWithEntry:(id)entry {
    YTSettingsViewController *delegate = [self valueForKey:@"_dataDelegate"];
    NSBundle *tweakBundle = AutoplayPlusBundle();
    
    YTSettingsSectionItem *disableAutoplay = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"DISABLE_AUTOPLAY") titleDescription:LOC(@"DISABLE_AUTOPLAY_DESC")];
    disableAutoplay.hasSwitch = YES;
    disableAutoplay.switchVisible = YES;
    disableAutoplay.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"disableAutoplay_enabled"];
    disableAutoplay.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"disableAutoplay_enabled"];
        return YES;
    };
	
	YTSettingsSectionItem *hideAutoplaySwitch = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"HIDE_AUTOPLAY_SWITCH") titleDescription:LOC(@"HIDE_AUTOPLAY_SWITCH_DESC")];
    hideAutoplaySwitch.hasSwitch = YES;
    hideAutoplaySwitch.switchVisible = YES;
    hideAutoplaySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hideAutoplaySwitch_enabled"];
    hideAutoplaySwitch.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"hideAutoplaySwitch_enabled"];
        return YES;
    };

    NSMutableArray <YTSettingsSectionItem *> *sectionItems = [NSMutableArray arrayWithArray:@[disableAutoplay, hideAutoplaySwitch]];
    [delegate setSectionItems:sectionItems forCategory:AutoplayPlusSection title:@"AutoplayPlus" titleDescription:nil headerHidden:NO];
}

- (void)updateSectionForCategory:(NSUInteger)category withEntry:(id)entry {
    if (category == AutoplayPlusSection) {
        [self updateAutoplayPlusSectionWithEntry:entry];
        return;
    }
    %orig;
}
%end