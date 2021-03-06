//
//  findDeviceType.m
//  iBDPV
// JMD & DTR


//  Trouvé ici : https://github.com/ars/uidevice-extension

/* Thanks to Emanuele Vulcano, Kevin Ballard/Eridius, Ryandjohnson */
#import "findDeviceType.h"
#include <sys/types.h>
#include <sys/sysctl.h>




@implementation UIDevice (Hardware)

/*
 Platforms
 iPhone1,1 -> iPhone 1G
 iPhone1,2 -> iPhone 3G 
 iPod1,1   -> iPod touch 1G 
 iPod2,1   -> iPod touch 2G 
 */

//-------------------------------------------------------------------------------------------------------------------------------
- (NSString *) platform
{
	size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithCString:machine encoding: NSUTF8StringEncoding];
	free(machine);
	return platform;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (int) platformType
{
	NSString *platform = [self platform];
	if ([platform isEqualToString:@"iPhone1,1"]) return UIDevice1GiPhone;
	if ([platform isEqualToString:@"iPhone1,2"]) return UIDevice3GiPhone;
	if ([platform isEqualToString:@"iPod1,1"])   return UIDevice1GiPod;
	if ([platform isEqualToString:@"iPod2,1"])   return UIDevice2GiPod;
	if ([platform hasPrefix:@"x86"]) return UIDeviceSimulatoriPhone;
	if ([platform hasPrefix:@"iPhone"]) return UIDeviceUnknowniPhone;
	if ([platform hasPrefix:@"iPod"]) return UIDeviceUnknowniPod;
	return UIDeviceUnknown;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (NSString *) platformString
{
	switch ([self platformType])
	{
		case UIDevice1GiPhone: return IPHONE_1G_NAMESTRING;
		case UIDevice3GiPhone: return IPHONE_3G_NAMESTRING;
		case UIDeviceSimulatoriPhone: return IPHONE_SIMULATOR_NAMESTRING;
		case UIDeviceUnknowniPhone: return IPHONE_UNKNOWN_NAMESTRING;
			
		case UIDevice1GiPod: return IPOD_1G_NAMESTRING;
		case UIDevice2GiPod: return IPOD_2G_NAMESTRING;
		case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;
			
		default: return nil;
	}
}

//-------------------------------------------------------------------------------------------------------------------------------
- (int) platformCapabilities
{
	switch ([self platformType])
	{
		case UIDevice1GiPhone: return UIDeviceBuiltInSpeaker | UIDeviceBuiltInCamera | UIDeviceBuiltInMicrophone | UIDeviceSupportsExternalMicrophone | UIDeviceSupportsTelephony | UIDeviceSupportsVibration;
		case UIDevice3GiPhone: return UIDeviceSupportsGPS | UIDeviceBuiltInSpeaker | UIDeviceBuiltInCamera | UIDeviceBuiltInMicrophone | UIDeviceSupportsExternalMicrophone | UIDeviceSupportsVibration;
		case UIDeviceSimulatoriPhone: return UIDeviceBuiltInSpeaker | UIDeviceBuiltInMicrophone | UIDeviceSupportsExternalMicrophone | UIDeviceSupportsTelephony | UIDeviceSupportsVibration;
		case UIDeviceUnknowniPhone: return UIDeviceBuiltInSpeaker | UIDeviceBuiltInCamera | UIDeviceBuiltInMicrophone | UIDeviceSupportsExternalMicrophone | UIDeviceSupportsTelephony | UIDeviceSupportsVibration;
			
		case UIDevice1GiPod: return 0;
		case UIDevice2GiPod: return UIDeviceBuiltInSpeaker | UIDeviceBuiltInMicrophone | UIDeviceSupportsExternalMicrophone;
		case UIDeviceUnknowniPod: return 0;
//TODO - Rajouter l'iPad et l'iPhone (récupérer le soucre officiel qui a du évoluer)			
		default: return 0;
	}
}

@end
