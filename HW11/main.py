class Alphabet:

    def __init__(self, lang, letters):
        self.lang = lang
        self.letters = letters
    
    def printt(self):  # в задании требуется назвать print. но будет конфликт имен. можно через "builtins.print()" внутри метода
        for n in self.letters:
            print(f"Литеры алфавита {self.lang} -- {n} ") # или builtins.print(...) -- 
        
    def letters_num(self):
        return len(self.letters)


cnucok = Alphabet("en", ["a", "b", "c"])
cnucok.printt()
kolvo = cnucok.letters_num(); print(kolvo)


class EngAlphabet(Alphabet):
    _letters_num = 26
    def __init__(self):
        super().__init__("en", ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"])
        
    def is_en_letter (self, bukva):
        if (bukva in self.letters):
            print(f"Буква {bukva} пренадлежит алфавиту" )
        else:
            print(f"Буква {bukva} не пренадлежит алфавиту")

    def letters_num(self):
        return EngAlphabet._letters_num

    @staticmethod 
    def example():
        return "Text for example"
        

bukva = EngAlphabet()

bukva.is_en_letter ("f")
bukva.is_en_letter ("щ")

bukva.printt()
print(bukva.letters_num())

print(EngAlphabet.example())