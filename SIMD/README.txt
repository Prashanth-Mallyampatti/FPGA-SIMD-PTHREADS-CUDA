Overview

In CSC456/591, we are going to use the DE1SoC platform to experience the power of accelerating applications through our knowledge on computer architecture. To begin with, this is a mini assignment that will need you to write probably less than 10 lines of code, but your will use this chance to be more familiar with the platform!

Each of you should receive a microSD card with an adapter that you can use for your individual work. However, due to the limited amount of boards, you will need to share the board with someone you choose. You will need to return the microSD card, the adapter and the board by the end of the semester. Otherwise, you will receive an "F". It's your duty to secure those equipments we handed you.

Objective

1. Get familiar with DE1SoC platform
2. Get familiar with DE1SoC toolchain
3. Learn how to use "vector instructions" to accelerate your program

How to start

Please refer to the TA's tutorial on DE1SoC to make sure you have the board setup correctly.You are encouraged to use the VCL service maintained by NCSU through https://vcl.ncsu.edu/ and create a reservation using the "CSC456: DE1SoC OpenCL Toolchain" image. The TA's tutorial also covers how to use the toolchain inside the image. Don't forget to change the root password of your board.

Then, you may fetch code or fork the repo https://github.ncsu.edu/htseng3/CSC456_S19_HW1 to obtain the codebase of this mini project. You need to compile the device file under the device directory using aoc. You also need to compile the host program by typing make in the directory. 

After you have done the above, you may transfer these files into your DE1SoC through the SDCard or the network. You need to execute "aocl program /dev/acl0 vectorAdd.aocx" to have the on board FPGA programmed for vector_add. Finally, you can play with the "vector_add" program you created.

"vector_add" take an argument (mode) and perform the addition of 100000 vector pairs using 3 different methods:
mode 0 -- traditional add instructions
mode 1 -- using ARM SIMD instructions
mode 2 -- using the FPGA

With the given code, you will find out mode 1 does not give us the right result.

Now, it's your task to modify the host/src/main.cpp file to complete the "vector_run()" function and make mode 1 working.

Your tasks
1. Complete the vector_run() function using NEON Intrinsics. Here are some useful references regarding how to use them

https://static.docs.arm.com/ihi0073/a/IHI0073A_arm_neon_intrinsics_ref.pdf
http://infocenter.arm.com/help/topic/com.arm.doc.dui0472j/chr1359125038862.html
2. Compare the performance of different modes and think about why performance differs

Turnins

A tarball named as "{your_unityid}_hw1.tar.gz" containing the following items

Your completed version of main.cpp
A one-page write-up answers the following questions
Performance comparison: a table lists execution time, speedup (using mode 0 as the baseline) of each mode the excludes the data initialization and result verification.
Is mode 1 faster than mode 0? What is/are the factor(s) affecting the result? Why your changes can affect those factors?
Is mode 2 faster than mode 0? What is/are the factor(s) affecting the result? Why your changes can affect those factors?
Is mode 2 faster than mode 1? What is/are the factor(s) affecting the result? Why your changes can affect those factors?
The list of students sharing the same board with you.
Hints

To complete the "vector_run()" function, you will need to 1. load array values into vector registers 2. use intrinsics to perform adds on vectors. 3. store the result to the output array from vector registers.


How to compile the OpenCL FPGA code:

AOCX selection
--------------

The host program will use an AOCX file in the bin directory. If vectorAdd.aocx
exists, then that will be used. Otherwise, the host program will examine the device
name to extract the board name (which was passed as the --board argument to aoc)
and check for a vectorAdd_<board>_140.aocx file.

Package Contents and Directory Structure
========================================

/vector_add
  /device
     Contains OpenCL kernel source files (.cl)
  /host
    /src
      Contains host source (.cpp) files
  /bin
    Contains host binary and OpenCL binaries (.aocx)


Generating Kernel
=================

To compile the kernel, run:

  aoc device/vectorAdd.cl -o bin/vectorAdd.aocx --board <board>

where <board> matches the board you have in your system. If you are unsure
of the board name, use the following command to list available boards:

  aoc --list-boards

This compilation command can also be used to target the emulator by adding 
the -march=emulator flag.

If the board already has a AOCX file (see AOCX selection section above),
be sure to either replace or relocate that AOCX file.


