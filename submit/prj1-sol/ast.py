#!/usr/bin/env python3

import re
import sys
from collections import namedtuple
import json

"""
program
  : decl*
  | #empty
  ;
decl
  : dts struct '=' identifier ';'
  ;
dts
  : 'const' | 'let'
  ;
struct
  : identifier
  | array-struct
  | object-struct
  ;SS
array-struct
  : '[' struct (',' struct)* ']'
  ;
object-struct
  : '{' keyStruct (',' keyStruct)* '}'
  ; 
identifier
  : CHAR (CHAR | INT | '_')*
  ;
"""

def parse(text):

    def peek(kind): return lookahead.kind == kind
    def consume(kind):
        nonlocal lookahead
        if (lookahead.kind == kind):
            lookahead = nextToken()
        else:
            print(f'expecting {kind} at {lookahead.lexeme}',
                  file=sys.stderr)
            sys.exit(1)
    def nextToken():
        nonlocal index
        if (index >= len(tokens)):
            return Token('EOF', '<EOF>')
        else:
            tok = tokens[index]
            index += 1
            return tok

    def program():
        asts = []
        while (not peek('EOF')):
            asts.append(decl())
            consume(';')
        return asts

    def decl():
        t = dts()
        s = struct()
        consume('=')
        i = identifier()
        return Ast(t, i, s)   
          
    def dts():
        if peek('const') or peek('let'):
            kind = lookahead.kind
            consume(kind)
            return kind

        else:
            print(f'expecting dts at {lookahead.lexeme}',
                  file=sys.stderr)
            sys.exit(1)

    def struct():
        if (peek('ID')):
            id = str(lookahead.lexeme)
            consume('ID')
            return id
        elif (peek('[')):
            return array_struct()
        elif (peek('{')):
            return object_struct()
        else:
            print(f'expecting struct at {lookahead.lexeme}',
                  file=sys.stderr)
            sys.exit(1)
      
        
    def array_struct():
        consume('[')
        structs = []
        t = struct() # keep getting error try list
        structs.append(t)
        while (peek(',')):
            consume(',')
            t1 = struct()
            structs.append(t1)
            # print(structs)
        
        consume(']')
        return structs

    def object_struct():
        keystruct = {}
        consume('{')
        # keyStructs = [] # change to an object or dictionary
        key = identifier()
        # print(key)
        if (peek(':')):
            consume(':')
            value = struct()
            keystruct[key] = value
            # print(keystruct)
        else:
            keystruct[key] = key
        while (peek(',')):
            consume(',')
            key = identifier()
            if (peek(':')):
                consume(':')
                value = struct()
                keystruct[key] = value
                # print(keystruct)
            else:
                keystruct[key] = key
        consume('}')
        return keystruct
    
    def identifier():
        if (peek('ID')):
            value = str(lookahead.lexeme)
            consume('ID')
            # print(value)
            return value
        else:
            print(f'expecting id at {lookahead.lexeme}',
                  file=sys.stderr)
            sys.exit(1)
        

    #begin parse()
    tokens = scan(text)
    index = 0
    lookahead = nextToken()
    value = program()
    if (not peek('EOF')):
        print(f'expecting <EOF>, got {lookahead.lexeme}', file=sys.stderr)
        sys.exit(1)
    return value

def scan(text):
    SPACE_RE = re.compile(r'\s+|//.*')
    ID_RE = re.compile(r'\w+')
    CONST_RE = re.compile(r'const')
    LET_RE = re.compile(r'let')
    CHAR_RE = re.compile(r'.')
    def next_match(text):
        m = SPACE_RE.match(text)
        if (m): return (m, None)
        m = CONST_RE.match(text)
        if (m): return (m, 'const')
        m = LET_RE.match(text)
        if (m): return (m, 'let')
        m = ID_RE.match(text)
        if (m): return (m, 'ID')
      
        m = CHAR_RE.match(text)  #must be last: match any char
        if (m): return (m, m.group())

    tokens = []
    while (len(text) > 0):
        (match, kind) = next_match(text)
        lexeme = match.group()
        if (kind): tokens.append(Token(kind, lexeme))
        text = text[len(lexeme):]
    return tokens

def main():
    if (len(sys.argv) != 2): usage();
    contents = readFile(sys.argv[1]);
    asts = parse(contents)
    print(json.dumps(asts, separators=(',', ':'))) #no whitespace

def readFile(path):
    with open(path, 'r') as file:
        content = file.read()
    return content


def usage():
    print(f'usage: {sys.argv[0]} DATA_FILE')
    sys.exit(1)

def Ast(decl, id, struct):
    return { 'decl': decl, 'id': id, 'struct': struct }

Token = namedtuple('Token', ['kind', 'lexeme'])

if __name__ == "__main__":
    main()