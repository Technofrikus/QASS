let { ColToRowKey, .. } = import "fak/keyboard.ncl" in
let { CH552T, .. } = import "fak/mcus.ncl" in

{
  mcu = CH552T,
  matrix = {
    cols = [10, 13, 35, 34, 15, 16, 32, 33],
    rows = [11, 12, 31, 17, 30],
  },
  usb_dev = {
    vendor_id = 0x6D62, # Moinboards ID
    product_id = 0x0455,  # ASS
    product_ver = 1.0, # 0x0100
  },
  keys =
    let M = ColToRowKey in
    # Because of the little available pins of the Miao the matrix is not straight forward at all
    # ISO-Enter: M74 = Enter, M24 = key between L and ISO-Enter
    # Long Shift: M14 = Shift (also in short shift), M34 is unavailble with Long Shift
    # ANSI-Enter: M74 = Backspace, M24 = Enter
    # BA-Enter: M74 = Enter, M24 = tap.none, dont use, will also be pressed by the BAE
    # Space: 10u = Split right = M43, Split left = M33
    [
      M 0 0, M 1 0, M 2 0, M 3 0, M 4 0, M 5 0, M 6 0, M 7 0, M 5 4, M 6 4, M 7 4, 
      M 0 1, M 1 1, M 2 1, M 3 1, M 4 1, M 5 1, M 6 1, M 7 1, M 4 4, M 2 4,
      M 0 2, M 1 2, M 2 2, M 3 2, M 4 2, M 5 2, M 6 2, M 7 2, M 3 4, M 1 4,
      M 0 3, M 1 3, M 2 3, M 3 3, M 4 3, M 5 3, M 6 3, M 7 3,
    ]
}
