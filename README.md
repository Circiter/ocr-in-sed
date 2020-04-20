# ocr-in-sed

Optical character recognition (OCR) in sed. Reimplementation of Kopczynski's OCR C one-liner.

Example:
```bash
cat examples/9.txt | ./ocr.sed
# Expected output: 9.
```

Try other `examples/*.txt` files or "draw" your own (simple "ascii-art" matrices
of x'es and whitespaces).

The algorithms finds a topological invariant known as the Euler number and uses it
to tell the numbers apart. Currently, it is able to recognize 8, 9, 10, and 11. So many numbers...

See references below and the source code (`ocr.sed`) for implementation details
and related information.

References:
- S.B.Gray, Local Properties of Binary Images in Two Dimensions, 1971
- kopczynski.c by Eryk Kopczynski (http://www.mimuw.edu.pl/~erykk/) for IOCCC (http://www.ioccc.org), 2004
- http://en.wikipedia.org/wiki/optical_character_recognition

