Package["SetReplace`"]

PackageImport["GeneralUtilities`"]

PackageExport["SetReplaceAll"]

(* The idea for SetReplaceAll is to keep performing SetReplace on the graph until no replacement can be done without
   touching the same edge twice.
   Note, it's not doing replacement until all edges are touched at least once. That may not always be possible. We just
   don't want to touch edges twice in a single step. *)

SetUsage @ "
SetReplaceAll[set$, rules$] performs SetReplace[set$, rules$] as many times as it takes until no \
replacement can be done without touching the same expression twice.
SetReplaceAll[set$, rules$, generationCount$] performes the same operation generationCount$ times, i.e., any edge will \
at most be replaced generationCount$ times.
";

Options[SetReplaceAll] = {
  Method -> Automatic,
  TimeConstraint -> Infinity,
  "EventOrderingFunction" -> Automatic};

SyntaxInformation[SetReplaceAll] = {
  "ArgumentsPattern" -> {set_, rules_, generationCount_., OptionsPattern[]},
  "OptionNames" -> Options[SetReplaceAll][[All, 1]]};

SetReplaceAll[args___] := 0 /;
  !Developer`CheckArgumentCount[SetReplaceAll[args], 2, 3] && False;

(* We just run SetSubstitutionSystem for the specified number of generations, and take the last set. *)

expr : SetReplaceAll[
    set_, rules_, generationCount : Except[_ ? OptionQ] : 1, o : OptionsPattern[]] /;
      recognizedOptionsQ[expr, SetReplaceAll, {o}] :=
  ModuleScope[
    result = Check[
      setSubstitutionSystem[rules, set, <|$maxGenerationsLocal -> generationCount|>, SetReplaceAll, False, o]
    ,
      $Failed
    ];
    If[result === $Aborted, result, result[-1]] /; result =!= $Failed
  ];
