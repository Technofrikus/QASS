# let { tap, hold, .. } = import "fak/keycode.ncl" in
let { tap, hold, td, combo, macro, ..} = import "fak/keycode.ncl" in

let kc = tap.reg.kc in
let md = tap.reg.mod in
let MO = hold.reg.layer in
let BOOT = tap.custom.fak.BOOT in
let XXXX = tap.none & hold.none in
let TTTT = tap.trans & hold.trans in

# Keymap definition for testing and very basic use
# Because of the little available pins of the Miao the matrix is not straight forward at all
# With a QWERTY layout in mind:
# ISO-Enter: M74 = Enter = right of P, M24 = key right of L is also available
# Long Shift: M14 = right most key = Shift (also in short shift), M34 = key below L is unavailble with Long Shift
# ANSI-Enter: M74 = right of P = Backspace, M24 = right of L = Enter
# BA-Enter: M74 = right of P = Enter, M24 = right of L = tap.none, dont use, will also be pressed by the BAE
# Space: 10u = Split right = M43, Split left = M33
{
  layers = [
    [
      kc.Q,    kc.W,    kc.E,    kc.R,    kc.T,    kc.Y,    kc.U,    kc.I,    kc.O,    kc.P,    kc.ENTER,
      kc.A,    kc.S,    kc.D,    kc.F,    kc.G,    kc.H,    kc.J,    kc.K,    kc.L,    kc.BSPC,
      kc.Z,    kc.X,    kc.C,    kc.V,    kc.B,    kc.N,    kc.M,    kc.",",  kc.".",  kc."/",
      md.lctl, md.lgui, md.lalt, kc.S,    kc." ",  md.ralt, md.rgui, md.rctl,
    ],
    [
      BOOT,    XXXX,    XXXX,    XXXX,    XXXX,    XXXX,    kc.N7,   kc.N8,   kc.N9,   XXXX,    kc.ENTER,
      md.lgui, md.lalt, md.lctl, md.lsft, XXXX,    XXXX,    kc.N4,   kc.N5,   kc.N6,   XXXX,
      XXXX,    XXXX,    XXXX,    XXXX,    XXXX,    kc.N0,   kc.N1,   kc.N2,   kc.N3,   XXXX,
      XXXX,    XXXX,    XXXX,    TTTT,    XXXX,    XXXX,    XXXX,    XXXX,
    ],
  ],
}