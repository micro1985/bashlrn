from random import randint

cort = ("a", "A", "b", "B", "c", "C", "d", "D", "e", "E", "f", "F", "g", "G",
        "h", "H", "i", "I", "j", "J", "k", "K", "l", "L", "m", "M", "n", "N",
        "o", "O", "p", "P", "q", "Q", "r", "R", "s", "S", "t", "T", "u", "U",
        "v", "V", "w", "W", "x", "X", "y", "Y", "z", "Z", "1", "2", "3", "4",
        "5", "6", "7", "8", "9", "0", "!", "@", "#", "$", "%", "^", "&", "*",
        "(", ")")
ps = ""

for i in range(12):
    k = randint(0, len(cort))
    ps += cort[k]

print(ps)

psfile = open("psswd", 'w')
psfile.write(ps)
psfile.close()
