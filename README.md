# bastet
A minimal file encryption utility.

## Installation

**PASSWORD MUST BE NO LONGER THAN 21 CHARACTERS**

### Package
Bastet is packaged for the [miz Operating System](https://entertheduat.org). If you are using mizOS, you can install it with `miz fetch -m mizosu97/bastet`.

### Manual
For a manual installation, do the following:
- Download [bastet.c](https://github.com/Mizosu97/bastet/blob/main/src/bastet.c), and open the file in a text editor.
- Edit the password in the line `#define PASSWORD "password123"` to your liking.
- Compile bastet, preferably with GCC. `gcc bastet.c -o bastet`. For Windows, append ".exe" to the end of "bastet".

## Usage
Bastet is used from the command line. Methods for running a program from the command line vary between operating systems. Refer to your system's documentation.

### Encrypt a file
`bastet e <fileName>`

### Decrypt a file**
`bastet d <fileName>`

## Notes
- It is advisable to delete the source code after compiling bastet, as it contains your password.
- Bastet's password can be uncovered via a decompiler.
- Anybody with knowledge in C can read the source code, and crack bastet's encryption algorithm.
- Generally, bastet will keep your files safe from anybody who isn't extremely tech-savvy.



