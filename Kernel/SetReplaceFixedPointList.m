Package["SetReplace`"]

PackageImport["GeneralUtilities`"]

PackageExport["SetReplaceFixedPointList"]

(* Same as SetReplaceFixedPoint, but returns all intermediate steps. *)

SetUsage @ "
SetReplaceFixedPointList[set$, {input$1 -> output$1, input$2 -> output$2, $$}] performs SetReplace repeatedly until \
no further events can be matched, and returns the list of all intermediate sets.
";

Options[SetReplaceFixedPointList] = {
  Method -> Automatic,
  TimeConstraint -> Infinity,
  "EventOrderingFunction" -> Automatic};

SyntaxInformation[SetReplaceFixedPointList] = {
  "ArgumentsPattern" -> {set_, rules_, OptionsPattern[]},
  "OptionNames" -> Options[SetReplaceFixedPointList][[All, 1]]};

SetReplaceFixedPointList[args___] := 0 /;
  !Developer`CheckArgumentCount[SetReplaceFixedPointList[args], 2, 2] && False;

SetReplaceFixedPointList[set_, rules_, o : OptionsPattern[]] /;
    recognizedOptionsQ[expr, SetReplaceFixedPointList, {o}] := ModuleScope[
  result = Check[
    setSubstitutionSystem[rules, set, <||>, SetReplaceFixedPointList, False, o]
  ,
    $Failed
  ];
  If[result === $Aborted, result, result["SetAfterEvent", #] & /@ Range[0, result["EventsCount"]]] /;
    result =!= $Failed
];
