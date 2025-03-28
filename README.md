# QASS

QAZ-like for a BAE (Big Ass Enter) and 10u spacebar (7u+8u)

![QASS complete](https://moinboards.de/projects/img/qass14.jpg)

More pictures and infos at [Moinboards](https://moinboards.de/projects/qass/).
[Buildguide](https://moinboards.de/guides/guide-qass/).

There are three versions: normal, lowbar (Miao for FAK-Firmware) and lowbar (Gemini for QMK/Vial). The normal version has the spacebar on the normal PCB. The lowbar uses the PCB as a plate on the bottom row and adds a lower PCB.

- Only the lowbar version was tested and fully finished. Please check the normal version before ordering.
- Lowbar:
  - v1.0 is tested and works with MIAO. XIAO would work as well but the pads on the underside I wanted to use are not GPIOs but only for a special serial protocol. So they cant be used.
  - v1.1 is Untested, but I only made cosmetic changes, so should still work fine.
  - Quark-Works made a fork and changed the MCU to a [Gemini](https://keeb.supply/products/0xcb-gemini) (rp2040 zero compatible). Thanks! You can find it [here](https://github.com/quark-works/QASS-Zero/tree/main).

The latest version has the lower spacebar. Break off the lower part of the PCB and put it under the bottom row. Add headers at the connection points.

![QASS KLE](https://github.com/Technofrikus/QASS/blob/master/QassKLE.png?raw=true)
![Front of PCB](https://github.com/Technofrikus/QASS/blob/master/QASS_PCB%20Lowbar/QASS_PCB%20lowbar%20render%20F.png)
![Back of PCB](https://github.com/Technofrikus/QASS/blob/master/QASS_PCB%20Lowbar/QASS_PCB%20lowbar%20render%20B.png)
![Lowbar PCB render](https://github.com/Technofrikus/QASS/blob/master/QASS_PCB_lowbar_2024-Apr-26_04-36-14PM-000_CustomizedView9718968630.png)

## Case

The 3D-printable case files are included now (March 2025).
Can recommend making the plate from metal. Gives the build more weight and looks nice. Tested with brass and copper. Use the special version to make sure they will not warp during cutting (havent tested it without these, just a precaution).
Print recommendations included, see txt file. 

It is for the low-bar version only.

## BOM

- [Miao MCU(https://keeb.supply/products/miao) (or [Gemini](https://keeb.supply/products/0xcb-gemini), if you use the ~~force~~ [fork](https://github.com/quark-works/QASS-Zero/tree/main))
- 3mm high hotswap headers (2.54mm pitch) and pins (the holes in the PCB are bigger than usual, so only the plastic part of the headers is on the PCB)
- 20x BAV70 diodes
