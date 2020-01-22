from sys import argv
from lglcd import LogitechLcd
from time import sleep

powerplan = argv[1]
lcd = LogitechLcd('Powerplan Switcher')

lcd.set_text(0, 'Powerplan Switcher')
#lcd.set_text(1, 'Line2')
lcd.set_text(2, '%s Powerplan active' % powerplan)
lcd.update()
sleep(2)
