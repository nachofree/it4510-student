#usage: python3 ./myHashCracker.py

import hashlib

def crack_MD5_Hash(hash_to_crack, salt, dictionary_file):
    file = open(dictionary_file, "r")
    for password in file:
        salted_password = (salt + password.strip("\n")).encode('UTF-8')
        if hashlib.md5(salted_password).hexdigest() == hash_to_crack:
            return password
    return None

#hash_to_crack = 'c94201dbba5cb49dc3a6876a04f15f75'
#hash_to_crack = 'b1946ac92492d2347c6235b4d2611184'
hash_to_crack = 'a05a1d4f7f800eb9ec3a93cb23a6207b'
salt = '8ff32489f92f33416694be8fdc2d4c22'
dict = "/home/joe/temp/it4510-student/passwords/darkweb2017-top10000.txt"

password = crack_MD5_Hash(hash_to_crack, salt, dict)
print(password)
