#ifndef __VCONTROL_H__
#define __VCONTROL_H__

#define APP_VSTRING "$VER: VControl 1.23 (17.11.2022) (C) Apollo-Team"

/*****************************************************************
 * VAMPIRE HARDWARE
 *****************************************************************/

#define VREG_FASTIDE    0xdd1020
#define VREG_SDCLKDIV   0xde000c
#define VREG_VMODE      0xdff1f4
#define VREG_BOARD      0xdff3fc
#define VREG_MAPROM     0xdff3fe

#define VREG_BOARD_Unknown  0x00
#define VREG_BOARD_V600     0x01
#define VREG_BOARD_V500     0x02
#define VREG_BOARD_V4       0x03
#define VREG_BOARD_V666     0x04
#define VREG_BOARD_V4SA     0x05
#define VREG_BOARD_V1200    0x06
#define VREG_BOARD_V4000    0x07
#define VREG_BOARD_VCD32    0x08
#define VREG_BOARD_Future   0x09

/*****************************************************************
 * EXTERNAL FUNCTIONS
 *****************************************************************/

#define ASM __asm __saveds 

ULONG ASM v_chipset_audio_rev(void);
ULONG ASM v_chipset_video_rev(void);

ULONG ASM v_cpu_multiplier(void);

ULONG ASM v_cpu_vbr(void);
ULONG ASM v_cpu_vbr_on(void);
ULONG ASM v_cpu_vbr_off(void);

ULONG ASM v_cpu_pcr(void);
ULONG ASM v_cpu_pcr_dfp_on(void);
ULONG ASM v_cpu_pcr_dfp_off(void);
ULONG ASM v_cpu_pcr_ess_on(void);
ULONG ASM v_cpu_pcr_ess_off(void);
ULONG ASM v_cpu_pcr_etu_on(void);
ULONG ASM v_cpu_pcr_etu_off(void);

ULONG ASM v_cpu_cacr(void);
ULONG ASM v_cpu_cacr_dcache_on(void);
ULONG ASM v_cpu_cacr_dcache_off(void);
ULONG ASM v_cpu_cacr_icache_on(void);
ULONG ASM v_cpu_cacr_icache_off(void);

ULONG ASM v_cpu_is2p(void);
ULONG ASM v_cpu_is080(void);

ULONG ASM v_fpu_isok(void);
ULONG ASM v_fpu_toggle(register __d0 ULONG state);

ULONG ASM v_joyport_init(void);

ULONG ASM v_read_flashidentifier(void);
ULONG ASM v_read_serialnumber(register __a0 APTR buffer);
ULONG ASM v_read_revisionstring(register __a0 APTR buffer);

ULONG ASM v_maprom(register __a0 APTR buffer);

#endif
