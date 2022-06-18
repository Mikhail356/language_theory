import re


class Regex:
    """
    Class implement regular expression from __init__ on any given string
    """

    def __init__(self, reg):
        try:
            self.r = re.compile(reg)
        except re.error as e:
            print(f"Error in regular expression: {e}")
            return None

    def parse(self, string):
        try:
            return self.r.match(string).group()
        except AttributeError:
            return None


class Sequence:
    """
    Class apply sequence of regular expressions to the string. 
    Each new expression apply to part of string that follows 
    after result previous expression.
    """

    def __init__(self, reg1, reg2):
        self.r1 = Regex(reg1)
        self.r2 = Regex(reg2)

    def parse(self, string):
        answer = None

        p1 = self.r1.parse(string)
        if p1:
            p2 = self.r2.parse(string[len(p1):])
            if p2:
                answer = p1+p2
            else:
                answer = p1
        else:
            p2 = self.r2.parse(string)
            if p2:
                answer = p2

        return answer


class KleeneStar:
    """
    Apply Kleene Star parser to string. 
    Regular expression apply to string while it can.
    """

    def __init__(self, reg):
        self.r = Regex(reg)

    def parse(self, string):
        p = self.r.parse(string)

        if p is None:
            return ""
        return p + self.parse(string[len(p):])


class LookAhead:
    """
    For reg1 and reg2 regular expressions
    If reg2 return not None then class return result of work reg1
    """

    def __init__(self, reg1, reg2):
        self.r1 = Regex(reg1)
        self.r2 = Regex(reg2)

    def parse(self, string):
        answer = None

        p1 = self.r1.parse(string)
        if p1:
            if self.r2.parse(string[len(p1):]):
                answer = p1

        return answer


class Composition:
    """
    Class apply reg1 tostring and after apply to result reg2.
    """

    def __init__(self, reg1, reg2):
        self.r1 = Regex(reg1)
        self.r2 = Regex(reg2)

    def parse(self, string):
        answer = None

        p = self.r1.parse(string)
        if p:
            answer = self.r2.parse(p)

        return answer


if __name__ == '__main__':
    print('Tests:\n')

    print('Regex: [a-zA-Z]+    String: "qw123ttt456ss"')
    print(Regex('[a-zA-Z]+').parse('qw123ttt456ss'))

    print('Regex: \d    String: "qw123ttt456ss"')
    print(Regex('\d').parse('qw123ttt456ss'), end='\n\n')

    print('Sequence: "\+"  "-"   String: "+123"')
    print(Sequence('\+', '-').parse('+123'))

    print('Sequence: "\+"  "-"   String: "+123"')
    print(Sequence('\+', '\d').parse('+123'), end='\n\n')

    print('KleeneStar: [a-zA-Z]    String: "asAd"')
    print(KleeneStar('[a-zA-Z]').parse('asAd'))

    print('KleeneStar: [A-Z]    String: "asAd"')
    print(KleeneStar('[A-Z]').parse('asAd'), end='\n\n')

    print('Composition: ".+"  "[a-z]"   String: "abcd243286"')
    print(Composition('.+', '[a-z]').parse('abcd243286'))

    print('Composition: ".+"  "\d"   String: "abcd243286"')
    print(Composition('.+', '\d').parse('abcd243286'), end='\n\n')

    print('LookAhead: "[a-z]"  "[A-Z]"   String: "aAda"')
    print(LookAhead('[a-z]', '[A-Z]').parse('aAda'))

    print('LookAhead: "\d"  "[A-Z]"   String: "aAda"')
    print(LookAhead('\d', '[A-Z]').parse('aAda'), end='\n\n')
