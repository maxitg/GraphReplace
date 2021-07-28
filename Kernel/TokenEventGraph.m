Package["SetReplace`"]

PackageImport["GeneralUtilities`"]

PackageExport["TokenEventGraph"]
PackageExport["MultihistoryToken"]
PackageExport["MultihistoryEvent"]

SetUsage @ "
TokenEventGraph[multihistory$] yields the token-event graph of a multihistory$.
* Token-event graph is a bipartite graph showing input and output tokens of every event.
";

Options[TokenEventGraph] = Options[tokenEventGraph] = Options[Graph];

SyntaxInformation[TokenEventGraph] = {
  "ArgumentsPattern" -> {multihistory_, OptionsPattern[]},
  "OptionNames" -> Options[TokenEventGraph][[All, 1]]};

declareRawProperty[tokenEventGraph, SetReplaceType[MultisetSubstitutionSystem, 0], TokenEventGraph];

(* TODO: check arguments count *)
(* TODO: check option correctness *)
tokenEventGraph[opts : OptionsPattern[]][Multihistory[_, data_]] := ModuleScope[
  inputsToEvents = Catenate[Thread /@ Thread[
    Map[MultihistoryToken, Rest @ Normal[data["EventInputs"]], {2}] ->
      MultihistoryEvent /@ Range[data["EventInputs"]["Length"] - 1]]];
  eventsToOutputs = Catenate[Thread /@ Thread[
    MultihistoryEvent /@ Range[data["EventOutputs"]["Length"] - 1] ->
      Map[MultihistoryToken, Rest @ Normal[data["EventOutputs"]], {2}]]];
  Graph[
    (* TODO: add a list of vertices *)
    Join[inputsToEvents, eventsToOutputs],
    (* TODO: rename styles in SetReplaceStyleData *)
    (* TODO: implement layout *)
    VertexStyle -> parseVertexStyleRules[data][OptionValue[VertexStyle]],
    EdgeStyle -> style[$lightTheme][$causalGraphEdgeStyle],
    VertexLabels -> parseLabelRules[data][OptionValue[VertexLabels]],
    opts]
];

parseVertexStyleRules[data_][Automatic] := parseElementRules[data] @ {
  _MultihistoryToken -> style[$lightTheme][$expressionVertexStyle],
  _MultihistoryEvent -> style[$lightTheme][$causalGraphVertexStyle]
};
parseVertexStyleRules[data_][arg_] := parseElementRules[data][arg];

parseLabelRules[data_][Automatic] := parseElementRules[data] @ {
  _MultihistoryToken -> Placed[{"Content", Row[{"Index: ", "Index"}]}, {After, Tooltip}],
  _MultihistoryEvent ->
    Placed[{If[Length[data["Rules"]] > 1, "RuleIndex", ""], Row[{"Index: ", "Index"}]}, {After, Tooltip}]
};
parseLabelRules[data_][arg_] := parseElementRules[data][arg];

parseElementRules[data_][arg_] := parseElementRules[data][_ -> arg];

parseElementRules[data_][rule : _Rule | _RuleDelayed] := parseElementRules[data][{rule}];

tokenPropertyRules[data_, n_] := <|
  "Index" -> n,
  "Content" :> data["Expressions"]["Part", n],
  "RuleIndex" -> "",
  "Generation" :> data["EventGenerations"]["Part", data["ExpressionCreatorEvents"]["Part", n]]
|>;

eventPropertyRules[data_, n_] := <|
  "Index" -> n,
  "Content" :>
    Rule @@ (data["Expressions"]["Part", #] & /@ data[#]["Part", n + 1] & /@ {"EventInputs", "EventOutputs"}),
  "RuleIndex" :> data["EventRuleIndices"]["Part", n + 1],
  "Generation" :> data["EventGenerations"]["Part", n + 1]
|>;

parseElementRules[data_][rules : {(_Rule | _RuleDelayed)..}] :=
  #1[n_] :> Replace[#1[n], Append[rules /. #2[data, n], _ -> ""]] & @@@
    {{MultihistoryToken, tokenPropertyRules}, {MultihistoryEvent, eventPropertyRules}};
