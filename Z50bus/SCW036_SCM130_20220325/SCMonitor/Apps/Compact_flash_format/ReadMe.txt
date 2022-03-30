Compact Flash Format

This program is written as an App for the Small Computer Monitor v1.0 and
later.

This program formats a Compact Flash card for use with CP/M. It works with
cards of 8MB or more. Only the first 128MB of large cards is used for CP/M.
Although a wide range of card sizes can be formatted, the current versions
of CP/M cbios are only configured for 64MB and 128MB. Other sizes can be
used, but a mismatch with the CP/M cbios may result in some drives being
unavailable or give errors when you try to access a non-existent drive.
This version of format checks for drive errors and verifies the format, so
it should be reliable and alter you to problems if there are any.

The program implements the recommended status checks and also test for 
errors reported by the Compact Flash card. As a result it should be
reliable. It is also informative if problems are detected.

Compact Flash cards in binary multiples from 1MB to 2TB should be 
correctly identified and described. So 1MB, 2MB, 4MB, 8MB, 16MB, 32MB, 
64MB should be correct, but a 48MB card will likely be reported as 32MB. 
It was much easier to deal with just the binary multiples than all 
possible sizes, so I took the easy way out. My bad!

Compatible with LiNC80, Z50Bus, and RC2014 systems.

The hex fils can be download to SCM by using a terminal program's
"Send file" feature to send a .HEX file to SCM.

Typically the program is started with the SCM command "G 8000"


SCC 2022-03-17
