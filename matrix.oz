%% Matrix Definition
declare 

   fun {GetSize Matrix }
      %% Returns the size N of the N×N matrix given as parameter
      %% Input: None
      %% Output: Result :: Int - The dimension N of the N×N matrix
      %% Your code here
      case Matrix of nil then 0
      [] Rows then {Length Rows}
      end 
   end
   
   fun {GetElement Matrix Row Col }
      %% Returns element at position  Matrix Row, Col) using 1-indexed coordinates
      %% Input: Row :: Int - Row index  Matrix 1 ≤ Row ≤ N)
      %%        Col :: Int - Column index  Matrix 1 ≤ Col ≤ N)
      %% Output: Result :: Int - Element at position  Matrix Row, Col)
      %% Note: If Row and Col are not valide within the matrix size return 142857
      %% Your code here
      local N = {GetSize Matrix} in
         if Row>=1 andthen Row=<N andthen Col>=1 andthen Col=<N then
            local
               fun {GetNth List Nth}
                  if Nth==1 then List.1 else {GetNth List.2 Nth-1} end
               end
               RowList = {GetNth Matrix Row}
            in
               {GetNth RowList Col}
            end
         else 142857 end
      end 
   end
   
   fun {GetRow Matrix RowIndex }
      %% Returns the complete row as a list
      %% Input: RowIndex :: Int - Row number  Matrix 1 ≤ RowIndex ≤ N)
      %% Output: Result :: [Int] - List containing all elements of the specified row
      %% Note: If RowIndex is not valide within the matrix size return 142857
      %% Your code here
      local N = {GetSize Matrix} in
         if RowIndex>=1 andthen RowIndex=<N then
            local
               fun {GetNth List Nth}
                  if Nth==1 then List.1 else {GetNth List.2 Nth-1} end
               end
            in
               {GetNth Matrix RowIndex}
            end
         else 142857 end
      end 
   end
   
   fun {GetColumn Matrix ColIndex }
      %% Returns the complete column as a list
      %% Input: ColIndex :: Int - Column number  Matrix 1 ≤ ColIndex ≤ N)  
      %% Output: Result :: [Int] - List containing all elements of the specified column
      %% Note: If ColIndex is not valide within the matrix size return 142857
      %% Your code here
      local N = {GetSize Matrix} in
         if ColIndex>=1 andthen ColIndex=<N then
            local
               fun {GetNth List Nth}
                  if Nth==1 then List.1 else {GetNth List.2 Nth-1} end
               end
               fun {ExtractColumn Rows Col}
                  case Rows of nil then nil
                  [] Row|Rest then {GetNth Row Col} | {ExtractColumn Rest Col}
                  end
               end
            in
               {ExtractColumn Matrix ColIndex}
            end
         else 142857 end
      end 
   end
   
   fun {SumRow Matrix RowIndex }
      %% Returns sum of all elements in specified row
      %% Input: RowIndex :: Int - Row number  Matrix 1 ≤ RowIndex ≤ N)
      %% Output: Result :: Int - Arithmetic sum of all elements in the row
      %% Precondition: RowIndex is valid within the Matrix size
      %% Note: If RowIndex is not valide within the matrix size return 142857
      %% Your code here
      local Row = {GetRow Matrix RowIndex} in
         if Row==142857 then 142857
         else
            local
               fun {SumList L}
                  case L of nil then 0 [] H|T then H + {SumList T} end
               end
            in
               {SumList Row}
            end
         end
      end 
   end
   
   fun {ProductRow Matrix RowIndex }
      %% Returns product of all elements in specified row
      %% Input: RowIndex :: Int - Row number  ( 1 ≤ RowIndex ≤ N)
      %% Output: Result :: Int - Arithmetic product of all elements in the row
      %% Note: If RowIndex is not valide within the matrix size return 142857
      %% Your code here
      local Row = {GetRow Matrix RowIndex} in
         if Row==142857 then 142857
         else
            local
               fun {ProductList L}
                  case L of nil then 1 [] H|T then H * {ProductList T} end
               end
            in
               {ProductList Row}
            end
         end
      end 
   end
   
   fun {SumColumn Matrix ColIndex }
      %% Returns sum of all elements in specified column
      %% Input: ColIndex :: Int - Column number  Matrix 1 ≤ ColIndex ≤ N)
      %% Output: Result :: Int - Arithmetic sum of all elements in the column
      %% Note: If ColIndex is not valide within the matrix size return 142857
      %% Your code here
      local Col = {GetColumn Matrix ColIndex} in
         if Col==142857 then 142857
         else
            local
               fun {SumList L}
                  case L of nil then 0 [] H|T then H + {SumList T} end
               end
            in
               {SumList Col}
            end
         end
      end 
   end
   
   fun {ProductColumn Matrix ColIndex }
      %% Returns product of all elements in specified column
      %% Input: ColIndex :: Int - Column number  Matrix 1 ≤ ColIndex ≤ N)
      %% Output: Result :: Int - Arithmetic product of all elements in the column
      %% Note: If ColIndex is not valide within the matrix size return 142857
      %% Your code here
      local Col = {GetColumn Matrix ColIndex} in
         if Col==142857 then 142857
         else
            local
               fun {ProductList L}
                  case L of nil then 1 [] H|T then H * {ProductList T} end
               end
            in
               {ProductList Col}
            end
         end
      end 
   end
   
   fun {SumAll Matrix }
      %% Returns sum of all elements in the matrix
      %% Input: None
      %% Output: Result :: Int - Arithmetic sum of all matrix elements
      %% Note: Returns 0 for empty matrix
      %% Your code here
      local
         fun {SumMatrix M}
            case M of nil then 0
            [] Row|Rest then
               local
                  fun {SumList L}
                     case L of nil then 0 [] H|T then H + {SumList T} end
                  end
               in
                  {SumList Row} + {SumMatrix Rest}
               end
            end
         end
      in
         {SumMatrix Matrix}
      end 
   end
   
   fun {ProductAll Matrix }
      %% Returns product of all elements in the matrix
      %% Input: None
      %% Output: Result :: Int - Arithmetic product of all matrix elements
      %% Note: Returns 1 for empty matrix, returns 0 if any element is 0
      %% Your code here
      local
         fun {ProductMatrix M}
            case M of nil then 1
            [] Row|Rest then
               local
                  fun {ProductList L}
                     case L of nil then 1 [] H|T then H * {ProductList T} end
                  end
               in
                  {ProductList Row} * {ProductMatrix Rest}
               end
            end
         end
      in
         {ProductMatrix Matrix}
      end 
   end
   
   %% Utility funods. Antes era un fun
   proc {Display Matrix }
      %% Prints matrix in readable format to standard output
      %%    Any format is valid, just must display all the matrix content
      %% Input: None
      %% Output: None  Matrix void)
      %% Your code here
      local
         fun {RowToString Row}
            case Row of nil then ""
            [] H|T then
               case T of nil then {IntToString H}
               else {IntToString H} # " " # {RowToString T}
               end
            end
         end
         proc {PrintMatrix M}
            case M of nil then skip
            [] Row|Rest then
               {System.showInfo {RowToString Row}}
               {PrintMatrix Rest}
            end
         end
         N = {GetSize Matrix}
      in
         {System.showInfo "Matrix (" # N # "x" # N # "):"}
         {PrintMatrix Matrix}
      end 
   end



% proc {RunMatrixTests}
%    {System.showInfo "\n=== MATRIX (FUNCTIONAL) TEST SUITE ==="}
%    local M1 M2 M3 M4 M5 M6 in

%    M1 = [[1 2] [3 4]]
%    M2 = [[1 2 3] [4 5 6] [7 8 9]]
%    M3 = [[5]]
%    {System.showInfo "M1 size: " # {GetSize M1} # " (expected: 2)"}
%    {System.showInfo "M2 size: " # {GetSize M2} # " (expected: 3)"}
%    {System.showInfo "M3 size: " # {GetSize M3} # " (expected: 1)"}

%    {System.showInfo "M1[1,1] = " # {GetElement M1 1 1} # " (expected: 1)"}
%    {System.showInfo "M1[1,2] = " # {GetElement M1 1 2} # " (expected: 2)"}
%    {System.showInfo "M1[2,1] = " # {GetElement M1 2 1} # " (expected: 3)"}
%    {System.showInfo "M1[2,2] = " # {GetElement M1 2 2} # " (expected: 4)"}
%    {System.showInfo "M1[0,1] = " # {GetElement M1 0 1} # " (expected: 142857)"}
%    {System.showInfo "M1[1,0] = " # {GetElement M1 1 0} # " (expected: 142857)"}
%    {System.showInfo "M1[3,1] = " # {GetElement M1 3 1} # " (expected: 142857)"}

%    {System.showInfo "M2 Row 1: " # {Value.toVirtualString {GetRow M2 1} 10 10}}
%    {System.showInfo "M2 Row 2: " # {Value.toVirtualString {GetRow M2 2} 10 10}}
%    {System.showInfo "M2 Row 3: " # {Value.toVirtualString {GetRow M2 3} 10 10}}
%    {System.showInfo "M2 Row 4: " # {GetRow M2 4} # " (expected: 142857)"}

%    {System.showInfo "M2 Col 1: " # {Value.toVirtualString {GetColumn M2 1} 10 10}}
%    {System.showInfo "M2 Col 2: " # {Value.toVirtualString {GetColumn M2 2} 10 10}}
%    {System.showInfo "M2 Col 3: " # {Value.toVirtualString {GetColumn M2 3} 10 10}}
%    {System.showInfo "M2 Col 4: " # {GetColumn M2 4} # " (expected: 142857)"}

%    {System.showInfo "M1 Row 1 sum: " # {SumRow M1 1} # " (expected: 3)"}
%    {System.showInfo "M1 Row 2 sum: " # {SumRow M1 2} # " (expected: 7)"}
%    {System.showInfo "M2 Row 1 sum: " # {SumRow M2 1} # " (expected: 6)"}
%    {System.showInfo "M1 Row 3 sum: " # {SumRow M1 3} # " (expected: 142857)"}

%    {System.showInfo "M1 Row 1 product: " # {ProductRow M1 1} # " (expected: 2)"}
%    {System.showInfo "M1 Row 2 product: " # {ProductRow M1 2} # " (expected: 12)"}
%    {System.showInfo "M2 Row 1 product: " # {ProductRow M2 1} # " (expected: 6)"}
%    {System.showInfo "M1 Row 3 product: " # {ProductRow M1 3} # " (expected: 142857)"}

%    {System.showInfo "M1 Col 1 sum: " # {SumColumn M1 1} # " (expected: 4)"}
%    {System.showInfo "M1 Col 2 sum: " # {SumColumn M1 2} # " (expected: 6)"}
%    {System.showInfo "M2 Col 1 sum: " # {SumColumn M2 1} # " (expected: 12)"}
%    {System.showInfo "M1 Col 3 sum: " # {SumColumn M1 3} # " (expected: 142857)"}

%    {System.showInfo "M1 Col 1 product: " # {ProductColumn M1 1} # " (expected: 3)"}
%    {System.showInfo "M1 Col 2 product: " # {ProductColumn M1 2} # " (expected: 8)"}
%    {System.showInfo "M2 Col 1 product: " # {ProductColumn M2 1} # " (expected: 28)"}
%    {System.showInfo "M1 Col 3 product: " # {ProductColumn M1 3} # " (expected: 142857)"}

%    {System.showInfo "M1 total sum: " # {SumAll M1} # " (expected: 10)"}
%    {System.showInfo "M2 total sum: " # {SumAll M2} # " (expected: 45)"}
%    {System.showInfo "M3 total sum: " # {SumAll M3} # " (expected: 5)"}

%    {System.showInfo "M1 total product: " # {ProductAll M1} # " (expected: 24)"}
%    {System.showInfo "M2 total product: " # {ProductAll M2} # " (expected: 362880)"}
%    {System.showInfo "M3 total product: " # {ProductAll M3} # " (expected: 5)"}

%    {System.showInfo "Displaying M1:"}
%    {Display M1}
%    {System.showInfo "\nDisplaying M2:"}
%    {Display M2}
%    {System.showInfo "\nDisplaying M3:"}
%    {Display M3}

%    M4 = [[0 1] [2 0]]
%    M5 = [[~1 2] [~3 4]]
%    {System.showInfo "M4 (with zeros) sum: " # {SumAll M4} # " (expected: 3)"}
%    {System.showInfo "M4 (with zeros) product: " # {ProductAll M4} # " (expected: 0)"}
%    {System.showInfo "M5 (with negatives) sum: " # {SumAll M5} # " (expected: 2)"}
%    {System.showInfo "M5 (with negatives) product: " # {ProductAll M5} # " (expected: 24)"}

%    {System.showInfo "M2[1,1] (first): " # {GetElement M2 1 1} # " (expected: 1)"}
%    {System.showInfo "M2[3,3] (last): " # {GetElement M2 3 3} # " (expected: 9)"}
%    {System.showInfo "M2[2,2] (middle): " # {GetElement M2 2 2} # " (expected: 5)"}

%    M6 = [[1 2 3 4] [5 6 7 8] [9 10 11 12] [13 14 15 16]]
%    {System.showInfo "M6 size: " # {GetSize M6}}
%    {System.showInfo "M6 total sum: " # {SumAll M6}}
%    {System.showInfo "M6 total product: " # {ProductAll M6}}
%    end
% end

% {RunMatrixTests}