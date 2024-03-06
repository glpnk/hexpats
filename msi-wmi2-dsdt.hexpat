import std.core;
import std.io;
import std.mem;

/*------------------------------NOTE------------------------------*/
/*
    https://github.com/glpnk/hexpats

    + this pattern include rework of https://github.com/ThePBone/msi-ec-modern/blob/master/msi_modern_15_a11m_ec.hexpat
    + this pattern require ImHex release v1.33 or newer stable for comfortable usage

    + SCM block is mapped, but not used, values is directly RW by address

    + WMI WMxx method struct: { u8 instance, u8 method_id, u8 buffer[], }
    + check https://docs.kernel.org/next/wmi/acpi-interface.html

    + single WMI method WMAM, args: {0} ignored, {1} method_id, {2} buffer
    + Internal logic:
    +     1. Fill return buffer with zeroes, this buffer is mapped to args BFL0[BL00, BL01, ..., BL31]
    +         BL00 is something like success mark
    +     2. Split input buffer to args [IPAR, BS00, BS01, ..., BS30]
    +     3. switch Arg1
    +     3.0. return BFL0 (zeroed)
    +     3.1. switch IPAR { [read to BLxx]/[write from BSxx], set BL00=0, return BFL0 }
    +     3.2. { [read to BLxx]/[write from BSxx], set BL00=0, return BFL0 }
    +     3.3. read/write byte by address IPAR, write value BS00
    +     3.4. return MAJR, MINR (wmi version)
    + Some steps could be omitted

    + if Arg1: 0x01, 0x02, 0x1E+ : returned zeroed package
    + if Arg1: 0x04 : returned 0x01
*/
/*-----------------------------TOGGLE-----------------------------*/

bool SHOW__EC in;
bool SHOW_SCM in;
bool SHOW_ThePBone in;

bool SHOw_Package in;
bool SHoW_EC in;
bool SHow_BIOS in;
bool ShOW_SMBUS in;
bool ShOw_MasterBattery in;
bool ShoW_SlaveBattery in;
bool Show_Temperature in;
bool sHOW_Thermal in;
bool sHOw_Fan in;
bool sHoW_Device in;
bool sHow_Power in;
bool shOW_Debug in;
bool shOw_AP in;
bool shoW_Data in;
bool show_WMI in;


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
    padding : 1;
    MICL : 1;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

bitfield  x2D {
    padding : 1;
    MUTL : 1;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

bitfield  x2E {
    padding : 6;
    PXCT : 1;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

bitfield  x30 {
    POWS : 1;
    LIDS : 1;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

bitfield  x31 {
    MBTS : 1;
    MBCS : 1;
    MBDS : 1;
    MBFS : 1;
    MBWS : 1;
    MBLS : 1;
    MBCL : 1;
    MBFL : 1;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

bitfield  x32 {
    SBTS : 1;
    SBCS : 1;
    SBDS : 1;
    SBFS : 1;
    SBWS : 1;
    SBLS : 1;
    SBCL : 1;
    SBFL : 1;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

bitfield  x36 {
    padding : 4;
    OSVR : 4;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

bitfield  x7E {
    RES1 : 3;
    CHET : 1;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

bitfield  xD2 {
    SYSM : 2;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

bitfield  xD4 {
    padding : 4;
    SILE : 1;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

bitfield  xE7 {
    DTOK : 1;
    DTNG : 1;
    FBST : 1;
    ESGI : 1;
    ESGO : 1;
    ESGN : 1;
    E706 : 1;
    DTDR : 1;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

bitfield  xE8 {
    RSUS : 1;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

bitfield  xE9 {
    padding : 1;
    BTTM : 1;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

bitfield  xEB {
    PSNM : 7;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

bitfield  xEC {
    MODS : 1;
    KBBL : 1;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

bitfield  xED {
    ISHS : 2;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];


struct EC_ {
    u8 SMPR;
    u8 SMST;
    u8 SMAD;
    u8 SMCM;
    u8 SMD0[33]; // 264 bit = u8 [33]
    u8 SMAA;
    Offset <0x2C>;
    x2C;
    Offset <0x2D>;
    x2D;
    Offset <0x2E>;
    x2E;
    Offset <0x30>;
    x30;
    Offset <0x31>;
    x31;
    x32;
    Offset <0x36>;
    x36;
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
    u8 MCVL;
    u8 MCVH;
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
    u8 SCVL;
    u8 SCVH;
    u8 CPUT;
    Offset <0x7E>;
    x7E;
    Offset <0x80>;
    u8 SYST;
    Offset <0xC6>;
    u8 CPTE;
    Offset <0xD2>;
    xD2;
    Offset <0xD4>;
    xD4;
    Offset <0xE3>;
    u8 OSC1;
    u8 OSC2;
    Offset <0xE6>;
    u8 DBG;
    xE7;
    xE8;
    Offset <0xE9>;
    xE9;
    Offset <0xEB>;
    xEB;
    Offset <0xEC>;
    xEC;
    Offset <0xED>;
    u8 SCIC;
    xED;
    Offset <0xF4>;
    u8 TSIT;
    u8 TSTU;
    u8 TSTL;
    u8 TST2;
    u8 TSU2;
    u8 TSL2;
    Offset <0xFD>;
    u8 CFID;
    u8 GFID;
};

/*---------------------------SCM-STRUCT---------------------------*/

bitfield  TDD9 {
    TDD9 : 1;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

bitfield  TE4 {
    TE40 : 3;
    TE43 : 5;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];


struct SCM {
    Offset <0x28>;
    u8 TD28;
    u8 TD29;
    u8 TD2A;
    u8 TD2B;
    u8 TD2C;
    u8 TD2D;
    u8 TD2E;
    u8 TD2F;
    u8 TD30;
    u8 TD31;
    Offset <0x33>;
    u8 TD33;
    u8 TD34;
    Offset <0x37>;
    u8 TD37;
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
    u8 TDBC;
    u8 TDBD;
    u8 TDBE;
    u8 TDBF;
    Offset <0xC8>;
    u8 TDC8;
    u8 TDC9;
    u8 TDCA;
    u8 TDCB;
    u8 TDCC;
    u8 TDCD;
    Offset <0xD0>;
    u8 TDD0;
    u8 TDD1;
    u8 TDD2;
    u8 TDD3;
    u8 TDD4;
    u8 TDD5;
    u8 TDD6;
    Offset <0xD8>;
    u8 TDD8;
    TDD9;
    Offset <0xE0>;
    u8 TDE0;
    Offset <0xE3>;
    u8 TDE3;
    TE4;
    u8 TDE5;
    u8 TDE6;
    u8 TDE7;
    u8 TDE8;
    Offset <0xED>;
    u8 TDED;
    u8 TDFA;
    u8 TDFB;
    u8 TDFC;
    u8 TDFD;
    u8 TDFE;
    u8 TDFF;
};

/*------------------------------WMI2------------------------------*/

struct Package {
    // Get 0x01 / Set 0x02
    // Result: fault
};

struct EC {
    // Get 0x03 / Set 0x04
    // Result: success
    // only Get access EC, on Set only return u8 0x01
    u8 RD00 @ 0x37;
    u8 RD01 @ 0xA0;
    u8 RD02 @ 0xA1;
    u8 RD03 @ 0xA2;
    u8 RD04 @ 0xA3;
    u8 RD05 @ 0xA4;
    u8 RD06 @ 0xA5;
    u8 RD07 @ 0xA6;
    u8 RD08 @ 0xA7;
    u8 RD09 @ 0xA8;
    u8 RD10 @ 0xA9;
    u8 RD11 @ 0xAA;
    u8 RD12 @ 0xAB;
    u8 RD13 @ 0xAC;
    u8 RD14 @ 0xAD;
    u8 RD15 @ 0xAE;
    u8 RD16 @ 0xAF;
    u8 RD17 @ 0xB0;
    u8 RD18 @ 0xB1;
    u8 RD19 @ 0xB2;
    u8 RD20 @ 0xB3;
    u8 RD21 @ 0xB4;
    u8 RD22 @ 0xB5;
    u8 RD23 @ 0xB6;
    u8 RD24 @ 0xB7;
    u8 RD25 @ 0xB8;
    u8 RD26 @ 0xB9;
    u8 RD27 @ 0xBA;
    u8 RD28 @ 0xBB;
};

struct BIOS {
    // Get 0x05 / Set 0x06
    // Result: success
    // Get/Set looks similar
    u8 RW0_00 @ 0xE0;
    u8 RW0_01 @ 0xE3;
    u8 RW0_02 @ 0xE4;
    u8 RW0_03 @ 0xE5;
    u8 RW0_04 @ 0xE6;
    u8 RW0_05 @ 0xE7;
    u8 RW0_06 @ 0xE1;
    u8 RW0_07 @ 0xE2;

    u8 RW1_00 @ 0xE8;
    u8 RW1_01 @ 0xEB;
    u8 RW1_02 @ 0xEC;
    u8 RW1_03 @ 0xED;
    u8 RW1_04 @ 0xEE;
    u8 RW1_05 @ 0xEF;
    u8 RW1_06 @ 0xE9;
    u8 RW1_07 @ 0xEA;

    u8 RW2_00 @ 0xF0;
    u8 RW2_01 @ 0xF1;
    u8 RW2_02 @ 0xF2;
    u8 RW2_03 @ 0xF3;

    u8 RW3_00 @ 0xF4;
    u8 RW3_01 @ 0xF5;
    u8 RW3_02 @ 0xF6;
    u8 RW3_03 @ 0xF7;
    u8 RW3_04 @ 0xF8;
    u8 RW3_05 @ 0xF9;

    u8 RW4_00 @ 0xFA;
    u8 RW4_01 @ 0xFB;
    u8 RW4_02 @ 0xFC;
    u8 RW4_03 @ 0xFD;
    u8 RW4_04 @ 0xFE;
    u8 RW4_05 @ 0xFF;
};

struct SMBUS {
    // Get 0x07 / Set 0x08
    // Result: success
    // Get/Set looks similar
    u8 RW0_00 @ 0x00;

    u8 RW1_00 @ 0x01;

    u8 RW2_00 @ 0x02;
    u8 RW2_01 @ 0x03;

    u8 RW3_00 @ 0x04;
    u8 RW3_01 @ 0x05;
    u8 RW3_02 @ 0x06;
    u8 RW3_03 @ 0x07;
    u8 RW3_04 @ 0x08;
    u8 RW3_05 @ 0x09;
    u8 RW3_06 @ 0x0A;
    u8 RW3_07 @ 0x0B;
    u8 RW3_08 @ 0x0C;
    u8 RW3_09 @ 0x0D;
    u8 RW3_10 @ 0x0E;
    u8 RW3_11 @ 0x0F;
    u8 RW3_12 @ 0x10;
    u8 RW3_13 @ 0x11;
    u8 RW3_14 @ 0x12;
    u8 RW3_15 @ 0x13;

    u8 RW4_00 @ 0x14;
    u8 RW4_01 @ 0x15;
    u8 RW4_02 @ 0x16;
    u8 RW4_03 @ 0x17;
    u8 RW4_04 @ 0x18;
    u8 RW4_05 @ 0x19;
    u8 RW4_06 @ 0x1A;
    u8 RW4_07 @ 0x1B;
    u8 RW4_08 @ 0x1C;
    u8 RW4_09 @ 0x1D;
    u8 RW4_10 @ 0x1E;
    u8 RW4_11 @ 0x1F;
    u8 RW4_12 @ 0x20;
    u8 RW4_13 @ 0x21;
    u8 RW4_14 @ 0x22;
    u8 RW4_15 @ 0x23;

    u8 RW5_00 @ 0x24;
    u8 RW5_01 @ 0x25;
    u8 RW5_02 @ 0x26;
};

struct MasterBattery {
    // Get 0x09 / Set 0x0A
    // Result: success
    // Get/Set looks similar
    u8 RW0_00 @ 0x31;
    u8 RW0_01 @ 0xBC;

    u8 RW1_00 @ 0x38;
    u8 RW1_01 @ 0x39;
    u8 RW1_02 @ 0x3A;
    u8 RW1_03 @ 0x3B;
    u8 RW1_04 @ 0x3C;
    u8 RW1_05 @ 0x3D;
    u8 RW1_06 @ 0x3E;
    u8 RW1_07 @ 0x3F;

    u8 RW2_00 @ 0x40;
    u8 RW2_01 @ 0x41;
    u8 RW2_02 @ 0x42;
    u8 RW2_03 @ 0x43;
    u8 RW2_04 @ 0x44;
    u8 RW2_05 @ 0x45;
    u8 RW2_06 @ 0x46;
    u8 RW2_07 @ 0x47;

    u8 RW3_00 @ 0x48;
    u8 RW3_01 @ 0x49;
    u8 RW3_02 @ 0x4A;
    u8 RW3_03 @ 0x4B;
    u8 RW3_04 @ 0x4C;
    u8 RW3_05 @ 0x4D;
    u8 RW3_06 @ 0x4E;
    u8 RW3_07 @ 0x4F;

};

struct SlaveBattery {
    // Get 0x0B / Set 0x0C
    // Result: success
    // Get/Set looks similar
    u8 RW0_00 @ 0x32;
    u8 RW0_01 @ 0xBD;

    u8 RW1_00 @ 0x50;
    u8 RW1_01 @ 0x51;
    u8 RW1_02 @ 0x52;
    u8 RW1_03 @ 0x53;
    u8 RW1_04 @ 0x54;
    u8 RW1_05 @ 0x55;
    u8 RW1_06 @ 0x56;
    u8 RW1_07 @ 0x57;

    u8 RW2_00 @ 0x58;
    u8 RW2_01 @ 0x59;
    u8 RW2_02 @ 0x5A;
    u8 RW2_03 @ 0x5B;
    u8 RW2_04 @ 0x5C;
    u8 RW2_05 @ 0x5D;
    u8 RW2_06 @ 0x5E;
    u8 RW2_07 @ 0x5F;

    u8 RW3_00 @ 0x60;
    u8 RW3_01 @ 0x61;
    u8 RW3_02 @ 0x62;
    u8 RW3_03 @ 0x63;
    u8 RW3_04 @ 0x64;
    u8 RW3_05 @ 0x65;
    u8 RW3_06 @ 0x66;
    u8 RW3_07 @ 0x67;
};

struct Temperature {
    // Get 0x0D / Set 0x0E
    // Result: success
    // Get/Set looks similar
    u8 RW0_00 @ 0x68;
    u8 RW0_01 @ 0x80;
    u8 RW0_02 @ 0x9F;

    u8 RW1_00 @ 0x69;
    u8 RW1_01 @ 0x6F;
    u8 RW1_02 @ 0x70;
    u8 RW1_03 @ 0x6A;
    u8 RW1_04 @ 0x6B;
    u8 RW1_05 @ 0x6C;
    u8 RW1_06 @ 0x6D;
    u8 RW1_07 @ 0x6E;

    u8 RW2_00 @ 0x81;
    u8 RW2_01 @ 0x87;
    u8 RW2_02 @ 0x88;
    u8 RW2_03 @ 0x82;
    u8 RW2_04 @ 0x83;
    u8 RW2_05 @ 0x84;
    u8 RW2_06 @ 0x85;
    u8 RW2_07 @ 0x86;
};

struct Thermal {
    // Get 0x0F / Set 0x10
    // Result: success
    // Get/Set looks similar
    u8 RW0_00 @ 0x33;
    u8 RW0_01 @ 0x34;

    u8 RW1_00 @ 0x79;
    u8 RW1_01 @ 0x7A;
    u8 RW1_02 @ 0x7B;
    u8 RW1_03 @ 0x7C;
    u8 RW1_04 @ 0x7D;
    u8 RW1_05 @ 0x7E;
    u8 RW1_06 @ 0x7F;

    u8 RW2_00 @ 0x91;
    u8 RW2_01 @ 0x92;
    u8 RW2_02 @ 0x93;
    u8 RW2_03 @ 0x94;
    u8 RW2_04 @ 0x95;
    u8 RW2_05 @ 0x96;
    u8 RW2_06 @ 0x97;

    u8 RW3_00 @ 0x98;
    u8 RW3_01 @ 0x99;
    u8 RW3_02 @ 0x9A;
    u8 RW3_03 @ 0x9B;
    u8 RW3_04 @ 0x9C;
    u8 RW3_05 @ 0x9D;
    u8 RW3_06 @ 0x9E;
};

struct Fan {
    // Get 0x11 / Set 0x12
    // Result: success
    // Get/Set looks similar
    u8 RW0_00 @ 0xC8;
    u8 RW0_01 @ 0xC9;
    u8 RW0_02 @ 0xCA;
    u8 RW0_03 @ 0xCB;
    u8 RW0_04 @ 0xCC;
    u8 RW0_05 @ 0xCD;
    u8 RW0_06 @ 0xCE;
    u8 RW0_07 @ 0xCF;

    u8 RW1_00 @ 0x71;
    u8 RW1_01 @ 0x72;
    u8 RW1_02 @ 0x73;
    u8 RW1_03 @ 0x74;
    u8 RW1_04 @ 0x75;
    u8 RW1_05 @ 0x76;
    u8 RW1_06 @ 0x77;
    u8 RW1_07 @ 0x78;

    u8 RW2_00 @ 0x89;
    u8 RW2_01 @ 0x8A;
    u8 RW2_02 @ 0x8B;
    u8 RW2_03 @ 0x8C;
    u8 RW2_04 @ 0x8D;
    u8 RW2_05 @ 0x8E;
    u8 RW2_06 @ 0x8F;
    u8 RW2_07 @ 0x90;
};

struct Device {
    // Get 0x13 / Set 0x14
    // Result: success
    // Get/Set looks similar
    u8 RW0_00 @ 0x28;
    u8 RW0_01 @ 0x29;

    u8 RW1_00 @ 0x2E;
    u8 RW1_01 @ 0x2F;
    u8 RW1_02 @ 0x2C;
    u8 RW1_03 @ 0x2D;
    u8 RW1_04 @ 0x2A;
    u8 RW1_05 @ 0x2B;
};

struct Power {
    // Get 0x15 / Set 0x16
    // Result: success
    // Get/Set looks similar
    u8 RW0_00 @ 0x30;
    u8 RW0_01 @ 0xBE;
    u8 RW0_02 @ 0xBF;
};

struct Debug {
    // Get 0x17 / Set 0x18
    // Result: success
    // Get/Set looks similar
    u8 RW0_00 @ 0xC0;
    u8 RW0_01 @ 0xC1;
    u8 RW0_02 @ 0xC2;
    u8 RW0_03 @ 0xC3;
    u8 RW0_04 @ 0xC4;
    u8 RW0_05 @ 0xC5;
    u8 RW0_06 @ 0xC6;
    u8 RW0_07 @ 0xC7;

    u8 RW1_00 @ 0x35;
    u8 RW1_01 @ 0x36;
};

struct AP {
    // Get 0x19 / Set 0x1A
    // Result: success
    // Get/Set looks similar
    u8 RW0_00 @ 0xD0;
    u8 RW0_01 @ 0xD1;
    u8 RW0_02 @ 0xD2;
    u8 RW0_03 @ 0xD3;
    u8 RW0_04 @ 0xD7;
    u8 RW0_05 @ 0xDB;

    u8 RW1_00 @ 0xD4;
    u8 RW1_01 @ 0xD5;
    u8 RW1_02 @ 0xD6;

    u8 RW2_00 @ 0xD8;
    u8 RW2_01 @ 0xD9;
    u8 RW2_02 @ 0xDA;
    u8 RW2_03 @ 0xDC;
    u8 RW2_04 @ 0xDD;
    u8 RW2_05 @ 0xDE;
    u8 RW2_06 @ 0xDF;
};

struct Data {
    // Get 0x1B / Set 0x1C
    // Result: success
    // Get/Set by RW00 address
};

struct WMI {
    // return MAJR, MINR WMI version
    // Name (TDVR, 0x14)
    // Name (MAJR, 0x02)
    // Name (MINR, 0x08)
};

/*------------------------bitfield-to-enum------------------------*/

enum ShiftMode : u8 {
    SM_ECO_NAME     = 0x02, // C2
    SM_COMFORT_NAME = 0x01, // C1
    SM_SPORT_NAME   = 0x00, // C0
    SM_TURBO_NAME   = 0x04, // C4
};

enum FanModes : u8 {
    FM_AUTO_NAME     = 0x00, // 0D
    FM_SILENT_NAME   = 0x01, // 1D
    FM_BASIC_NAME    = 0x04, // 4D
    FM_ADVANCED_NAME = 0x08, // 8D
};
// Declare our bitfield
bitfield Shift {
    Shift   : 4 [[format("format_enum_shift")]]; // Format this field using the format_enum_flag() function
    padding : 4;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

// Declare our bitfield
bitfield FanMode {
    padding : 4;
    FanMode : 4 [[format("format_enum_fan")]]; // Format this field using the format_enum_flag() function
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

// Declare the formatter function
fn format_enum_shift(u8 value) {
    // Cast the value of the field to our enum
    ShiftMode enumValue = value;

    // Return the enum, the formatter will stringify it automatically
    return enumValue;
};

// Declare the formatter function
fn format_enum_fan(u8 value) {
    // Cast the value of the field to our enum
    FanModes enumValue = value;

    // Return the enum, the formatter will stringify it automatically
    return enumValue;
};

/*----------------------------ThePBone----------------------------*/
/* Rework of ThePBone's hexpat from
 * https://github.com/ThePBone/msi-ec-modern/blob/master/msi_modern_15_a11m_ec.hexpat
 * licensed under GPL-2.0
 */

namespace mod {

    bitfield x2c {
        padding : 1;
        micMuteLed : 1;
        keyboardLock : 1;
        keyboardLock2 : 1;
        padding : 4;
    } [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

    bitfield x2d {
        padding : 1;
        muteLed : 1;
        padding : 6;
    } [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

    bitfield x2e {
        btEnabled : 1;
        webcamEnabled : 1;
        padding : 1;
        wlanEnabled : 1;
        padding : 4;
    } [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

    bitfield x2f {
        padding : 1;
        webcamHardEnabled : 1; // Blocks regular webcam key
        padding : 6;
    } [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

    bitfield x30 {
        acConnected : 1;
        lidOpen : 1;
        padding : 6;
    } [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

    bitfield x98 {
        padding : 7;
        coolerBoost : 1;
    } [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

// Not used on my model as it has no dedicated GPU
    bitfield xd1 {
        graphicsSwitchA : 1;
        graphicsSwitchB : 1;
        padding : 6;
    } [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

    bitfield xd3 {
        backlight : 4;
        padding : 4;
    } [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

    bitfield xd4 {
        padding : 4;
        fanSilent : 1; // <- used by 'silent' scenario
        padding : 1;
        fanUseBasicMode : 1; // <- Auto mode if both false
        fanUseAdvancedMode : 1; //  <-/
    } [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

    bitfield xd7 {
        batteryMode : 7; // stop charging at 100; 80 or 60
        padding : 1;
    } [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

    bitfield xd9 {
        isScmInstalled : 1;
        isFnLockOn_ReadOnly : 1;
        padding : 6;
    } [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];

    bitfield xe8 {
        padding : 4;
        isWinFnSwapped : 1;
        padding : 3;
    } [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8), inline]];
}

struct ThePBone {
    u8 cpuRealtimeTemp @ 0x68;
    u8 cpuTemp0 @ 0x6A;
    u8 cpuTemp1 @ 0x6B;
    u8 cpuTemp2 @ 0x6C;
    u8 cpuTemp3 @ 0x6D;
    u8 cpuTemp4 @ 0x6E;
    u8 cpuTemp5 @ 0x6F;
    u8 cpuTemp6 @ 0x70; // <- unused by MSI Center

    u8 cpuRealtimeFanSpeed @ 0x71;
    u8 cpuFanSpeed0 @ 0x72;
    u8 cpuFanSpeed1 @ 0x73;
    u8 cpuFanSpeed2 @ 0x74;
    u8 cpuFanSpeed3 @ 0x75;
    u8 cpuFanSpeed4 @ 0x76;
    u8 cpuFanSpeed5 @ 0x77;
    u8 cpuFanSpeed6 @ 0x78; // <- see cpuTemp6

    u8 gpuRealtimeTemp @ 0x80;
    u8 gpuTemp0 @ 0x82;
    u8 gpuTemp1 @ 0x83;
    u8 gpuTemp2 @ 0x84;
    u8 gpuTemp3 @ 0x85;
    u8 gpuTemp4 @ 0x86;
    u8 gpuTemp5 @ 0x87;
    u8 gpuTemp6 @ 0x88; // <- unused by MSI Center

    u8 gpuRealtimeFanSpeed @ 0x89;
    u8 gpuFanSpeed0 @ 0x8A;
    u8 gpuFanSpeed1 @ 0x8B;
    u8 gpuFanSpeed2 @ 0x8C;
    u8 gpuFanSpeed3 @ 0x8D;
    u8 gpuFanSpeed4 @ 0x8E;
    u8 gpuFanSpeed5 @ 0x8F;
    u8 gpuFanSpeed6 @ 0x90; // <- see gpuTemp6

    u16 cpuRealtimeFanRpm @ 0xC8;
    u16 gpuRealtimeFanRpm @ 0xCA;

    char ecVersion[12] @ 0xA0;
    char ecBuildDate[8] @ 0xAC;
    char ecBuildTime[8] @ 0xB4;

    mod::x2c x2c @ 0x2C;
    mod::x2d x2d @ 0x2D;
    mod::x2e x2e @ 0x2E;
    mod::x2f x2f @ 0x2F;
    mod::x30 x30 @ 0x30;
    mod::x98 x98 @ 0x98;
    mod::xd1 xd1 @ 0xD1;

    Shift shift @ 0xD2;
    u8 shiftMode @ 0xD2;

    mod::xd3 xd3 @ 0xD3;
    FanMode fanMode @ 0xD4;
    mod::xd4 xd4 @ 0xD4;
    mod::xd7 xd7 @ 0xD7;
    mod::xd9 xd9 @ 0xD9;
    mod::xe8 xe8 @ 0xE8;
};

/*-----------------------------TOGGLE-----------------------------*/

Toggle<EC_, "EC", SHOW__EC> EC_ @ 0x00;
Toggle<SCM, "SCM", SHOW_SCM> SCM @ 0x00; // Same EC in SCM
Toggle<Package, "Package", SHOw_Package> Package @ 0x00;
Toggle<EC, "EC", SHoW_EC> EC @ 0x00;
Toggle<BIOS, "BIOS", SHow_BIOS> BIOS @ 0x00;
Toggle<SMBUS, "SMBUS", ShOW_SMBUS> SMBUS @ 0x00;
Toggle<MasterBattery, "MasterBattery", ShOw_MasterBattery> MasterBattery @ 0x00;
Toggle<SlaveBattery, "SlaveBattery", ShoW_SlaveBattery> SlaveBattery @ 0x00;
Toggle<Temperature, "Temperature", Show_Temperature> Temperature @ 0x00;
Toggle<Thermal, "Thermal", sHOW_Thermal> Thermal @ 0x00;
Toggle<Fan, "Fan", sHOw_Fan> Fan @ 0x00;
Toggle<Device, "Device", sHoW_Device> Device @ 0x00;
Toggle<Power, "Power", sHow_Power> Power @ 0x00;
Toggle<Debug, "Debug", shOW_Debug> Debug @ 0x00;
Toggle<AP, "AP", shOw_AP> AP @ 0x00;
Toggle<Data, "Data", shoW_Data> Data @ 0x00;
Toggle<WMI, "WMI", show_WMI> WMI @ 0x00;
Toggle<ThePBone, "ThePBone", SHOW_ThePBone> ThePBone @ 0x00;

/*-------------------------------++-------------------------------*/
