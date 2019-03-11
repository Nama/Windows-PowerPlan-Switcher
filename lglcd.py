from ctypes import *
from ctypes.wintypes import *
from time import sleep

# for monochrome LCD
# Color LCD Function is not implemented.

LOGI_LCD_TYPE_MONO = 0x00000001
LOGI_LCD_TYPE_COLOR = 0x00000002

LOGI_LCD_MONO_BUTTON_0 = 0x00000001
LOGI_LCD_MONO_BUTTON_1 = 0x00000002
LOGI_LCD_MONO_BUTTON_2 = 0x00000004
LOGI_LCD_MONO_BUTTON_3 = 0x00000008

LOGI_LCD_MONO_WIDTH = 160
LOGI_LCD_MONO_HEIGHT = 43


class LogitechLcd(object):
    def __init__(self, name, lcd_type=LOGI_LCD_TYPE_MONO):
        self.Lcd = cdll.LogitechLcd
        self.Lcd.LogiLcdInit(c_wchar_p(name), c_int(lcd_type))

    # Generic Functions
    def is_connected(self, lcd_type=LOGI_LCD_TYPE_MONO):
        return bool(self.Lcd.LogiLcdIsConnected(c_int(lcd_type)))

    def is_button_pressed(self, button):
        return bool(self.Lcd.LogiLcdIsButtonPressed(c_int(button)))

    def update(self):
        self.Lcd.LogiLcdUpdate()

    def shutdown(self):
        self.Lcd.LogiLcdShutdown()

    # Monochrome Lcd Functions
    def set_background(self, mono_bitmap):
        lcd_bitmap = BYTE * (LOGI_LCD_MONO_WIDTH * LOGI_LCD_MONO_HEIGHT)
        bm = lcd_bitmap(*mono_bitmap)
        return bool(self.Lcd.LogiLcdMonoSetBackground(bm))

    def set_text(self, line, text):
        return bool(self.Lcd.LogiLcdMonoSetText(c_int(line), c_wchar_p(text)))

if __name__ == '__main__':
    lcd = LogitechLcd('object')
    lcd.set_text(0, 'Line1')
    lcd.set_text(1, 'Line2')
    lcd.set_text(2, 'Line3')
    lcd.set_text(3, 'Line4')
