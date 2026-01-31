let { tap, hold, td, combo, .. } = import "fak/keycode.ncl" in

# --This Keymap is targeted at macOS---

# We alias commonly used stuff, so we don't end up repeating them over and over.
let kc = tap.reg.kc in
let ks = tap.reg.ks in
let md = hold.reg.mod in
let tm = tap.reg.mod in
let me = tap.custom.media in
let MO = hold.reg.layer in
let BOOT = tap.custom.fak.BOOT in
let XXXX = tap.none & hold.none in
let TTTT = tap.trans & hold.trans in

# "cu" for custom keys. This is just a name, so it can be whatever you want.
let cu = {
  # Again, these are just names. They don't have to be 4-letter or capitalized.
  COPY = tm.lgui & kc.C,
  PSTE = tm.lgui & kc.V,
  CUT =  tm.lgui & kc.X,
  CLOS = tm.lgui & kc.Q,
  VOLU = tm.lalt & tm.lsft & me.VOLU, #fine grain volume for macOS
  VOLD = tm.lalt & tm.lsft & me.VOLD, #fine grain volume for macOS
  SCSH = tm.lctl & kc.E, # Screenshot
  LSTZ = md.lsft & kc.Z & hold.reg.behavior{timeout_ms = 300}, # Left shift hold + Z
  RST- = md.rsft & kc.SLSH & hold.reg.behavior{timeout_ms = 300}, # Right shift hold + slash
  HHHH = kc.H & md.lgui & hold.reg.kc.H & hold.reg.behavior{timeout_ms = 300}, # H, Cmd+H when held
  } in

# --- Combos ---
# Key position for the combos
  let virtual_keys' = [
  # The first argument is the timeout_ms (up to 255)
  # The second argument is the key indices/positions (min 2, max 9 keys)
  combo.make 35 [17, 18],       # Backspace, Combo activated by the 18th and 19th (j + k on qwerty) physical keys, start counting at 0
  combo.make 35 [17, 18, 19],   # Backspace word
  combo.make 35 [18, 19],       # Delete
  combo.make 35 [0, 1],         # TAB
  combo.make 35 [11, 12],       # ESC
  combo.make 35 [21, 22],       # Cut
  combo.make 35 [22, 23],       # Copy
  combo.make 35 [23, 24],       # Paste
  ] in  
  
# keymap for the combos, same order as above
let combos = [
      kc.BSPC, #JK
      tm.lalt & kc.BSPC, #JKL - not yet working in FAK
      kc.DEL,  #KL
      kc.TAB,  #QW
      kc.ESC,  #AS
      cu.CUT,  #YX
      cu.COPY, #XC
      cu.PSTE, #CV
  ] in
  

# define short aliases for the different hold-tap-behaviors
let ki = {
  hp = { decision = 'hold, trigger_on = 'press },
  tp = { decision = 'tap, trigger_on = 'press },
  hr = { decision = 'hold, trigger_on = 'release },
  tr = { decision = 'tap, trigger_on = 'release },
  xx = { decision = 'none },
} in

let virtual_key_count = std.array.length virtual_keys' in
let key_count = 39 + virtual_key_count in
let virtual_interrupts = std.array.replicate virtual_key_count ki.hr in

# define HomeRowMod behavior, more details here: https://github.com/semickolon/fak/?tab=readme-ov-file#complex-hold-tap-behaviors
# left and right behavior defined sepirately so we have positional hold-tap so we dont have misfires when rolling two keys
let hrm_left = { 
  timeout_ms = 150,          # Known as tapping term in QMK and ZMK. 200 by default.
  # quick_tap_ms = 100,
  # quick_tap_interrupt_ms = 500,
  # global_quick_tap_ms = 80,
  timeout_decision = 'hold,
  # key interrupts defining what the key with this behavior does when pressed together with the key in this "keymap"
  key_interrupts = [     
    ki.tp, ki.tp, ki.tp, ki.tp, ki.tp,      ki.hr, ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,        #0-10
    ki.tr, ki.tr, ki.tr, ki.tr, ki.tp,      ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,               #11-20
    ki.tp, ki.tp, ki.tp, ki.tp, ki.tp,      ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,               #21-30
           ki.hr, ki.hr, ki.hr, ki.hr,      ki.hr, ki.hr, ki.hr, ki.hr,                      #31-38
  ] @ virtual_interrupts
} in

let hrm_right = { 
  timeout_ms = 150,          # Known as tapping term in QMK and ZMK. 200 by default.
  # quick_tap_ms = 100,
  # quick_tap_interrupt_ms = 500,
  # global_quick_tap_ms = 80,
  timeout_decision = 'hold,
  # key interrupts defining what the key with this behavior does when pressed together with the key in this "keymap"
  key_interrupts = [     
    ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,      ki.tp, ki.tp, ki.tp, ki.tp, ki.tp, ki.tp,        #0-10
    ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,      ki.tp, ki.tr, ki.tr, ki.tr, ki.tr,               #11-20
    ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,      ki.tp, ki.tp, ki.tp, ki.tp, ki.tp,               #21-30
           ki.hr, ki.hr, ki.hr, ki.hr,      ki.hr, ki.hr, ki.hr, ki.hr,                      #31-38
  ] @ virtual_interrupts
} in
  
 # HomeRowMods
 let hrm = {
 A = md.lsft & kc.A & hold.reg.behavior hrm_left, #Home Row Mod A
 S = md.lctl & kc.S & hold.reg.behavior hrm_left, #Home Row Mod A
 D = md.lalt & kc.D & hold.reg.behavior hrm_left, #Home Row Mod A
 F = md.lgui & kc.F & hold.reg.behavior hrm_left, #Home Row Mod A
 J = md.rgui & kc.J & hold.reg.behavior hrm_right, #Home Row Mod A
 K = md.ralt & kc.K & hold.reg.behavior hrm_right, #Home Row Mod A
 L = md.rctl & kc.L & hold.reg.behavior hrm_right, #Home Row Mod A
 BAE = MO 2 & kc.ENTER & hold.reg.behavior hrm_right, #Home Row Mod A
 } in  
  
  # Tapdance for media: 1 tap = play/pause. 2 taps = next track. 3 taps = prev track.
  let play_td = td.make 200 [
    me.PLAY,
    me.NEXT,
    me.PREV,
  ] in

  # The following keycode is a hold-tap, since it has a tap and a hold portion
  # Important: All hold-taps need to have a behavior bound with `hold.reg.behavior`
  let space_td = 
  tap.reg.kc.SPC
  & hold.reg.layer 1
  & hold.reg.behavior {
    timeout_ms = 150
    # This will resolve as a hold after 150ms regardless of other keys pressed.
    # However, if released before the 150ms is up, it will resolve as a tap.
  }
  in

# Keymap definition
{
virtual_keys = virtual_keys',
  layers = [
    [ # layer 0
      kc.Q,    kc.W,    kc.E,    kc.R,    kc.T,    kc.Y,    kc.U,    kc.I,    kc.O,    kc.P,   XXXX,            #0-10
      hrm.A,    hrm.S,    hrm.D,    hrm.F,    kc.G,    kc.H,    hrm.J,    hrm.K,    hrm.L,    hrm.BAE,          #11-20
      cu.LSTZ,    kc.X,    kc.C,    kc.V,    kc.B,    kc.N,    kc.M,    kc.",",  kc.".",  cu.RST-,              #21-30
      XXXX,    XXXX,    XXXX,    XXXX,    space_td,  XXXX,    XXXX,    XXXX,                                    #31-38
    ] @ combos,
    [ # layer 1
      XXXX,    XXXX,    XXXX,    XXXX,    XXXX,    kc.KP_PLUS,    kc.KP_MINUS,   kc.KP_ASTERISK, kc.KP_SLASH,   XXXX,    XXXX,
      kc.N1,  kc.N2,   kc.N3,   kc.N4,   kc.N5,   kc.N6,    kc.N7,   kc.N8,   kc.N9,   kc.N0,
      XXXX,    XXXX,    XXXX,    XXXX,    XXXX,    XXXX,   XXXX,   XXXX,   XXXX,   XXXX,
      XXXX,    XXXX,    XXXX,    XXXX,    TTTT,    XXXX,    XXXX,    XXXX,
    ] @ combos,
   [ # layer 2
      BOOT,    XXXX,    XXXX,    XXXX,    XXXX,    XXXX,kc.LEFT & tm.lalt,kc.UP,kc.RIGHT & tm.lalt,   XXXX,    XXXX,
      XXXX,    XXXX,    XXXX,    XXXX,    XXXX,    XXXX,    kc.LEFT, kc.DOWN, kc.RIGHT, TTTT,
      XXXX,    XXXX,    XXXX,    XXXX,    XXXX,    XXXX,    XXXX,    XXXX,    XXXX,    XXXX,
      XXXX,    XXXX,    XXXX,    TTTT,    XXXX,    XXXX,    XXXX,    XXXX,
    ] @ combos,
  ],
}