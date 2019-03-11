from sys import argv
from lglcd import LogitechLcd
from time import sleep

powerplan, gpustate = argv[1].split(' ')
lcd = LogitechLcd('Powerplan Switcher')

lcd.set_text(0, 'Powerplan Switcher')
#lcd.set_text(1, 'Line2')
lcd.set_text(2, '%s Powerplan active' % powerplan)
lcd.set_text(3, 'GPU Perfomance state is %s' % gpustate)
lcd.update()
sleep(10)
