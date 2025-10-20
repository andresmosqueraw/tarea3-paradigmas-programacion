declare

% ===========================================
% EXPRESSION TYPES (Functional Approach)
% ===========================================

% Expression types as atoms: num, sum, difference, multiplication, modulo

% ===========================================
% PRINT FUNCTIONS
% ===========================================

% ExpPrint : Int -> Unit
proc {ExpPrint I}
    {System.showInfo I}
end

% PrintSum : Int Int -> Unit
proc {PrintSum Left Right}
    {System.showInfo Left # " + " # Right}
end

% PrintDifference : Int Int -> Unit
proc {PrintDifference Left Right}
    {System.showInfo Left # " - " # Right}
end

% PrintMultiplication : Int Int -> Unit
proc {PrintMultiplication Left Right}
    {System.showInfo Left # " * " # Right}
end

% PrintModulo : Int Int -> Unit
proc {PrintModulo Left Right}
    {System.showInfo Left # " mod " # Right}
end

% ===========================================
% EVALUATION FUNCTIONS
% ===========================================

% ExpEval : Int -> Int
fun {ExpEval num I}
    I
end

% EvalSum : Int Int -> Int
fun {EvalSum Left Right}
    Left + Right
end

% EvalDifference : Int Int -> Int
fun {EvalDifference Left Right}
    Left - Right
end

% EvalMultiplication : Int Int -> Int
fun {EvalMultiplication Left Right}
    Left * Right
end

% EvalModulo : Int Int -> Int
fun {EvalModulo Left Right}
    Left mod Right
end

% ===========================================
% TO STRING FUNCTIONS
% ===========================================

% Number to word conversion (up to 999)
fun {NumberToWord N}
    if N < 0 then
        "negative " # {NumberToWord ~N}
    elseif N == 0 then
        "zero"
    elseif N < 10 then
        {GetDigitWord N}
    elseif N < 20 then
        {GetTeenWord N}
    elseif N < 100 then
        local Tens Ones in
            Tens = N div 10
            Ones = N mod 10
            if Ones == 0 then
                {GetTensWord Tens}
            else
                {GetTensWord Tens} # "-" # {GetDigitWord Ones}
            end
        end
    elseif N < 1000 then
        local Hundreds Rest in
            Hundreds = N div 100
            Rest = N mod 100
            if Rest == 0 then
                {GetDigitWord Hundreds} # " hundred"
            else
                {GetDigitWord Hundreds} # " hundred " # {NumberToWord Rest}
            end
        end
    else
        {IntToString N}
    end
end

% Helper functions for number to word conversion
fun {GetDigitWord N}
    case N of 0 then "zero"
    [] 1 then "one"
    [] 2 then "two"
    [] 3 then "three"
    [] 4 then "four"
    [] 5 then "five"
    [] 6 then "six"
    [] 7 then "seven"
    [] 8 then "eight"
    [] 9 then "nine"
    else {IntToString N}
    end
end

fun {GetTeenWord N}
    case N of 10 then "ten"
    [] 11 then "eleven"
    [] 12 then "twelve"
    [] 13 then "thirteen"
    [] 14 then "fourteen"
    [] 15 then "fifteen"
    [] 16 then "sixteen"
    [] 17 then "seventeen"
    [] 18 then "eighteen"
    [] 19 then "nineteen"
    else {IntToString N}
    end
end

fun {GetTensWord N}
    case N of 2 then "twenty"
    [] 3 then "thirty"
    [] 4 then "forty"
    [] 5 then "fifty"
    [] 6 then "sixty"
    [] 7 then "seventy"
    [] 8 then "eighty"
    [] 9 then "ninety"
    else {IntToString N}
    end
end

% ExpToString : Int -> String
fun {ExpToString num I}
    {NumberToWord I}
end

% ToStringSum : Int Int -> String
fun {ToStringSum Left Right}
    {NumberToWord Left} # " plus " # {NumberToWord Right}
end

% ToStringDifference : Int Int -> String
fun {ToStringDifference Left Right}
    {NumberToWord Left} # " minus " # {NumberToWord Right}
end

% ToStringMultiplication : Int Int -> String
fun {ToStringMultiplication Left Right}
    {NumberToWord Left} # " times " # {NumberToWord Right}
end

% ToStringModulo : Int Int -> String
fun {ToStringModulo Left Right}
    {NumberToWord Left} # " modulo " # {NumberToWord Right}
end

% ===========================================
% EXPRESSION REPRESENTATION
% ===========================================

% Expression = num(Int) | sum(Expression Expression) | difference(Expression Expression) | 
%              multiplication(Expression Expression) | modulo(Expression Expression)

% ===========================================
% EVALUATION WITH EXPRESSIONS
% ===========================================

% EvalExpression : Expression -> Int
fun {EvalExpression Expr}
    case Expr of num(I) then
        {ExpEval num I}
    [] sum(Left Right) then
        {EvalSum {EvalExpression Left} {EvalExpression Right}}
    [] difference(Left Right) then
        {EvalDifference {EvalExpression Left} {EvalExpression Right}}
    [] multiplication(Left Right) then
        {EvalMultiplication {EvalExpression Left} {EvalExpression Right}}
    [] modulo(Left Right) then
        {EvalModulo {EvalExpression Left} {EvalExpression Right}}
    end
end

% ===========================================
% PRINTING WITH EXPRESSIONS
% ===========================================

% PrintExpression : Expression -> Unit
proc {PrintExpression Expr}
    case Expr of num(I) then
        {ExpPrint I}
    [] sum(Left Right) then
        {PrintSum {EvalExpression Left} {EvalExpression Right}}
    [] difference(Left Right) then
        {PrintDifference {EvalExpression Left} {EvalExpression Right}}
    [] multiplication(Left Right) then
        {PrintMultiplication {EvalExpression Left} {EvalExpression Right}}
    [] modulo(Left Right) then
        {PrintModulo {EvalExpression Left} {EvalExpression Right}}
    end
end

% ===========================================
% TO STRING WITH EXPRESSIONS
% ===========================================

% ToStringExpression : Expression -> String
fun {ToStringExpression Expr}
    case Expr of num(I) then
        {ExpToString num I}
    [] sum(Left Right) then
        {ToStringSum {EvalExpression Left} {EvalExpression Right}}
    [] difference(Left Right) then
        {ToStringDifference {EvalExpression Left} {EvalExpression Right}}
    [] multiplication(Left Right) then
        {ToStringMultiplication {EvalExpression Left} {EvalExpression Right}}
    [] modulo(Left Right) then
        {ToStringModulo {EvalExpression Left} {EvalExpression Right}}
    end
end

% ===========================================
% TEST FUNCTIONS
% ===========================================

% Test basic operations
proc {TestBasic}
    {System.showInfo "=== TESTING BASIC OPERATIONS ==="}
    
    local
        % Test numbers
        N1 = num(3)
        N2 = num(4)
        N3 = num(2)
        N4 = num(7)
        N5 = num(0)
        N6 = num(1)
        N7 = num(9)
        N8 = num(10)
        N9 = num(15)
        N10 = num(~5)
        
        % Test operations
        S = sum(N1 N2)  % 3 + 4
        D = difference(N4 N3)  % 7 - 2
        M = multiplication(N1 N2)  % 3 * 4
        Mod = modulo(N4 N3)  % 7 mod 2
    in
        {System.showInfo "\nTesting number evaluation:"}
        {System.showInfo "3 = " # {EvalExpression N1}}
        {System.showInfo "4 = " # {EvalExpression N2}}
        {System.showInfo "0 = " # {EvalExpression N5}}
        {System.showInfo "-5 = " # {EvalExpression N10}}
        
        {System.showInfo "\nTesting number toString:"}
        {System.showInfo "3 -> " # {ToStringExpression N1}}
        {System.showInfo "0 -> " # {ToStringExpression N5}}
        {System.showInfo "9 -> " # {ToStringExpression N7}}
        {System.showInfo "15 -> " # {ToStringExpression N9}}
        {System.showInfo "-5 -> " # {ToStringExpression N10}}
        
        {System.showInfo "\nTesting operations:"}
        {System.showInfo "3 + 4 = " # {EvalExpression S}}
        {System.showInfo "7 - 2 = " # {EvalExpression D}}
        {System.showInfo "3 * 4 = " # {EvalExpression M}}
        {System.showInfo "7 mod 2 = " # {EvalExpression Mod}}
        
        {System.showInfo "\nTesting operation toString:"}
        {System.showInfo "3 + 4 -> " # {ToStringExpression S}}
        {System.showInfo "7 - 2 -> " # {ToStringExpression D}}
        {System.showInfo "3 * 4 -> " # {ToStringExpression M}}
        {System.showInfo "7 mod 2 -> " # {ToStringExpression Mod}}
    end
end

% Test complex expressions
proc {TestComplex}
    {System.showInfo "\n=== TESTING COMPLEX EXPRESSIONS ==="}
    
    local
        N1 = num(3)
        N2 = num(4)
        N3 = num(2)
        N4 = num(7)
        N6 = num(1)
        
        % Complex expressions
        Complex1 = multiplication(sum(N1 N2) N3)  % (3 + 4) * 2
        Complex2 = sum(difference(N4 N3) multiplication(N1 N2))  % (7 - 2) + (3 * 4)
        Complex3 = multiplication(modulo(N4 N3) N1)  % (7 mod 2) * 3
        
        % Deep nesting
        Deep1 = sum(Complex1 N6)  % ((3 + 4) * 2) + 1
    in
        {System.showInfo "\nComplex expression: (3 + 4) * 2"}
        {System.showInfo "Result: " # {EvalExpression Complex1}}
        {System.showInfo "ToString: " # {ToStringExpression Complex1}}
        
        {System.showInfo "\nComplex expression: (7 - 2) + (3 * 4)"}
        {System.showInfo "Result: " # {EvalExpression Complex2}}
        {System.showInfo "ToString: " # {ToStringExpression Complex2}}
        
        {System.showInfo "\nComplex expression: (7 mod 2) * 3"}
        {System.showInfo "Result: " # {EvalExpression Complex3}}
        {System.showInfo "ToString: " # {ToStringExpression Complex3}}
        
        {System.showInfo "\nDeep nesting: ((3 + 4) * 2) + 1"}
        {System.showInfo "Result: " # {EvalExpression Deep1}}
        {System.showInfo "ToString: " # {ToStringExpression Deep1}}
    end
end

% Test edge cases
proc {TestEdgeCases}
    {System.showInfo "\n=== TESTING EDGE CASES ==="}
    
    local
        N1 = num(3)
        N5 = num(0)
        N10 = num(~5)
        
        % Operations with zero
        S_zero = sum(N1 N5)  % 3 + 0
        M_zero = multiplication(N1 N5)  % 3 * 0
        
        % Operations with negative numbers
        S_neg = sum(N1 N10)  % 3 + (-5)
        D_neg = difference(N1 N10)  % 3 - (-5)
        
        % Same operands
        N_same1 = num(3)
        N_same2 = num(3)
        
        S_same = sum(N_same1 N_same2)  % 3 + 3
        D_same = difference(N_same1 N_same2)  % 3 - 3
        M_same = multiplication(N_same1 N_same2)  % 3 * 3
        Mod_same = modulo(N_same1 N_same2)  % 3 mod 3
    in
        {System.showInfo "\n3 + 0 = " # {EvalExpression S_zero}}
        {System.showInfo "3 * 0 = " # {EvalExpression M_zero}}
        
        {System.showInfo "\n3 + (-5) = " # {EvalExpression S_neg}}
        {System.showInfo "3 - (-5) = " # {EvalExpression D_neg}}
        
        {System.showInfo "\n3 + 3 = " # {EvalExpression S_same}}
        {System.showInfo "3 - 3 = " # {EvalExpression D_same}}
        {System.showInfo "3 * 3 = " # {EvalExpression M_same}}
        {System.showInfo "3 mod 3 = " # {EvalExpression Mod_same}}
    end
end

% Test large numbers
proc {TestLargeNumbers}
    {System.showInfo "\n=== TESTING LARGE NUMBERS ==="}
    
    local
        N_large1 = num(100)
        N_large2 = num(50)
        S_large = sum(N_large1 N_large2)  % 100 + 50
        
        N_larger1 = num(1000)
        N_larger2 = num(500)
        S_larger = sum(N_larger1 N_larger2)  % 1000 + 500
    in
        {System.showInfo "\n100 + 50 = " # {EvalExpression S_large}}
        {System.showInfo "ToString: " # {ToStringExpression S_large}}
        
        {System.showInfo "\n1000 + 500 = " # {EvalExpression S_larger}}
        {System.showInfo "ToString: " # {ToStringExpression S_larger}}
    end
end

% Test number to word edge cases
proc {TestNumberToWord}
    {System.showInfo "\n=== TESTING NUMBER TO WORD EDGE CASES ==="}
    
    local
        N5 = num(0)
        N6 = num(1)
        N7 = num(9)
        N8 = num(10)
        N9 = num(15)
        N10 = num(~5)
    in
        {System.showInfo "\nTesting 0:"}
        {System.showInfo "0 -> " # {ToStringExpression N5}}
        
        {System.showInfo "\nTesting 1:"}
        {System.showInfo "1 -> " # {ToStringExpression N6}}
        
        {System.showInfo "\nTesting 9:"}
        {System.showInfo "9 -> " # {ToStringExpression N7}}
        
        {System.showInfo "\nTesting 10 (should use IntToString):"}
        {System.showInfo "10 -> " # {ToStringExpression N8}}
        
        {System.showInfo "\nTesting 15 (should use IntToString):"}
        {System.showInfo "15 -> " # {ToStringExpression N9}}
        
        {System.showInfo "\nTesting negative number:"}
        {System.showInfo "-5 -> " # {ToStringExpression N10}}
    end
end

% Test edge cases for operations
proc {TestOperationEdgeCases}
    {System.showInfo "\n=== TESTING OPERATION EDGE CASES ==="}
    
    local
        N1 = num(3)
        N4 = num(7)
        N5 = num(0)
        N6 = num(1)
        N10 = num(~5)
        
        % Sum with zero
        S_zero = sum(N1 N5)  % 3 + 0
        
        % Multiplication with zero
        M_zero = multiplication(N1 N5)  % 3 * 0
        
        % Sum with negative
        S_neg = sum(N1 N10)  % 3 + (-5)
        
        % Difference with negative
        D_neg = difference(N1 N10)  % 3 - (-5)
        
        % Modulo with 1
        Mod_one = modulo(N4 N6)  % 7 mod 1
        
        % Modulo with same number
        Mod_same = modulo(N4 N4)  % 7 mod 7
    in
        {System.showInfo "\nSum with zero: 3 + 0"}
        {System.showInfo "Result: " # {EvalExpression S_zero}}
        {System.showInfo "ToString: " # {ToStringExpression S_zero}}
        
        {System.showInfo "\nMultiplication with zero: 3 * 0"}
        {System.showInfo "Result: " # {EvalExpression M_zero}}
        {System.showInfo "ToString: " # {ToStringExpression M_zero}}
        
        {System.showInfo "\nSum with negative: 3 + (-5)"}
        {System.showInfo "Result: " # {EvalExpression S_neg}}
        {System.showInfo "ToString: " # {ToStringExpression S_neg}}
        
        {System.showInfo "\nDifference with negative: 3 - (-5)"}
        {System.showInfo "Result: " # {EvalExpression D_neg}}
        {System.showInfo "ToString: " # {ToStringExpression D_neg}}
        
        {System.showInfo "\nModulo with 1: 7 mod 1"}
        {System.showInfo "Result: " # {EvalExpression Mod_one}}
        {System.showInfo "ToString: " # {ToStringExpression Mod_one}}
        
        {System.showInfo "\nModulo with same number: 7 mod 7"}
        {System.showInfo "Result: " # {EvalExpression Mod_same}}
        {System.showInfo "ToString: " # {ToStringExpression Mod_same}}
    end
end

% Test base expression functionality
proc {TestBaseExpression}
    {System.showInfo "\n=== TESTING BASE EXPRESSION FUNCTIONALITY ==="}
    
    local
        BaseExpr = num(5)
    in
        {System.showInfo "\nBase Expression print:"}
        {PrintExpression BaseExpr}
        {System.showInfo "\nBase Expression toString:"}
        {System.showInfo "ToString: " # {ToStringExpression BaseExpr}}
    end
end

% Test all operations with same operands
proc {TestSameOperands}
    {System.showInfo "\n=== TESTING ALL OPERATIONS WITH SAME OPERANDS (3, 3) ==="}
    
    local
        N_same1 = num(3)
        N_same2 = num(3)
        
        S_same = sum(N_same1 N_same2)  % 3 + 3
        D_same = difference(N_same1 N_same2)  % 3 - 3
        M_same = multiplication(N_same1 N_same2)  % 3 * 3
        Mod_same2 = modulo(N_same1 N_same2)  % 3 mod 3
    in
        {System.showInfo "\n3 + 3"}
        {System.showInfo "Result: " # {EvalExpression S_same}}
        {System.showInfo "ToString: " # {ToStringExpression S_same}}
        
        {System.showInfo "\n3 - 3"}
        {System.showInfo "Result: " # {EvalExpression D_same}}
        {System.showInfo "ToString: " # {ToStringExpression D_same}}
        
        {System.showInfo "\n3 * 3"}
        {System.showInfo "Result: " # {EvalExpression M_same}}
        {System.showInfo "ToString: " # {ToStringExpression M_same}}
        
        {System.showInfo "\n3 mod 3"}
        {System.showInfo "Result: " # {EvalExpression Mod_same2}}
        {System.showInfo "ToString: " # {ToStringExpression Mod_same2}}
    end
end

% Test larger numbers than 999
proc {TestLargerNumbers}
    {System.showInfo "\n=== TESTING LARGER NUMBERS THAN 999 ==="}
    
    local
        N_larger1 = num(1000)
        N_larger2 = num(500)
        S_larger = sum(N_larger1 N_larger2)  % 1000 + 500
    in
        {System.showInfo "\nLarger numbers: 1000 + 500"}
        {System.showInfo "Result: " # {EvalExpression S_larger}}
        {System.showInfo "ToString: " # {ToStringExpression S_larger}}
    end
end

% ===========================================
% MAIN TEST SUITE
% ===========================================

proc {RunAllTests}
    {System.showInfo "=== FUNCTIONAL PROGRAMMING TEST SUITE ==="}
    
    {System.showInfo "\n=== TEST 1: Basic Num operations ==="}
    {TestBasic}
    
    {System.showInfo "\n=== TEST 2: Num numberToWord edge cases ==="}
    {TestNumberToWord}
    
    {System.showInfo "\n=== TEST 3: Basic operations ==="}
    {TestBasic}
    
    {System.showInfo "\n=== TEST 4: Edge cases for operations ==="}
    {TestOperationEdgeCases}
    
    {System.showInfo "\n=== TEST 5: Complex nested expressions ==="}
    {TestComplex}
    
    {System.showInfo "\n=== TEST 6: Deep nesting ==="}
    {TestComplex}
    
    {System.showInfo "\n=== TEST 7: Large numbers ==="}
    {TestLargeNumbers}
    
    {System.showInfo "\n=== TEST 8: Base Expression functionality ==="}
    {TestBaseExpression}
    
    {System.showInfo "\n=== TEST 9: All operations with same operands (3, 3) ==="}
    {TestSameOperands}
    
    {System.showInfo "\n=== TEST 10: Larger numbers than 999 ==="}
    {TestLargerNumbers}
    
    {System.showInfo "\n=== ALL TESTS COMPLETED ==="}
end

% Uncomment to run tests
{RunAllTests}