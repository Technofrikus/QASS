let { tap, hold, td, combo, .. } = import "fak/keycode.ncl" in
let util = import "fak/util_functions.ncl" in

# --This Keymap is targeted at macOS---

###NOT WORKING AT THE MOMENT#####

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
  LSTY = md.lsft & kc.Y & hold.reg.behavior, # Left shift hold + Y
  RST- = md.rsft & kc.SLSH & hold.reg.behavior, # Right shift hold + slash
  } in
  
  # 1 tap = play/pause. 2 taps = next track. 3 taps = prev track.
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
  
# --- Combos ---
let virtual_keys' = [
# The first argument is the timeout_ms (up to 255)
# The second argument is the key indices/positions (min 2, max 9 keys)
combo.make 35 [17, 18], # Backspace # Combo activated by the 18th and 19th (j + k on qwerty) physical keys, start counting at 0
combo.make 35 [17, 18, 19], # Backspace word - currently not supported by the software
combo.make 35 [18, 19], # Del
combo.make 35 [0, 1], # TAB
combo.make 35 [11, 12], # ESC
combo.make 35 [21, 22], # Cut
combo.make 35 [22, 23], # Copy
combo.make 35 [23, 24], # Paste
] in  



# --- HRM semi complicated version ---
let key_count = 39 + std.array.length virtual_keys' in

let ki = {
  hp = { decision = 'hold, trigger_on = 'press },
  tp = { decision = 'tap, trigger_on = 'press },
  hr = { decision = 'hold, trigger_on = 'release },
  tr = { decision = 'tap, trigger_on = 'release },
  xx = { decision = 'none },
} in

let make_hrm = fun key_idx =>
let htb_hrm_base = fun eager => {
  timeout_ms = 200,
  quick_tap_ms = 150,
  quick_tap_interrupt_ms = 500,
  global_quick_tap_ms = 80,
  eager_decision = eager,
} in

let htb_hrm_left = fun eager => htb_hrm_base eager & {
  key_interrupts = [
    ki.tp, ki.tp, ki.tp, ki.tp, ki.tp,    ki.hr, ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,
    ki.tr, ki.tr, ki.tr, ki.tr, ki.tp,    ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,
    ki.tp, ki.tp, ki.tp, ki.tp, ki.tp,    ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,
    ki.hp, ki.hp, ki.hp,        ki.hp,    ki.hp,        ki.hp, ki.hp, ki.hp,
  ]
} in

let htb_hrm_right = fun eager => htb_hrm_base eager & {
  key_interrupts = [
    ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,    ki.tp, ki.tp, ki.tp, ki.tp, ki.tp, ki.tp,
    ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,    ki.tp, ki.tr, ki.tr, ki.tr, ki.tr,
    ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,    ki.tp, ki.tp, ki.tp, ki.tp, ki.tp,
    ki.hp, ki.hp, ki.hp,        ki.hp,    ki.hp,        ki.hp, ki.hp, ki.hp,
  ]
} in

 let hrm_mods = 
    let m = [md.lgui, md.lalt, md.lctl, md.lsft] in
    m @ std.array.reverse m
  in

  let hrm_key_indices = [12, 13, 14, 15, 16, 17, 18, 19] in

  if std.array.elem key_idx hrm_key_indices then
    let mod_idx = util.array.index_of key_idx hrm_key_indices in
    let side = if mod_idx < (std.array.length hrm_mods / 2) then 'left else 'right in
    let mod = std.array.at mod_idx hrm_mods in

    mod & hold.reg.behavior (
      (if side == 'left then htb_hrm_left else htb_hrm_right)
      (if mod == md.lalt then 'none else 'hold)
    )
  else
    {}
in

let alphas = fun layout => layout
  |> std.string.characters
  |> util.array.enumerate
  |> std.array.map (
      fun { index, value } => kc."%{value}"
      & make_hrm index
    )
in

let layouts = {
  QWERTY = "QWERTYUIOPASDFGHJKL;ZXCVBNM,./",
  DVORAK = "',.PYFGCRLAOEUIDHTNS;QJKXBMWVZ",
  COLEMAK = "QWFPGJLUY;ARSTDHNEIOZXCVBKM,./",
} in


# --- Actual keymap ----

# Keymap definition for use with BAE and 10u space
# Because of the little available pins of the Miao the matrix is not straight forward at all
# With a QWERTY layout in mind:
# ISO-Enter: M74 = Enter = right of P, M24 = key right of L is also available
# Long Shift: M14 = right most key = Shift (also in short shift), M34 = key below L is unavailble with Long Shift
# ANSI-Enter: M74 = right of P = Backspace, M24 = right of L = Enter
# BA-Enter: M74 = right of P = Enter, M24 = right of L = tap.none, dont use, will also be pressed by the BAE
# Space: 10u = Split right = M43, Split left = M33

{
 virtual_keys = virtual_keys',
 layers = [
    let base = fun key_idx => (alphas layouts.QWERTY) |> std.array.at key_idx in
    [ # layer 0
      base 0, base 1,  base 2,  base 3, base 4, base 5,  base 6,  base 7,  base 8,  base 9,  kc.ENTER,     #0-10
      base 10,base 11, base 12, base 13,base 14,base 15, base 16, base 17, base 18, XXXX,                  #11-20
      base 20,base 21, base 22, base 23,base 24,base 25, base 26, base 27, base 28  kc."/",                #21-30
      XXXX,    XXXX,    XXXX,    XXXX,    space_td,  XXXX,    XXXX,    XXXX,                               #31-38
      
      # Combos start here in the same order we defined them above
      kc.BSPC, #JK
      tm.lalt & kc.BSPC, #JKL 
      kc.DEL,
      kc.TAB,
      kc.ESC,
      cu.CUT,
      cu.COPY,
      cu.PSTE,
    ],
    [ # layer 1
      BOOT,    XXXX,    XXXX,    XXXX,    XXXX,    XXXX,    kc.N7,   kc.N8,   kc.N9,   XXXX,    kc.ENTER,
      md.lgui, md.lalt, md.lctl, md.lsft, XXXX,    XXXX,    kc.N4,   kc.N5,   kc.N6,   XXXX,
      XXXX,    XXXX,    XXXX,    XXXX,    XXXX,    kc.N0,   kc.N1,   kc.N2,   kc.N3,   XXXX,
      XXXX,    XXXX,    XXXX,    TTTT,    XXXX,    XXXX,    XXXX,    XXXX,
      TTTT,
      TTTT,
      TTTT,
      TTTT,
      TTTT,
      TTTT,
      TTTT,
      TTTT,
    ],
  ],
}