I2C demo / test v2.1 (2021-02-26)

Stephen Cousins
Small Computer Central
www.scc.me.uk



This is an example of how to use I2C devices with bus masters such as SC126 and SC137.

The program has been written in assembler using the Small Computer Workshop (SCW). 

The HEX file can be "sent" from a terminal program, such as Tera Term, to a Z80 system 
running the Small Computer Monitor (SCM). The program can then be executed with the 
command "G 8000".

The example program scans all possible I2C bus addresses looking for devices. The address 
of any device found is then displayed in HEX. The address format is the full 8-bit value 
where bit zero indicates write (low) or read (high).

It is assumed that devices in the SC400 series are configured to their default addresses.
Each device then performs a short demonstration or test. Any devices not compatible with 
the SC400 series could confuse this example code!

WARNING: I2C memory devices are written to as part of the demonstration and this could
delete any data stored in that memory device.

The following devices are supported:

; Default I2C addresses      Device     Write   Read     Alternatives
; =====================      ======     =====   ====     ============
; SC138 Memory card          24LC256    0xAE    0xAF     None
; SC401 Prototyping module   ?          ?       ?        ?
; SC402 Memory module        24xxx      0xA0    0xA1     1010 AAA-
; SC403 Digital I/O module   MCP2318    0x40    0x41     0100 AAA-
; SC404 Digital I/O module   MCP2308    0x42    0x43     0100 AAA-
; SC405 Digital I/O module   PCF8574/A  0x74    0x75     0100 AAA- / 0111 AAA-
; SC406 Temperature sensor   TC74 A5    0x9A    0x9B     Alternative chips
; SC407 Switches and lights  PCF8574/A  0x4E/7E 0x4F/7F  0100 AAA- / 0111 AAA-


SC138 Memory card (eg. 24LCxxx) at Write=AE Read=AF
A simple write and read back test is performed on a single memory location.
A pass/fail result is indicated.

SC402 Memory module (eg. 24LCxxx) at Write=A0 Read=A1
A simple write and read back test is performed on a single memory location.
A pass/fail result is indicated.
The write protect jumper on this module can be set to prevent writing to the memory
chip which will result in a "fail" report.

SC403 Digital I/O Module (MCP23018) at Write=40 Read=41
Port A bit 0 set to output driven low.
Port A bits 1 to 7 set to inputs.
Weak pull up resistors enabled on all I/O bits.
The I/O port write and read sults are indicated.
The output is configured as open collector with a weak pull up.
The I/O pins therefore function as quasi-birectional I/O.

SC404 Digital I/O Module (MCP23008) at Write=42 Read=43
Port bit 0 set to output driven low.
Port bits 1 to 7 set to inputs.
Weak pull up resistors enabled on all I/O bits.
The I/O port write and read sults are indicated.
The outputs are configured as open collector with weak pull ups.
The I/O pins therefore function as quasi-birectional I/O.

SC405 Digital I/O module (PCF8574/A) at Write=74 Read=75
The PCF8574A part is assumed, at address 0x74/0x75.
All outputs are turned off, followed by a 200ms delay.
Output bit 7 is then turned on.
In each case the write and read values are indicated.
The output is configured as open collector with a weak pull up.
The I/O pins therefore function as quasi-birectional I/O.

SC406 Temperature Sensor Module (TC74) at Write=9A Read=9B
The temperature is read and displayed in hex (degrees celsius)
A second and third reading is displayed in hex.

SC407 Switches and lights module (PCF8574A) at Write=7E Read=7F
All outputs are turned off, followed by a 200ms delay.
Output bit 7 is then turned on.
In each case the write and read values are indicated.
Buttons can be pressed and the results observed.
The outputs are configured as open collector with weak pull ups.
The I/O pins therefore function as quasi-birectional I/O.

====================================================================================
Example of output in SCM with the following modules
SC138 Memory card  - present
SC402 Memory module - present
SC403 Digital I/O Module (MCP23018) - present
SC404 Digital I/O Module (MCP23008) - present
SC405 Digital I/O Module (PCF8574)  - NOT present
SC406 Temperature Sensor Module (TC74) - present
SC407 Switches and Lights Module (PCF8574) - present

*g8000
I2C demo/test v2.1.0 by Stephen C Cousins
I2C devices found at: 40 42 7E 9A A0 AE
SC138 Memory card (eg. 24LCxxx) at Write=AE Read=AF
      Memory test passed
SC402 Memory module (eg. 24LCxxx) at Write=A0 Read=A1
      Memory test passed
SC403 Digital I/O Module (MCP23018) at Write=40 Read=41
      Output = FE, Input = FE
SC404 Digital I/O Module (MCP23008) at Write=42 Read=43
      Output = FE, Input = FE
SC405 Digital I/O Module (PCF8574) at Write=74 Read=75
      Device not found
SC406 Temperature Sensor Module (TC74) at Write=9A Read=9B
      Temparature 'C (in hex) = 13 14 14
SC407 Switches and Lights Module (PCF8574) at Write=7E Read=7F
      Output = 00, Input = 00
      Output = FF, Input = FF
*