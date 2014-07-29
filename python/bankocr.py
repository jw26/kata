import string

lookupt = {
  " _ | ||_|" : 0, "     |  |" : 1,
  " _  _||_ " : 2, " _  _| _|" : 3,
  "   |_|  |" : 4, " _ |_  _|" : 5,
  " _ |_ |_|" : 6, " _   |  |" : 7,
  " _ |_||_|" : 8, " _ |_| _|" : 9,
}

def lookup(inp):
    return lookupt[inp] if lookupt.has_key(inp) else -1

def parse(text):
    lines = string.split(text, "\n")
    lines = [x for x in lines if x != ""]
    r = []
    for i in range(0, len(lines)-1, 3):
        a = []
        for j in range(0, 9*3, 3):
            char = ""
            char += ''.join(lines[i][j:j+3])
            char += ''.join(lines[i+1][j:j+3])
            char += ''.join(lines[i+2][j:j+3])
            a.append(lookup(char))
        r.append(a)

    return r


def validate(inp):
    add = lambda x, y: x+y
    return reduce(add,[x*y for x, y in zip(range(9,0,-1), inp)]) % 11 == 0

def prepare_for_output(inp):
    qm = lambda x: '?' if x==-1 else str(x)
    r = ''.join(map(qm,inp))
    end = ''
    if not validate(inp):
        end = " ERR"

    if '?' in r:
        end = " ILL"

    return r + end

