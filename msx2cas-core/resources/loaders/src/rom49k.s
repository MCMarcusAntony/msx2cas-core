; BLOAD MODULE FOR 49KB ROMS PART 3 (FOR CASLINK3 PROJECT)
; COPYRIGHT (C) 1999-2016 ALEXEY PODREZOV
; Modified by Roberto Focosi for MSX2Cas Project

START:
    JP      START1

STARTA:
    .DW     00
ENDA:
    .DW     00
EXECA:
    .DW     00
CRC:
    .DB     00

CASERR:
    .str    "< MSX2Cas > Fail: CRC ERROR!\0"

START1:
    DI
    LD      HL,(STARTA)
    LD      DE,(ENDA)
    EX      DE,HL
    SCF
    CCF
    SBC     HL,DE
    PUSH    HL
    POP     BC
    LD      HL,#ROMCODE
    XOR     A
    PUSH    AF

START2:
    POP     AF
    ADD     A,(HL)
    INC     HL
    DEC     BC
    PUSH    AF
    LD      A,C
    OR      A
    JR      NZ,START2
    LD      A,B
    OR      A
    JR      NZ,START2
    POP     AF
    LD      B,A
    LD      HL,#CRC
    LD      A,(HL)
    CP      B
    JP      Z,START5

CRCERR:
    EI
    CALL    0x006C        ; set screen 0
    LD      A,#0x0F
    LD      HL,#0x0F3E9
    LD      (HL),A
    LD      A,#8
    INC     HL
    LD      (HL),A
    INC     HL
    LD      (HL),A
    CALL    0x0062        ; set color 15,8,8
    XOR     A
    CALL    0x00C3        ; clear screen
    CALL    0x00CF        ; unhide functional keys
    LD      HL,#0x0101
    CALL    0x00C6        ; set cursor position to 1:1
    LD      DE,#CASERR

START3:
    LD      A,(DE)
    OR      A
    JR      Z,START4
    INC     DE
    CALL    0x00A2        ; display character
    INC     H
    CALL    0x00C6        ; set next position
    JR      START3

START4:
    LD      HL,#0x0103
    CALL    0x00C6        ; set cursor position to 1:3
    CALL    0x00C0        ; beep
    CALL    0x0156        ; clears keyboard buffer
    RET

START5:
    DI
    LD      A,(0x0FFFF)
    CPL
    LD      C,A
    AND     #0x0F0
    LD      B,A
    LD      A,C
    RRCA
    RRCA
    RRCA
    RRCA
    AND     #15
    OR      B
    LD      (0x0FFFF),A
    IN      A,(0x0A8)
    AND     #0x0F0
    LD      B,A
    RRCA
    RRCA
    RRCA
    RRCA
    AND     #15
    OR      B
    PUSH    AF
    OUT     (0x0A8),A

    LD      HL,#START6
    LD      DE,#ROMCODE+1
    EX      DE,HL
    SCF
    CCF
    SBC     HL,DE
    LD      B,H
    LD      C,L
    LD      HL,#START6
    LD      DE,#0x0F560
    PUSH    DE
    LDIR
    RET

START6:
    LD      HL,(EXECA)
    PUSH    HL
    LD      HL,(STARTA)
    LD      DE,(ENDA)
    EX      DE,HL
    SCF
    CCF
    SBC     HL,DE
    LD      B,H
    LD      C,L
    LD      HL,#ROMCODE
    LD      DE,(STARTA)
    LDIR
    POP     HL
    POP     AF
    AND     #0x0FC
    OUT     (0x0A8),A
    EI
    JP      (HL)
    NOP

ROMCODE:
