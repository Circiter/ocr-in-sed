#!/bin/sed -Enf

# Optical character recognition in sed.

# Written by Circiter (xcirciter@gmail.com)
# Can be accessed at http://github.com/Circiter/ocr-in-sed

# Usage example: cat 10.txt | ./ocr.sed
# A text fed to the ocr.sed must consist of x'es and spaces
# and represent an "ascii-art" form of a number.
# Being just a reimplementation of kopczynski's ioccc entry,
# it is subject to the same restrictions. Well, it can recognize
# a number from the set 8 through 11... :)

# How to differentiate between 9 and 0, 9 and 6, and so on?
# FIXME: Is it possible to combine this method with, e.g., box-counting dimension?

:read $!{N; bread}; G

# The algorithm just calculates the Euler number of
# a given "image" by the formula
# 4W=n(Q_1)-n(Q_3)-2n(Q_D),
# where n() reperesents the count of specified 2x2 submatrices in
# the image (see README.md for references),
# Q_m is any 2x2 [contiguous] submatrix containing exactly m x'es
# ("black pixels"), Q_d represents any 2x2 submatrix with black
# pixels exclusively on the main or counter-diagonal.

s/^/\n \n/; s/$/\n/

# Immerse the ascii-image into the "sea of spaces."
s/\n(.)/\n>\1/g
:null_exterior
    />\n/ {/>[^\n]/ s/>\n/ >\n/g}
    s/>([^\n])/\1>/g
    />[^\n]/ bnull_exterior
s/>//g

# Add empty columns on the left and on the right.
s/([^\n@])\n/\1@\n/g
s/\n([^@])/\n@\1/g
s/@/ /g

s/^\n/@/; s/^/\n/

s/ /y/g
s/$/-xxxxxxxxxxxxxxx/ # A non-zero initial value allows a negative numbers.

# Enumerate all the 2x2 blocks and count them with appropriate signs.
:scan_rows
    s/\n([^-])/\n>\1/g
    :scan_columns
        />@/ bend_scan_columns
        s/>([^\n])/\1>/g
        bscan_columns
    :end_scan_columns

    # Add the lookup table.
    s/$/$xyyy+yxyy+yyxy+yyyx+xyyxdyxxydxxxy-xxyx-xyxx-yxxx-/ # 4W.

    # Search the current neighborhood in the lookup table.
    s/@([xy][xy])([^>]*>)([xy][xy])(.*\$).*\1\3(.)/@\1\2\3\4\5/

    s/\$\+/x\$/ # Increment the counter (if the lookup table say to do so).
    s/x\$-/\$/ # Decrement the counter.
    s/xx\$d/\$/ # Decrement by two.
    s/\$.*$// # Delete [a remnants of] the lookup table.
    s/>//g
    s/@([^\n])/\1@/; s/@\n/\n@/ # Move to the next position.
    /@-/! bscan_rows

s/^.*-//

# Provide a human-readable output.
s/xxxxxxxxxx//
s/$/${x:8}{xxxxx:9}{xxxxxxxxx:10}{xxxxxxxxxxxxx:11}/
s/^(x*)\$.*\{\1:([^\}]*)\}/\2\$/
s/\$.*$//

/^x*$/ s/^.*$/[can not recognize]/
p
