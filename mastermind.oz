%% ============================================================================
%% Main game controller that manages the overall game flow
%% ============================================================================
%% Color enumeration - valid colors in the game
%% Type: Color :: red | blue | green | yellow | orange | purple
%% ============================================================================
declare 

   %% ===========================================
   %% GAME STATE REPRESENTATION
   %% ===========================================
   %% Codemaker = codemaker(
   %%    secretCode: [Color]
   %%    currentRound: Int
   %%    maxRounds: Int
   %%    gameStatus: GameStatus
   %%    guessHistory: [GuessRecord]
   %%    feedbackHistory: [FeedbackRecord]
   %% )
   %% GameStatus :: 'ready' | 'playing' | 'won' | 'lost' | 'finished'
   %% GuessRecord = record(guess: [Color] roundNumber: Int)
   %% FeedbackRecord = record(feedback: FeedbackResult roundNumber: Int)
   %% FeedbackResult = feedback(
   %%    blackClues: Int
   %%    whiteClues: Int
   %%    totalCorrect: Int
   %%    isCorrect: Bool
   %%    clueList: [FeedbackClue]
   %% )
   %% FeedbackClue :: black | white | none

   %% ===========================================
   %% UTILITY FUNCTIONS
   %% ===========================================
   fun {IsValidCode Code}
      %% Validates if a code follows game rules
      %% Input: Code :: [Color] - Code to validate
      %% Output: Result :: Bool - true if code is valid for this game
      local
         AvailableColors = [red blue green yellow orange purple]
         fun {AllValid Colors ValidColors}
            case Colors of nil then true
            [] H|T then
               {Member H ValidColors} andthen {AllValid T ValidColors}
            end
         end
      in
         {Length Code} == 4 andthen {AllValid Code AvailableColors}
      end
   end

   fun {CountBlack Secret Guess}
      %% Counts black clues (correct color and position)
      case Secret of nil then 0
      [] S|Sr then
         case Guess of nil then 0
         [] G|Gr then
            if S == G then 1 + {CountBlack Sr Gr}
            else {CountBlack Sr Gr}
            end
         end
      end
   end

   fun {CountColors List}
      %% Counts occurrences of each color in a list
      local
         fun {CountOccurrences Color List}
            case List of nil then 0
            [] H|T then
               if H == Color then 1 + {CountOccurrences Color T}
               else {CountOccurrences Color T}
               end
            end
         end
         fun {RemoveDuplicates List}
            case List of nil then nil
            [] H|T then
               if {Member H T} then {RemoveDuplicates T}
               else H | {RemoveDuplicates T}
               end
            end
         end
         fun {CountAll Colors}
            case Colors of nil then nil
            [] H|T then
               (H|{CountOccurrences H List}) | {CountAll {RemoveDuplicates T}}
            end
         end
      in
         {CountAll {RemoveDuplicates List}}
      end
   end

   fun {CountWhite Secret Guess}
      %% Counts white clues (correct color, wrong position)
      local
         SecretCounts = {CountColors Secret}
         GuessCounts = {CountColors Guess}
         
         fun {CountCommon Counts1 Counts2}
            case Counts1 of nil then 0
            [] (Color|Count1)|Rest1 then
               local
                  fun {FindColorCount Color Counts}
                     case Counts of nil then 0
                     [] (C|Count)|Rest then
                        if C == Color then Count
                        else {FindColorCount Color Rest}
                        end
                     end
                  end
                  Count2 = {FindColorCount Color Counts2}
               in
                  {Min Count1 Count2} + {CountCommon Rest1 Counts2}
               end
            end
         end
      in
         {CountCommon SecretCounts GuessCounts} - {CountBlack Secret Guess}
      end
   end

   fun {GenerateClueList Black White}
      %% Generates the list of clues (black, white, none)
      local
         fun {MakeBlackList Count}
            if Count == 0 then nil
            else black | {MakeBlackList Count - 1}
            end
         end
         fun {MakeWhiteList Count}
            if Count == 0 then nil
            else white | {MakeWhiteList Count - 1}
            end
         end
         fun {MakeNoneList Count}
            if Count == 0 then nil
            else none | {MakeNoneList Count - 1}
            end
         end
         fun {AppendLists L1 L2}
            case L1 of nil then L2
            [] H|T then H | {AppendLists T L2}
            end
         end
      in
         {AppendLists {MakeBlackList Black} {AppendLists {MakeWhiteList White} {MakeNoneList 4 - Black - White}}}
      end
   end


   
   %% ===========================================
   %% MAIN FUNCTIONS (with exact signatures)
   %% ===========================================
   fun {StartGame Code}
      %% Starts a new game session with a codemaker with a defined secret code and the rounds played 
      %% Input: The code
      %% Output: A code maker with the code
      
      %% Your code here
      if {IsValidCode Code} then
         codemaker(
            secretCode: Code
            currentRound: 1
            maxRounds: 12
            gameStatus: 'playing'
            guessHistory: nil
            feedbackHistory: nil
         )
      else
         {Exception.raiseError 'Invalid code provided'}
      end
   end
   
   fun {PlayRound Codemaker Guess}
      %% Executes one round of the game (guess + feedback)
      %% Input: the code maker and the guess from the codebreaker  
      %% Output: [FeedbackClue] % Black and white Clues received
      %%          round, the number of rounds played so far   
      %% Your code here
      if Codemaker.gameStatus == 'playing' then
         local
            FeedbackResult = {EvaluateGuess Codemaker Guess}
            NewRound = Codemaker.currentRound + 1
            GameWon = FeedbackResult.isCorrect
            GameOver = GameWon orelse NewRound > Codemaker.maxRounds
            NewStatus = if GameWon then 'won'
                       elseif GameOver then 'lost'
                       else 'playing'
                       end
            NewGuessHistory = record(guess: Guess roundNumber: Codemaker.currentRound) | Codemaker.guessHistory
            NewFeedbackHistory = record(feedback: FeedbackResult roundNumber: Codemaker.currentRound) | Codemaker.feedbackHistory
         in
            codemaker(
               secretCode: Codemaker.secretCode
               currentRound: if GameWon orelse GameOver then Codemaker.currentRound else NewRound end
               maxRounds: Codemaker.maxRounds
               gameStatus: NewStatus
               guessHistory: NewGuessHistory
               feedbackHistory: NewFeedbackHistory
            )
         end
      else
         Codemaker
      end
   end
   
   fun {GetGameStatus Feedback Rounds}
      %% Returns current game status
      %% Input: Game Feedback
      %%        The number of rounds played so far 
      %% Output: Result :: GameStatus - Current status of the game
      %%         GameStatus :: 'playing' | 'won' | 'lost' 
      %% Your code here
      if Feedback.isCorrect then 'won'
      elseif Rounds >= 12 then 'lost'
      else 'playing'
      end
   end
   
   fun {GetCurrentRound Codemaker}
      %% Returns current round number
      %% Input: Codemaker
      %% Output: Result :: Int - Current round number (1-12)
      %% Your code here
      Codemaker.currentRound
   end
   
   fun {GetRemainingRounds Codemaker}
      %% Returns number of rounds left
      %% Input: Codemaker
      %% Output: Result :: Int - Number of rounds remaining (0-11)
      %% Your code here
      if Codemaker.gameStatus == 'playing' then
         Codemaker.maxRounds - Codemaker.currentRound
      else
         0
      end
   end
   
   fun {EvaluateGuess Codemaker Guess}
      %% Evaluates a guess against the secret code
      %% Input: Codebreaker
      %%        Guess :: [Color] - List of exactly 4 colors representing the guess
      %% Output: [Result] :: blackClues: Int     % Number of correct color & position
      %%            whiteClues: Int            % Number of correct color, wrong position  
      %%            ClueList: [FeedbackClue]   % List of individual Clue results
      %% Your code here
      if {Length Guess} \= 4 then
         {Exception.raiseError 'Guess must have exactly 4 colors'}
      else
         local
            BlackClues = {CountBlack Codemaker.secretCode Guess}
            WhiteClues = {CountWhite Codemaker.secretCode Guess}
            TotalCorrect = BlackClues + WhiteClues
            IsCorrect = BlackClues == 4
         in
            feedback(
               blackClues: BlackClues
               whiteClues: WhiteClues
               totalCorrect: TotalCorrect
               isCorrect: IsCorrect
               clueList: {GenerateClueList BlackClues WhiteClues}
            )
         end
      end
   end

   fun {GetSecretCode Codemaker}
      %% Returns the current secret code (for testing/debugging)
      %% Input: None
      %% Output: Result :: [Color] | nil - Secret code or nil if not set
      %% Note: Should only be used for testing, breaks game in normal play
      %% Your code here
      Codemaker.secretCode
   end






%% ===========================================
%% COMPREHENSIVE TEST SUITE (mirrors mastermind_oop.oz tests)
%% ===========================================

proc {RunMastermindTests}
   {System.showInfo "\n=== MASTERMIND (FUNCTIONAL) TEST SUITE ==="}
   
   local
      %% Test 1: Game Initialization
      SecretCode1 = [red blue green yellow]
      Codemaker1 = {StartGame SecretCode1}
      Status1 = {GetGameStatus {EvaluateGuess Codemaker1 [red orange purple blue]} 1}
      Round1 = {GetCurrentRound Codemaker1}
      Remaining1 = {GetRemainingRounds Codemaker1}
      RetrievedCode1 = {GetSecretCode Codemaker1}
   in
      {System.showInfo "\n--- Test 1: Game Initialization ---"}
      {System.showInfo "Game status: " # Status1 # " (expected: playing)"}
      {System.showInfo "Current round: " # Round1 # " (expected: 1)"}
      {System.showInfo "Remaining rounds: " # Remaining1 # " (expected: 11)"}
      {System.showInfo "Secret code: " # {Value.toVirtualString RetrievedCode1 10 10}}
   end

   local
      %% Test 2: Code Validation
      ValidCode1 = [red blue green yellow]
      ValidCode2 = [red red red red]
      InvalidCode1 = [red blue green]  % Too short
      InvalidCode2 = [red blue green yellow orange]  % Too long
      Valid1 = {IsValidCode ValidCode1}
      Valid2 = {IsValidCode ValidCode2}
      Invalid1 = {IsValidCode InvalidCode1}
      Invalid2 = {IsValidCode InvalidCode2}
   in
      {System.showInfo "\n--- Test 2: Code Validation ---"}
      {System.showInfo "Valid code [red blue green yellow]: " # {Value.toVirtualString Valid1 10 10} # " (expected: true)"}
      {System.showInfo "Valid code [red red red red]: " # {Value.toVirtualString Valid2 10 10} # " (expected: true)"}
      {System.showInfo "Invalid code [red blue green]: " # {Value.toVirtualString Invalid1 10 10} # " (expected: false)"}
      {System.showInfo "Invalid code [red blue green yellow orange]: " # {Value.toVirtualString Invalid2 10 10} # " (expected: false)"}
   end

   local
      %% Test 3: Guess Evaluation
      SecretCode = [red blue green yellow]
      Codemaker = {StartGame SecretCode}
      PerfectGuess = [red blue green yellow]
      WrongPosGuess = [blue red yellow green]
      MixedGuess = [red orange purple blue]
      NoMatchGuess = [orange purple orange purple]
      
      Feedback1 = {EvaluateGuess Codemaker PerfectGuess}
      Feedback2 = {EvaluateGuess Codemaker WrongPosGuess}
      Feedback3 = {EvaluateGuess Codemaker MixedGuess}
      Feedback4 = {EvaluateGuess Codemaker NoMatchGuess}
   in
      {System.showInfo "\n--- Test 3: Guess Evaluation ---"}
      {System.showInfo "Perfect match - Black: " # Feedback1.blackClues # " White: " # Feedback1.whiteClues # " Correct: " # {Value.toVirtualString Feedback1.isCorrect 10 10}}
      {System.showInfo "All colors wrong positions - Black: " # Feedback2.blackClues # " White: " # Feedback2.whiteClues}
      {System.showInfo "Mixed - Black: " # Feedback3.blackClues # " White: " # Feedback3.whiteClues}
      {System.showInfo "No matches - Black: " # Feedback4.blackClues # " White: " # Feedback4.whiteClues}
   end

   local
      %% Test 4: Game Round Execution
      SecretCode = [red blue green yellow]
      Codemaker = {StartGame SecretCode}
      Guess1 = [red orange purple blue]
      CodemakerAfterRound1 = {PlayRound Codemaker Guess1}
      StatusAfterRound1 = {GetGameStatus {EvaluateGuess CodemakerAfterRound1 [red orange purple blue]} 2}
      RoundAfterRound1 = {GetCurrentRound CodemakerAfterRound1}
      RemainingAfterRound1 = {GetRemainingRounds CodemakerAfterRound1}
   in
      {System.showInfo "\n--- Test 4: Game Round Execution ---"}
      {System.showInfo "After round 1 - Status: " # StatusAfterRound1 # " (expected: playing)"}
      {System.showInfo "After round 1 - Round: " # RoundAfterRound1 # " (expected: 2)"}
      {System.showInfo "After round 1 - Remaining: " # RemainingAfterRound1 # " (expected: 10)"}
   end

   local
      %% Test 5: Winning Game
      SecretCode = [red blue green yellow]
      Codemaker = {StartGame SecretCode}
      WinningGuess = [red blue green yellow]
      CodemakerAfterWin = {PlayRound Codemaker WinningGuess}
      StatusAfterWin = {GetGameStatus {EvaluateGuess CodemakerAfterWin [red blue green yellow]} 1}
      RoundAfterWin = {GetCurrentRound CodemakerAfterWin}
   in
      {System.showInfo "\n--- Test 5: Winning Game ---"}
      {System.showInfo "After winning - Status: " # StatusAfterWin # " (expected: won)"}
      {System.showInfo "After winning - Round: " # RoundAfterWin # " (expected: 1)"}
   end

   local
      %% Test 6: Losing Game (too many rounds)
      SecretCode = [red blue green yellow]
      Codemaker = {StartGame SecretCode}
      WrongGuess = [orange purple orange purple]
      
      %% Simulate 12 rounds of wrong guesses
      fun {SimulateLosingGame Codemaker Round}
         if Round > 12 then Codemaker
         else
            {SimulateLosingGame {PlayRound Codemaker WrongGuess} Round + 1}
         end
      end
      
      FinalCodemaker = {SimulateLosingGame Codemaker 1}
      FinalStatus = {GetGameStatus {EvaluateGuess FinalCodemaker WrongGuess} 12}
      FinalRound = {GetCurrentRound FinalCodemaker}
   in
      {System.showInfo "\n--- Test 6: Losing Game ---"}
      {System.showInfo "After 12 rounds - Status: " # FinalStatus # " (expected: lost)"}
      {System.showInfo "After 12 rounds - Round: " # FinalRound # " (expected: 12)"}
   end

   local
      %% Test 7: Random Code Generation
      fun {GenerateRandomCode}
         local
            AvailableColors = [red blue green yellow orange purple]
            fun {RandomColor Colors}
               local Index in
                  Index = {OS.rand} mod {Length Colors}
                  {Nth Colors Index + 1}
               end
            end
            fun {GenerateCode Colors Count}
               if Count == 0 then nil
               else
                  {RandomColor Colors} | {GenerateCode Colors Count - 1}
               end
            end
         in
            {GenerateCode AvailableColors 4}
         end
      end
      RandomCode1 = {GenerateRandomCode}
      RandomCode2 = {GenerateRandomCode}
      ValidRandom1 = {IsValidCode RandomCode1}
      ValidRandom2 = {IsValidCode RandomCode2}
   in
      {System.showInfo "\n--- Test 7: Random Code Generation ---"}
      {System.showInfo "Random code 1: " # {Value.toVirtualString RandomCode1 10 10} # " Valid: " # {Value.toVirtualString ValidRandom1 10 10}}
      {System.showInfo "Random code 2: " # {Value.toVirtualString RandomCode2 10 10} # " Valid: " # {Value.toVirtualString ValidRandom2 10 10}}
   end

   local
      %% Test 8: Guess History
      SecretCode = [red blue green yellow]
      Codemaker = {StartGame SecretCode}
      Guess1 = [red orange purple blue]
      CodemakerAfterRound1 = {PlayRound Codemaker Guess1}
      Guess2 = [blue red yellow green]
      CodemakerAfterRound2 = {PlayRound CodemakerAfterRound1 Guess2}
      History = CodemakerAfterRound2.guessHistory
   in
      {System.showInfo "\n--- Test 8: Guess History ---"}
      {System.showInfo "History length: " # {Length History} # " (expected: 2)"}
      {System.showInfo "First guess: " # {Value.toVirtualString {Nth History 1}.guess 10 10}}
      {System.showInfo "Second guess: " # {Value.toVirtualString {Nth History 2}.guess 10 10}}
   end

   local
      %% Test 9: Edge Cases
      EmptyCodemaker = codemaker(
         secretCode: nil
         currentRound: 0
         maxRounds: 12
         gameStatus: 'ready'
         guessHistory: nil
         feedbackHistory: nil
      )
      StatusEmpty = {GetGameStatus {EvaluateGuess EmptyCodemaker [red orange purple blue]} 0}
      RoundEmpty = {GetCurrentRound EmptyCodemaker}
      RemainingEmpty = {GetRemainingRounds EmptyCodemaker}
   in
      {System.showInfo "\n--- Test 9: Edge Cases ---"}
      {System.showInfo "Empty codemaker status: " # StatusEmpty # " (expected: playing)"}
      {System.showInfo "Empty codemaker round: " # RoundEmpty # " (expected: 0)"}
      {System.showInfo "Empty codemaker remaining: " # RemainingEmpty # " (expected: 0)"}
   end

   local
      %% Test 10: Multiple Games
      SecretCode1 = [red blue green yellow]
      SecretCode2 = [orange purple orange purple]
      Codemaker1 = {StartGame SecretCode1}
      Codemaker2 = {StartGame SecretCode2}
      Status1 = {GetGameStatus {EvaluateGuess Codemaker1 [red orange purple blue]} 1}
      Status2 = {GetGameStatus {EvaluateGuess Codemaker2 [red orange purple blue]} 1}
      Code1 = {GetSecretCode Codemaker1}
      Code2 = {GetSecretCode Codemaker2}
   in
      {System.showInfo "\n--- Test 10: Multiple Games ---"}
      {System.showInfo "Codemaker 1 status: " # Status1 # " Code: " # {Value.toVirtualString Code1 10 10}}
      {System.showInfo "Codemaker 2 status: " # Status2 # " Code: " # {Value.toVirtualString Code2 10 10}}
   end

   {System.showInfo "\n=== ALL MASTERMIND TESTS COMPLETED ==="}
end

{RunMastermindTests}