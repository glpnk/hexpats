#include <std/core.pat>
#include <std/io.pat>
#include <std/mem.pat>

/*------------------------------NOTE------------------------------*/
/*
    https://github.com/glpnk/hexpats

*/
/*-----------------------------TOGGLE-----------------------------*/

bool show_EC in;
bool show_SCM in;
bool show_ECS in;

bool SHOw_Software in;
bool SHow_Device in;
bool SHow_Power in;
bool ShOW_MasterBattery in;
bool ShOW_SlaveBattery in;
bool ShOw_CPU in;
bool ShOw_VGA in;
bool ShoW_System in;
bool Show_AP in;
bool Show_Event in;

/*-----------------------------HELPER-----------------------------*/

struct Offset <auto N> {
    $ = N;
} [[hidden]];

struct Toggle<Type, auto Name, auto Hidden>
{
    if (!Hidden){
        Type root [[hidden, name(Name)]];
    } else {
        Type root [[name(Name)]];
    }
} [[inline]];

/*---------------------------EC--STRUCT---------------------------*/

bitfield  x2C {
        HSTT    : 1;
        padding : 7;
} [[bitfield_order(std::core::BitfieldOrder::MostToLeastSignificant, 8), inline]];

bitfield  x2E {
        padding : 6;
        PXCT : 1;
} [[bitfield_order(std::core::BitfieldOrder::MostToLeastSignificant, 8), inline]];

bitfield  x30 {
        POWS : 1;
        LIDS : 1;
        KBCS : 1;
} [[bitfield_order(std::core::BitfieldOrder::MostToLeastSignificant, 8), inline]];

bitfield  x31 {
        MBTS : 1;
        MBCS : 1;
        MBDS : 1;
        MBFS : 1;
        MBWS : 1;
        MBLS : 1;
        MBCL : 1;
        MBFL : 1;
} [[bitfield_order(std::core::BitfieldOrder::MostToLeastSignificant, 8), inline]];

bitfield  x34 {
        padding : 4;
        OSVR    : 4;
} [[bitfield_order(std::core::BitfieldOrder::MostToLeastSignificant, 8), inline]];

bitfield  x7E {
        RES1 : 3;
        CHET : 1;
} [[bitfield_order(std::core::BitfieldOrder::MostToLeastSignificant, 8), inline]];

bitfield  xBE {
        EC6I : 1;
        EC6O : 1;
        FBST : 1;
        ESGI : 1;
        ESGO : 1;
        ESGN : 1;
} [[bitfield_order(std::core::BitfieldOrder::MostToLeastSignificant, 8), inline]];

bitfield  xBF {
        RECY : 1;
        RSUS : 1;
} [[bitfield_order(std::core::BitfieldOrder::MostToLeastSignificant, 8), inline]];

bitfield  xCF {
        ADP     : 1;
        padding : 1;
        CHG     : 1;
} [[bitfield_order(std::core::BitfieldOrder::MostToLeastSignificant, 8), inline]];

bitfield  xD5 {
        PSNM : 7;
} [[bitfield_order(std::core::BitfieldOrder::MostToLeastSignificant, 8), inline]];

bitfield  xE4 {
        padding : 1;
        TURB    : 1;
} [[bitfield_order(std::core::BitfieldOrder::MostToLeastSignificant, 8), inline]];


struct EC {
    u8 SMPR;
    u8 SMST;
    u8 SMAD;
    u8 SMCM;
    u8 SMD0[33]; // 264
    u8 SMAA;
    Offset <0x2C>;
    x2C;
    Offset <0x2D>;
    Offset <0x2E>;
    x2E;
    Offset <0x30>;
    x30;
    Offset <0x31>;
    x31;
    Offset <0x34>;
    x34;
    Offset <0x38>;
    u8 MDCL;
    u8 MDCH;
    u8 MDVL;
    u8 MDVH;
    u8 MCAL;
    u8 MCAH;
    u8 MSTL;
    u8 MSTH;
    u8 MCCL;
    u8 MCCH;
    u8 MPOL;
    u8 MPOH;
    u8 MFCL;
    u8 MFCH;
    u8 MCUL;
    u8 MCUH;
    u8 MRCL;
    u8 MRCH;
    u8 MVOL;
    u8 MVOH;
    u8 MTEL;
    u8 MTEH;
    u8 RSV1;
    u8 RSV2;
    u8 SDCL;
    u8 SDCH;
    u8 SDVL;
    u8 SDVH;
    u8 SCAL;
    u8 SCAH;
    u8 SSTL;
    u8 SSTH;
    u8 SCCL;
    u8 SCCH;
    u8 SPOL;
    u8 SPOH;
    u8 SFCL;
    u8 SFCH;
    u8 SCUL;
    u8 SCUH;
    u8 SRCL;
    u8 SRCH;
    u8 SVOL;
    u8 SVOH;
    u8 STEL;
    u8 STEH;
    Offset <0x68>;
    u8 CPUT;
    Offset <0x7E>;
    x7E;
    Offset <0x80>;
    u8 SYST;
    Offset <0xBC>;
    u8 OSC1;
    u8 OSC2;
    xBE;
    Offset <0xBF>;
    xBF;
    Offset <0xC0>;
    Offset <0xC5>;
    u8 OPTS;
    Offset <0xCF>;
    xCF;
    Offset <0xD0>;
    u8 PCMD;
    Offset <0xD5>;
    xD5;
    Offset <0xD6>;
    u8 GPST;
    Offset <0xDD>;
    u8 BCLR;
    Offset <0xE4>;
    xE4;
    Offset <0xE6>;
    u8 DBG;
    Offset <0xED>;
    u8 SCIC;
    Offset <0xF1>;
    u8 BRLV;
    Offset <0xFE>;
    u8 DCBL;
    u8 ACBL;

};

/*---------------------------SCM-STRUCT---------------------------*/

bitfield  T2D {
        T2D0 : 1;
        T2D1 : 4;
        T2D5 : 3;
} [[bitfield_order(std::core::BitfieldOrder::MostToLeastSignificant, 8), inline]];

bitfield  TE4 {
        TE40 : 3;
        TE43 : 5;
} [[bitfield_order(std::core::BitfieldOrder::MostToLeastSignificant, 8), inline]];


struct SCM {
    Offset <0x2B>;
    u8 TD2B;
    u8 TD2C;
    T2D T2D;
    u8 TD2E;
    u8 TD2F;
    u8 TD30;
    u8 TD31;
    u8 TD32;
    u8 TD33;
    Offset <0x35>;
    u8 TD35;
    u8 TD36;
    Offset <0x38>;
    u16 TD38;
    u16 TD3A;
    u16 TD3C;
    u16 TD3E;
    u16 TD40;
    u16 TD42;
    u16 TD44;
    u16 TD46;
    u16 TD48;
    u16 TD4A;
    u16 TD4C;
    u16 TD4E;
    u16 TD50;
    u16 TD52;
    u16 TD54;
    u16 TD56;
    u16 TD58;
    u16 TD5A;
    u16 TD5C;
    u16 TD5E;
    u16 TD60;
    u16 TD62;
    u16 TD64;
    u16 TD66;
    u8 TD68;
    u8 TD69;
    u8 TD6A;
    u8 TD6B;
    u8 TD6C;
    u8 TD6D;
    u8 TD6E;
    u8 TD6F;
    u8 TD70;
    u8 TD71;
    u8 TD72;
    u8 TD73;
    u8 TD74;
    u8 TD75;
    u8 TD76;
    u8 TD77;
    u8 TD78;
    u8 TD79;
    Offset <0x80>;
    u8 TD80;
    u8 TD81;
    u8 TD82;
    u8 TD83;
    u8 TD84;
    u8 TD85;
    u8 TD86;
    u8 TD87;
    u8 TD88;
    u8 TD89;
    u8 TD8A;
    u8 TD8B;
    u8 TD8C;
    u8 TD8D;
    u8 TD8E;
    u8 TD8F;
    u8 TD90;
    Offset <0xA0>;
    u8 TDA0;
    u8 TDA1;
    u8 TDA2;
    u8 TDA3;
    u8 TDA4;
    u8 TDA5;
    u8 TDA6;
    u8 TDA7;
    u8 TDA8;
    u8 TDA9;
    u8 TDAA;
    u8 TDAB;
    u8 TDAC;
    u8 TDAD;
    u8 TDAE;
    u8 TDAF;
    u8 TDB0;
    u8 TDB1;
    u8 TDB2;
    u8 TDB3;
    u8 TDB4;
    u8 TDB5;
    u8 TDB6;
    u8 TDB7;
    u8 TDB8;
    u8 TDB9;
    u8 TDBA;
    u8 TDBB;
    // 0xBC missing in dsdt/0-terminator?
    u8 TDBE;
    u8 TDBF;
    Offset <0xC8>;
    u8 TDC8;
    u8 TDC9;
    u8 TDCA;
    u8 TDCB;
    u8 TDCC;
    u8 TDCD;
    u8 TDCE;
    u8 TDCF;
    Offset <0xE0>;
    u8 TDE0;
    Offset <0xE3>;
    u8 TDE3;
    TE4 TE4;
    u8 TDE5;
    u8 TDE6;
    u8 TDE7;
    u8 TDE8;
    u8 TDE9;
    Offset <0xED>;
    u8 TDED;
    u8 TDEE;
    Offset <0xF0>;
    u8 TDF0;
    u8 TDF1;
    u8 TDF2;
    u8 TDF3;
    u8 TDF4;
    u8 TDF5;
    u8 TDF6;
    u8 TDF7;
    u8 TDF8;
    u8 TDF9;
    u8 TDFA;
    u8 TDFB;
    u8 TDFC;
    u8 TDFD;
    u8 TDFE;
    u8 TDFF;
};

/*---------------------------ECS-STRUCT---------------------------*/

bitfield  xF4 {
        SLFG    : 1;
        padding : 3; // or unnamed
        SLEN    : 1;
} [[bitfield_order(std::core::BitfieldOrder::MostToLeastSignificant, 8), inline]];

// 0xFC000800; SystemMemory scope
struct ECS {
    Offset <0xF2>;
    u8 SHLV;
    Offset <0xF4>;
    xF4 F4;
    Offset <0xF7>;
    u8 STPL;
    u8 SPPL;
    u8 FPPL;
};

/*-----------------------------TOGGLE-----------------------------*/

Toggle<EC, "EC", show_EC> EC @ 0x00;

Toggle<SCM, "SCM", show_SCM> SCM @ 0x00; // Same EC in SCM

Toggle<ECS, "ECS", show_ECS> ECS @ 0x00; // [Not] EC but has same offset like in WinIO request

/*------------------------------BITS------------------------------*/

bitfield  T2D0 {
        T2D0    : 1;
        padding : 7;
} [[bitfield_order(std::core::BitfieldOrder::MostToLeastSignificant, 8), inline]];

bitfield  T2D1 {
        padding : 1;
        T2D1    : 4;
        padding : 3;
} [[bitfield_order(std::core::BitfieldOrder::MostToLeastSignificant, 8), inline]];

bitfield  T2D5 {
        padding : 5;
        T2D5 : 3;
} [[bitfield_order(std::core::BitfieldOrder::MostToLeastSignificant, 8), inline]];

bitfield  TE40 {
        TE40    : 3;
        padding : 5;
} [[bitfield_order(std::core::BitfieldOrder::MostToLeastSignificant, 8), inline]];

bitfield  TE43 {
        padding : 3;
        TE43    : 5;
} [[bitfield_order(std::core::BitfieldOrder::MostToLeastSignificant, 8), inline]];


/*----------------------------SOFTWARE----------------------------*/

struct Software {
    T2D0 T2D0 @ $ + addressof(SCM.root.T2D.T2D0);
    T2D1 T2D1 @ $ + addressof(SCM.root.T2D.T2D1);
    u8 TDEE @ $ + addressof(SCM.root.TDEE);
    T2D5 T2D5 @ $ + addressof(SCM.root.T2D.T2D5);
    u8 TDE5 @ $ + addressof(SCM.root.TDE5);
    u8 TDE6 @ $ + addressof(SCM.root.TDE6);

    u8 TDA0 @ $ + addressof(SCM.root.TDA0);
    u8 TDA1 @ $ + addressof(SCM.root.TDA1);
    u8 TDA2 @ $ + addressof(SCM.root.TDA2);
    u8 TDA3 @ $ + addressof(SCM.root.TDA3);
    u8 TDA4 @ $ + addressof(SCM.root.TDA4);
    u8 TDA5 @ $ + addressof(SCM.root.TDA5);
    u8 TDA6 @ $ + addressof(SCM.root.TDA6);
    u8 TDA7 @ $ + addressof(SCM.root.TDA7);
    u8 TDA8 @ $ + addressof(SCM.root.TDA8);
    u8 TDA9 @ $ + addressof(SCM.root.TDA9);
    u8 TDAA @ $ + addressof(SCM.root.TDAA);
    u8 TDAB @ $ + addressof(SCM.root.TDAB);
    u8 TDAC @ $ + addressof(SCM.root.TDAC);
    u8 TDAD @ $ + addressof(SCM.root.TDAD);
    u8 TDAE @ $ + addressof(SCM.root.TDAE);
    u8 TDAF @ $ + addressof(SCM.root.TDAF);
    u8 TDB0 @ $ + addressof(SCM.root.TDB0);
    u8 TDB1 @ $ + addressof(SCM.root.TDB1);
    u8 TDB2 @ $ + addressof(SCM.root.TDB2);
    u8 TDB3 @ $ + addressof(SCM.root.TDB3);
    u8 TDB4 @ $ + addressof(SCM.root.TDB4);
    u8 TDB5 @ $ + addressof(SCM.root.TDB5);
    u8 TDB6 @ $ + addressof(SCM.root.TDB6);
    u8 TDB7 @ $ + addressof(SCM.root.TDB7);
    u8 TDB8 @ $ + addressof(SCM.root.TDB8);
    u8 TDB9 @ $ + addressof(SCM.root.TDB9);
    u8 TDBA @ $ + addressof(SCM.root.TDBA);
    u8 TDBB @ $ + addressof(SCM.root.TDBB);
};

/*-----------------------------DEVICE-----------------------------*/

struct Device {
    u8 TD2E @ $ + addressof(SCM.root.TD2E);
    u8 TD2F @ $ + addressof(SCM.root.TD2F);
    u8 TD2B @ $ + addressof(SCM.root.TD2B);
    u8 TD2C @ $ + addressof(SCM.root.TD2C);
};

/*-----------------------------POWER------------------------------*/

struct Power {
    u8 TD30 @ $ + addressof(SCM.root.TD30);
    u8 TDBE @ $ + addressof(SCM.root.TDBE); // 0xbc
    u8 TDBF @ $ + addressof(SCM.root.TDBF); // 0xbd
};

/*-------------------------MASTER-BATTERY-------------------------*/

struct MasterBattery {
    u8 TD31 @ $ + addressof(SCM.root.TD31);
    u16 TD38 @ $ + addressof(SCM.root.TD38);
    u16 TD3A @ $ + addressof(SCM.root.TD3A);
    u16 TD3C @ $ + addressof(SCM.root.TD3C);
    u16 TD3E @ $ + addressof(SCM.root.TD3E);
    u16 TD40 @ $ + addressof(SCM.root.TD40);
    u16 TD42 @ $ + addressof(SCM.root.TD42);
    u16 TD44 @ $ + addressof(SCM.root.TD44);
    u16 TD46 @ $ + addressof(SCM.root.TD46);
    u16 TD48 @ $ + addressof(SCM.root.TD48);
    u16 TD4A @ $ + addressof(SCM.root.TD4A);
    u16 TD4C @ $ + addressof(SCM.root.TD4C);
    u8 TDE8 @ $ + addressof(SCM.root.TDE8);
    u8 TD35 @ $ + addressof(SCM.root.TD35);
    u8 TD36 @ $ + addressof(SCM.root.TD36);
    u16 TD4E @ $ + addressof(SCM.root.TD4E);

};

/*-------------------------SLAVE--BATTERY-------------------------*/

struct SlaveBattery {
    u8 TD32 @ $ + addressof(SCM.root.TD32);
    u16 TD50 @ $ + addressof(SCM.root.TD50);
    u16 TD52 @ $ + addressof(SCM.root.TD52);
    u16 TD54 @ $ + addressof(SCM.root.TD54);
    u16 TD56 @ $ + addressof(SCM.root.TD56);
    u16 TD58 @ $ + addressof(SCM.root.TD58);
    u16 TD5A @ $ + addressof(SCM.root.TD5A);
    u16 TD5C @ $ + addressof(SCM.root.TD5C);
    u16 TD5E @ $ + addressof(SCM.root.TD5E);
    u16 TD60 @ $ + addressof(SCM.root.TD60);
    u16 TD62 @ $ + addressof(SCM.root.TD62);
    u16 TD64 @ $ + addressof(SCM.root.TD64);
    u8 TDE9 @ $ + addressof(SCM.root.TDE9);
    u16 TD66 @ $ + addressof(SCM.root.TD66);
};

/*------------------------------CPU-------------------------------*/

struct CPU {
    u8 TD33 @ $ + addressof(SCM.root.TD33);
    u8 TD68 @ $ + addressof(SCM.root.TD68);
    u8 TD71 @ $ + addressof(SCM.root.TD71);
    u8 TD70 @ $ + addressof(SCM.root.TD70);
    u8 TD69 @ $ + addressof(SCM.root.TD69);
    u8 TD6A @ $ + addressof(SCM.root.TD6A);
    u8 TD6B @ $ + addressof(SCM.root.TD6B);
    u8 TD6C @ $ + addressof(SCM.root.TD6C);
    u8 TD6D @ $ + addressof(SCM.root.TD6D);
    u8 TD6E @ $ + addressof(SCM.root.TD6E);
    u8 TD6F @ $ + addressof(SCM.root.TD6F);
    u8 TD72 @ $ + addressof(SCM.root.TD72);
    u8 TD73 @ $ + addressof(SCM.root.TD73);
    u8 TD74 @ $ + addressof(SCM.root.TD74);
    u8 TD75 @ $ + addressof(SCM.root.TD75);
    u8 TD76 @ $ + addressof(SCM.root.TD76);
    u8 TD77 @ $ + addressof(SCM.root.TD77);
    u8 TD78 @ $ + addressof(SCM.root.TD78);
    u8 TD79 @ $ + addressof(SCM.root.TD79);
};

/*------------------------------VGA-------------------------------*/

struct VGA {
    u8 TD33 @ $ + addressof(SCM.root.TD33);
    u8 TD80 @ $ + addressof(SCM.root.TD80);
    u8 TD89 @ $ + addressof(SCM.root.TD89);
    u8 TD88 @ $ + addressof(SCM.root.TD88);
    u8 TD81 @ $ + addressof(SCM.root.TD81);
    u8 TD82 @ $ + addressof(SCM.root.TD82);
    u8 TD83 @ $ + addressof(SCM.root.TD83);
    u8 TD84 @ $ + addressof(SCM.root.TD84);
    u8 TD85 @ $ + addressof(SCM.root.TD85);
    u8 TD86 @ $ + addressof(SCM.root.TD86);
    u8 TD87 @ $ + addressof(SCM.root.TD87);
    u8 TD8A @ $ + addressof(SCM.root.TD8A);
    u8 TD8B @ $ + addressof(SCM.root.TD8B);
    u8 TD8C @ $ + addressof(SCM.root.TD8C);
    u8 TD8D @ $ + addressof(SCM.root.TD8D);
    u8 TD8E @ $ + addressof(SCM.root.TD8E);
    u8 TD8F @ $ + addressof(SCM.root.TD8F);
    u8 TD90 @ $ + addressof(SCM.root.TD90);
};

/*-----------------------------SYSTEM-----------------------------*/

struct System {
    TE40 TE40 @ $ + addressof(SCM.root.TE4.TE40);
    TE43 TE43 @ $ + addressof(SCM.root.TE4.TE43);
    u8 TDE7 @ $ + addressof(SCM.root.TDE7);
    u8 TDF0 @ $ + addressof(SCM.root.TDF0);
    u8 TDF1 @ $ + addressof(SCM.root.TDF1);
    u8 TDFE @ $ + addressof(SCM.root.TDFE);
    u8 TDFF @ $ + addressof(SCM.root.TDFF);
    u8 TDF2 @ $ + addressof(SCM.root.TDF2);
    u8 TDF3 @ $ + addressof(SCM.root.TDF3);
    u8 TDF4 @ $ + addressof(SCM.root.TDF4);
    u8 TDF5 @ $ + addressof(SCM.root.TDF5);
    u8 TDF6 @ $ + addressof(SCM.root.TDF6);
    u8 TDF7 @ $ + addressof(SCM.root.TDF7);
    u8 TDF8 @ $ + addressof(SCM.root.TDF8);
    u8 TDF9 @ $ + addressof(SCM.root.TDF9);
    u8 TDFA @ $ + addressof(SCM.root.TDFA);
    u8 TDFB @ $ + addressof(SCM.root.TDFB);
    u8 TDFC @ $ + addressof(SCM.root.TDFC);
    u8 TDFD @ $ + addressof(SCM.root.TDFD);
    u8 TDE0 @ $ + addressof(SCM.root.TDE0);
    u8 TDE3 @ $ + addressof(SCM.root.TDE3);
};

/*-------------------------------AP-------------------------------*/

struct AP {
    u8 TDCF @ $ + addressof(SCM.root.TDCF);
    u8 TDCE @ $ + addressof(SCM.root.TDCE);
    u8 TDCD @ $ + addressof(SCM.root.TDCD);
    u8 TDCC @ $ + addressof(SCM.root.TDCC);
    u8 TDCB @ $ + addressof(SCM.root.TDCB);
    u8 TDCA @ $ + addressof(SCM.root.TDCA);
    u8 TDC9 @ $ + addressof(SCM.root.TDC9);
    u8 TDC8 @ $ + addressof(SCM.root.TDC8);
};

/*-----------------------------EVENT------------------------------*/

struct Event {
    TE40 TE40 @ $ + addressof(SCM.root.TE4.TE40);
    TE43 TE43 @ $ + addressof(SCM.root.TE4.TE43);
    u8 TD2E @ $ + addressof(SCM.root.TD2E);
    u8 TDF1 @ $ + addressof(SCM.root.TDF1);
};

/*-----------------------------TOGGLE-----------------------------*/


Toggle<Software, "Software", SHOw_Software> Software @ 0x00;
Toggle<Device, "Device", SHow_Device> Device @ 0x00;
Toggle<Power, "Power", SHow_Power> Power @ 0x00;
Toggle<MasterBattery, "MasterBattery", ShOW_MasterBattery> MasterBattery @ 0x00;
Toggle<SlaveBattery, "SlaveBattery", ShOW_SlaveBattery> SlaveBattery @ 0x00;
Toggle<CPU, "CPU", ShOw_CPU> CPU @ 0x00;
Toggle<VGA, "VGA", ShOw_VGA> VGA @ 0x00;
Toggle<System, "System", ShoW_System> System @ 0x00;
Toggle<AP, "AP", Show_AP> AP @ 0x00;
Toggle<Event, "Event", Show_Event> Event @ 0x00;

/*----------------------------COMMENTS----------------------------*/

// regex for u16
// TD38|TD3A|TD3C|TD3E|TD40|TD42|TD44|TD46|TD48|TD4A|TD4C|TD4E|TD50|TD52|TD54|TD56|TD58|TD5A|TD5C|TD5E|TD60|TD62|TD64|TD66

// padding\[\d+\];|padding\[0x..\];