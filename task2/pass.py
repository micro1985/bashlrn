from random import randint

a = randint(100000,999999)

psfile = open("psswd", 'w')
psfile.write(str(a))
psfile.close()
