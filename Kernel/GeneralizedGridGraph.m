Package["SetReplace`"]

PackageImport["GeneralUtilities`"]

PackageExport["GeneralizedGridGraph"]

(* Documentation *)

SetUsage @ "
GeneralizedGridGraph[{size$1, size$2, $$, size$k}] gives the k$-dimensional grid graph with \
size$1 \[Times] size$2 \[Times] $$ size$k vertices.
GeneralizedGridGraph[{$$, size$k -> 'Circular', $$}] makes the grid wrap around in k$-th dimension.
GeneralizedGridGraph[{$$, size$k -> 'Directed', $$}] makes the edges directed in k$-th dimension.
GeneralizedGridGraph[{$$, size$k -> {'Circular', 'Directed'}, $$}] makes the grid both circular and directed.
";

Options[GeneralizedGridGraph] = Join[Options[Graph], {"VertexNamingFunction" -> Automatic}];

$vertexNamingFunctions = {Automatic (* IndexGraph *), "Coordinates"};

SyntaxInformation[GeneralizedGridGraph] =
  {"ArgumentsPattern" -> {dimensionSpecs_, OptionsPattern[]}, "OptionNames" -> Options[GeneralizedGridGraph][[All, 1]]};

FE`Evaluate[FEPrivate`AddSpecialArgCompletion["GeneralizedGridGraph" -> {{"Circular", "Directed"}}]];

GeneralizedGridGraph::dimsNotList = "Dimensions specification `` should be a list.";

GeneralizedGridGraph::invalidDimSpec = "Dimension specification `` is invalid.";

(* Implementation *)

GeneralizedGridGraph[args___] := ModuleScope[
  result = Catch[generalizedGridGraph[args]];
  result /; result =!= $Failed
];

generalizedGridGraph[args___] /; !Developer`CheckArgumentCount[GeneralizedGridGraph[args], 1, 1] := Throw[$Failed];

generalizedGridGraph[args_, opts___] /;
    !knownOptionsQ[GeneralizedGridGraph, Defer[GeneralizedGridGraph[args, opts]], {opts}] := Throw[$Failed];

generalizedGridGraph[args_, opts___] /;
    !supportedOptionQ[GeneralizedGridGraph, "VertexNamingFunction", $vertexNamingFunctions, {opts}] := Throw[$Failed];

generalizedGridGraph[dimensionSpecs_List, opts___] :=
  generalizedGridGraphExplicit[toExplicitDimSpec /@ dimensionSpecs, opts];

generalizedGridGraph[dimensionSpecs : Except[_List], opts___] := (
  Message[GeneralizedGridGraph::dimsNotList, dimensionSpecs];
  Throw[$Failed];
);

toExplicitDimSpec[spec_] := toExplicitDimSpec[spec, spec];

toExplicitDimSpec[originalSpec_, n_] := toExplicitDimSpec[originalSpec, n -> {}];

toExplicitDimSpec[originalSpec_, n_ -> spec : Except[_List]] := toExplicitDimSpec[originalSpec, n -> {spec}];

$circularString = "Circular";
$directedString = "Directed";

toExplicitDimSpec[_, n_Integer /; n >= 0 -> spec : {($circularString | $directedString)...}] := {
  n,
  If[MemberQ[spec, $circularString], $$circular, $$linear],
  If[MemberQ[spec, $directedString], $$directed, $$undirected]};

toExplicitDimSpec[originalSpec_, _ -> _List] := (
  Message[GeneralizedGridGraph::invalidDimSpec, originalSpec];
  Throw[$Failed];
);

generalizedGridGraphExplicit[dimensionSpecs_, opts___] := ModuleScope[
  {edgeStyle, vertexNamingFunction} = OptionValue[GeneralizedGridGraph, {opts}, {EdgeStyle, "VertexNamingFunction"}];
  edges = singleDimensionEdges[dimensionSpecs, #] & /@ Range[Length[dimensionSpecs]];
  directionalEdgeStyle = EdgeStyle -> If[
      ListQ[edgeStyle] && Length[edgeStyle] == Length[dimensionSpecs] && AllTrue[edgeStyle, Head[#] =!= Rule &],
    Catenate @ MapThread[Function[{dirEdges, style}, # -> style & /@ dirEdges], {edges, edgeStyle}]
  ,
    Nothing
  ];
  If[GraphQ[#], #, Throw[$Failed]] & @ Graph[
    renameVertices[vertexNamingFunction] @ Graph[
      (* Reversal is needed to be consistent with "GridEmbedding" *)
      If[!ListQ[#], {}, #] & @ Flatten[Outer[v @@ Reverse[{##}] &, ##] & @@ Reverse[Range /@ dimensionSpecs[[All, 1]]]],
      Catenate[edges],
      GraphLayout -> graphLayout[dimensionSpecs],
      directionalEdgeStyle],
    If[directionalEdgeStyle[[2]] === Nothing, {opts}, FilterRules[{opts}, Except[EdgeStyle]]]]
];

renameVertices[Automatic][graph_] := IndexGraph[graph];

renameVertices["Coordinates"][graph_] := VertexReplace[graph, v[coords___] :> {coords}];

graphLayout[{{n1_, $$linear, _}, {n2_, $$linear, _}}] := {"GridEmbedding", "Dimension" -> {n1, n2}};

graphLayout[_] := "SpringElectricalEmbedding";

singleDimensionEdges[dimensionSpecs_, k_] := Catenate[
  singleThreadEdges[dimensionSpecs[[k]], #] & /@
    Flatten[Outer[v, ##] & @@ ReplacePart[Range /@ dimensionSpecs[[All, 1]], k -> {threadDim}]]];

singleThreadEdges[{n_, wrapSpec_, dirSpec_}, thread_] :=
  Replace[dirSpec, {$$directed -> DirectedEdge, $$undirected -> UndirectedEdge}] @@@
    Partition[thread /. threadDim -> # & /@ Range[n], 2, 1, {1, Replace[wrapSpec, {$$linear -> -1, $$circular -> 1}]}];
