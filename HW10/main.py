import random

def main():
    pc = random.randint(1, 100)
    #print(f"Загадал: {pc}")

    x = 1
    print("Угадай число от 1 до 100: ")

    while  x <= 5:
        usr = int (input(f"Попытка {x}/5: "))

        if pc == usr:
            print("Число угадано!"); break
        
        elif pc > usr:
            print("Число преуменьшено.")
            x += 1

        elif pc < usr:
            print("Число приувеличено.")
            x += 1
    else:
         print(f"Попытки исчерпаны. Верное число было: {pc}")
    
main()