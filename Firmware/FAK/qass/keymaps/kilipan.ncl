let { tap, hold, td, combo, macro, ..} = import "fak/keycode.ncl" in
let util = import "fak/util_functions.ncl" in

###NOT WORKING AT THE MOMENT#####

let virtual_keys' = [
  # alpha
  combo.make 25 [1, 2], # V
  combo.make 25 [2, 3], # Q
  combo.make 25 [22, 23], # Z
  combo.make 25 [1, 3], # SCH
  # sym
  combo.make 25 [28, 29], # SLSH
  combo.make 25 [27, 28], # MINS
  combo.make 25 [28, 33], # SEMI
  combo.make 25 [29, 33], # COLON
  # parentheticals
  combo.make 25 [1, 10],  # {
  combo.make 25 [2, 11], # [
  combo.make 25 [3, 12], # (
  combo.make 25 [4, 13], # <
  combo.make 25 [5, 14], # >
  combo.make 25 [6, 15], # )
  combo.make 25 [7, 16], # ]
  combo.make 25 [8, 17], # }
  # nav
  combo.make 25 [23, 24], # ESC
  combo.make 25 [27, 29], # ENT
  combo.make 25 [6, 7], # BSPC
  combo.make 25 [7, 8], # DEL
  combo.make 25 [6, 8], # C-BSPC
  # caps
  combo.make 25 [14, 17], # caps word
  combo.make 25 [1, 8], # caps lock
] in

let virtual_key_count = std.array.length virtual_keys' in
let key_count = 39 + virtual_key_count in

# convenience aliases
# taps
let kc = tap.reg.kc in
let ks = tap.reg.ks in
let md = tap.reg.mod in
# holds
# let kch = hold.reg.kc in
# let ksh = hold.reg.ks in
let mdh = hold.reg.mod in
# sticky key
let sk = tap.sticky.mod in
# layer control
let lt = hold.reg.layer in
# boot, reset, etc
let fak = tap.custom.fak in
# media and mouse control
let media = tap.custom.media in
let mouse = tap.custom.mouse in
# keymap stuff
let tx = tap.none in
let tt = tap.trans in
let hx = hold.none in
let ht = hold.trans in

let ki = {
  hp = { decision = 'hold, trigger_on = 'press },
  tp = { decision = 'tap, trigger_on = 'press },
  hr = { decision = 'hold, trigger_on = 'release },
  tr = { decision = 'tap, trigger_on = 'release },
  xx = { decision = 'none },
} in

let layouts = {
  APTMAK = "WFPBJLUYRSTHKXNAIOCGDM,.",
} in

let make_hrm = fun key_idx =>
  let htb_hrm_base = fun eager => {
    timeout_ms = 150,
    quick_tap_ms = 100,
    # quick_tap_interrupt_ms = 500,
    # global_quick_tap_ms = 80,
    eager_decision = eager,
    timeout_decision = 'hold,
  } in

  let virtual_interrupts = std.array.replicate virtual_key_count ki.hr in

let make_hrm = fun key_idx =>
  let htb_hrm_base = fun eager => {
    timeout_ms = 150,
    quick_tap_ms = 100,
    # quick_tap_interrupt_ms = 500,
    # global_quick_tap_ms = 80,
    eager_decision = eager,
  } in

  let htb_hrm_left = fun eager => htb_hrm_base eager & {
    key_interrupts = [
      ki.tp, ki.tp, ki.tp, ki.tp, ki.tp,  ki.hr, ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,
      ki.tr, ki.tr, ki.tr, ki.tr, ki.tr,  ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,
      ki.tp, ki.tp, ki.tp, ki.tp, ki.tp,  ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,
      ki.hp, ki.hp, ki.hp, ki.hp, ki.hp,  ki.hp, ki.hp, ki.hp,
    ] @ virtual_interrupts
  } in

  let htb_hrm_right = fun eager => htb_hrm_base eager & {
    key_interrupts = [
      ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,  ki.tp, ki.tp, ki.tp, ki.tp, ki.tp, ki.tp,      
      ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,  ki.tr, ki.tr, ki.tr, ki.tr, ki.tr,
      ki.hr, ki.hr, ki.hr, ki.hr, ki.hr,  ki.tp, ki.tp, ki.tp, ki.tp, ki.tp,
      ki.hp, ki.hp, ki.hp, ki.hp, ki.hp,  ki.hp, ki.hp, ki.hp,
    ] @ virtual_interrupts
  } in

  let hrm_mods = [
    mdh.lctl, mdh.lalt, mdh.lgui, mdh.lsft, mdh.ralt,
    mdh.ralt, mdh.rsft, mdh.rgui, mdh.lalt, mdh.rctl,
  ] in

  let hrm_key_indices = [11, 12, 13, 14, 15, 16, 17, 18, 19, 20] in

  if std.array.elem key_idx hrm_key_indices then
    let mod_idx = util.array.index_of key_idx hrm_key_indices in
    let side = if mod_idx < (std.array.length hrm_mods / 2) then 'left else 'right in
    let mod = std.array.at mod_idx hrm_mods in

    mod & hold.reg.behavior (
      (if side == 'left then htb_hrm_left else htb_hrm_right)
      (if mod == mdh.lgui || mod == mdh.lalt then 'none else 'hold)
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

let bot = fun thumb_idx =>
  let thumb_behavior = {
    timeout_ms = 150,
    timeout_decision = 'hold,
    key_interrupts = std.array.replicate key_count ki.hr,
  } in
  [
    kc.QUOT & lt 1 & hold.reg.behavior thumb_behavior,
    kc.SPC  & lt 2 & hold.reg.behavior thumb_behavior,
    kc.E    & lt 3 & hold.reg.behavior thumb_behavior,
    kc.TAB  & lt 4 & hold.reg.behavior thumb_behavior,    
  ]
  |> std.array.at thumb_idx
in

let cu = {
  # copy custom stuff from example
  COPY = md.lctl & kc.C,
  PSTE = md.lctl & kc.V,
  CUT  = md.lctl & kc.X,
  SCH  = macro.make [
    macro.tap kc.S,
    macro.release mdh.rsft,
    macro.tap kc.C,
    macro.tap kc.H,
  ]
} in

let combos_base = [
  kc.V, kc.Q, kc.Z, cu.SCH,
  kc.SLSH, kc.MINS, kc.SCLN, ks.COLN,
  ks.LCBR, kc.LBRC, ks.LPRN, ks.LABK, ks.RABK, ks.RPRN, kc.RBRC, ks.RCBR,
  kc.ESC, kc.ENT, kc.BSPC, kc.DEL, md.lctl & kc.BSPC,
  fak.CWTG, kc.CAPS_LOCK,
] in

### Keymap itself! ###
{
  virtual_keys = virtual_keys',
  layers = [
    let base = fun key_idx => (alphas layouts.APTMAK) |> std.array.at key_idx in
    # ALPHAS
    [
      base 0,  base 1,  base 2,  base 3,  base 4,  base 5,  base 6,  base 7,  base 8,  base 9, kc.ENTER,
      base 10, base 11, base 12, base 13, base 14, base 15, base 16, base 17, base 18, base 19,
      base 20, base 21, base 22, base 23, base 24, base 25, base 26, base 27, base 28, base 29,
      modsl 0, modsl 1, modsl 2, smolbar, longbar, modsr 0, modsr 1, modsr 2,
    ] @ combos_base,
    # NUM
    [
      tx & hx,    kc.N6,      kc.N5,      kc.N4,      ks.ASTR,      ks.PLUS, kc.N7,   kc.N8,   kc.N9,   tx & hx, kc.ENTER,
      kc.N0 & ht, kc.N3 & ht, kc.N2 & ht, kc.N1 & ht, kc.SLSH & ht, kc.MINS, kc.N4,   kc.N5,   kc.N6,   kc.DOT,
      tx & hx,    kc.N9,      kc.N8,      kc.N7,      tx & hx,      tx & hx, kc.N1,   kc.N2,   kc.N3,   tx & hx,
      modsl 0, modsl 1, modsl 2, smolbar, longbar, modsr 0, modsr 1, modsr 2,
    ] @ combos_base,
    # NAV
    [
      tx & hx,    md.lalt,      kc.UP,        md.lsft,      media.VOLU,   cu.CUT,     cu.COPY,    cu.PSTE,  tt & ht,    tx & hx, kc.ENTER,
      md.lctl,    kc.LEFT & ht, kc.DOWN & ht, kc.RGHT & ht, media.VOLD,   media.MUTE, kc.LEFT,    kc.DOWN,  kc.UP,      kc.RGHT,
      tx & hx,    kc.HOME,      kc.PGDN,      kc.END,       tx & hx,      tx & hx,    kc.HOME,    kc.PGUP,  kc.END,     tx & hx,
      modsl 0, modsl 1, modsl 2, smolbar, longbar, modsr 0, modsr 1, modsr 2,
    ] @ combos_base,
    # SYM
    [
      tx & hx, kc.GRV,  ks.DQUO, kc.P,    tx & hx, tx & hx, kc.BSLS, ks.PIPE, tx & hx, tx & hx, kc.ENTER,
      ks.EXLM, ks.AT,   ks.HASH, ks.DLR,  tx & hx, tx & hx, ks.AMPR, ks.ASTR, ks.PERC, ks.CIRC,
      tx & hx, ks.TILD, kc.QUOT, ks.UNDS, tx & hx, tx & hx, kc.MINS, ks.PLUS, kc.EQL,  tx & hx,
      modsl 0, modsl 1, modsl 2, smolbar, longbar, modsr 0, modsr 1, modsr 2,
    ] @ combos_base,
    # FUN
    [
      tx & hx, fak.BOOT, tt & ht, tt & ht, tt & ht, tt & ht, kc.F7,   kc.F8,   kc.F8,   tx & hx, kc.ENTER,
      tt & ht, kc.F12,   kc.F11,  kc.F10,  tt & ht, tt & ht, kc.F4,   kc.F5,   kc.F6,   tt & ht,
      tx & hx, kc.F9,    kc.F8,   kc.F7,   tx & hx, tx & hx, kc.F1,   kc.F2,   kc.F3,   tx & hx,
      modsl 0, modsl 1, modsl 2, smolbar, longbar, modsr 0, modsr 1, modsr 2,
    ] @ combos_base,
  ]
}
