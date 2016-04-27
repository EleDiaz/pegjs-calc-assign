/*
 * Classic example grammar, which recognizes simple arithmetic expressions like
 * "2*(3+4)". The parser generated from this grammar then computes their value.
 */

/*

  Como controlar la identacion?
  Los identificadores no pueden ser palabras reservadas del lenguaje // esto es importante

*/
{
    var util = require('util');
    var symbolTable = {
        PI: Math.PI
    };

    // :: Int -> [(String, Int)] -> Int
    function foldExpresion(left, rest) {
        return rest.reduce((prod, [op, num]) => { return eval(prod+op+num); },left);
    };

    var ADT = {};
}

start =
    expresion

expresion
    = value:assign {
        console.log(util.inspect(symbolTable,{ depth: null}));
        return value;
    }

    / value:ifthenelse {
        return value;
    }

    / value:additive {
        return value;
    }

assign
    = id:ID ASSIGN a:expresion {
        symbolTable[id] = a;
        return a;
    }

func
    = name:ID param:ID* ASSIGN expresion {
        symbolTable[id] =  {}
    }

ifthenelse
    = IF check:expresion THEN trueExp:expresion ELSE falseExp:expresion {
        if (check) {
            return trueExp;
        }
        else {
            return falseExp;
        }
    }

additive
    = left:multiplicative rest:(ADDOP multiplicative)* { return foldExpresion(left, rest); }
    / value:multiplicative {
        return value;
    }

multiplicative
    = left:primary rest:(MULOP primary)* { return foldExpresion(left, rest); }
    / primary

primary
    = integer
    / id:ID {
        if (symbolTable[id] === undefined) {
            error("Use a variable but NOT is found in symbol table.\n\t"
                  + "Line: " + location().start.line + ", Column: " + location().start.column);
        }
        return symbolTable[id]; }
    /* / id:ID (expresion _)* {  }*/
    / LEFTPAR additive:additive RIGHTPAR { return additive; }

/* A rule can also contain human-readable name that is used in error messages (in our example, only the integer rule has a human-readable name). */
integer "integer"
    = NUMBER

_ = $[ \t\n\r]*

ADDOP = PLUS / MINUS
MULOP = MULT / DIV
PLUS = _"+"_  { return '+'; }
MINUS = _"-"_ { return '-'; }
MULT = _"*"_  { return '*'; }
DIV = _"/"_   { return '/'; }
LEFTPAR = _"("_
RIGHTPAR = _")"_
NUMBER = _ digits:$[0-9]+ _ { return parseInt(digits, 10); }
ID = _ id:$([a-z_]i$([a-z0-9_]i*)) _ { return id; }
ASSIGN = _ '=' _
IF = _ 'if' _
THEN = _ 'then' _
ELSE = _ 'else' _
