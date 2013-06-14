// Overload this file in your own device-specific config if you need
// non-standard property_perms and/or control_perms structs
//
// To avoid conflicts...
// if you redefine property_perms, #define PROPERTY_PERMS there
// if you redefine control_perms, #define CONTROL_PARMS there
//
// A typical file will look like:
//
/*

#define CONTROL_PERMS

struct {
    const char *service;
    unsigned int uid;
    unsigned int gid;
} control_perms[] = {
    // The default perms
    { "dumpstate",AID_SHELL, AID_LOG },
    { "ril-daemon",AID_RADIO, AID_RADIO },
    // My magic device perms
    { "rawip_vsnet1",AID_RADIO, AID_RADIO },
    { "rawip_vsnet2",AID_RADIO, AID_RADIO },
    { "rawip_vsnet3",AID_RADIO, AID_RADIO },
    { "rawip_vsnet4",AID_RADIO, AID_RADIO },
     {NULL, 0, 0 }
};
*/

// Alternatively you can append to the existing property_perms and/or
// control_perms structs with the following:
/*
#define CONTROL_PERMS_APPEND \
    { "rawip_vsnet1",AID_RADIO, AID_RADIO }, \
    { "rawip_vsnet2",AID_RADIO, AID_RADIO }, \
    { "rawip_vsnet3",AID_RADIO, AID_RADIO }, \
    { "rawip_vsnet4",AID_RADIO, AID_RADIO },
*/

#ifndef DEVICE_PERMS_H
#define DEVICE_PERMS_H

#define PROPERTY_PERMS_APPEND \
    { "contact.",                   AID_SYSTEM,         0 }, \
    { "wifi.",                      AID_SYSTEM,         0 }, \
    { "hw.fm.",                     AID_SYSTEM,         0 }, \
    { "bluetooth.",                 AID_BLUETOOTH,      0 }, \
    { "pantech.vt.ims.",            AID_SYSTEM,         0 }, \
    { "camera.",                    AID_MEDIA,          0 }, \
    { "media.",                     AID_MEDIA,          0 }, \
    { "telephony.",                 AID_RADIO,          0 }, \
    { "telephony.icc.imsi.",        AID_RADIO,          0 }, \
    { "hdmi.",                      AID_MEDIA,          0 }, \
    { "service.brcm.bt.",           AID_BLUETOOTH,      0 }, \
    { "persist.service.brcm.bt.",   AID_BLUETOOTH,      0 }, \
    

#define CONTROL_PERMS_APPEND \
    { "fm_dl",              AID_RADIO,      AID_RADIO },	\
    { "/proc/cpuinfo",      AID_ROOT,       AID_ROOT },	

#endif /* DEVICE_PERMS_H */
