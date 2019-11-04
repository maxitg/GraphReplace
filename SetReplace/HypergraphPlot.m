Package["SetReplace`"]

PackageExport["HypergraphPlot"]

(* Documentation *)

HypergraphPlot::usage = usageString[
	"HypergraphPlot[`s`, `opts`] plots a list of vertex lists `s` as a hypergraph."]

SyntaxInformation[HypergraphPlot] = {"ArgumentsPattern" -> {_, OptionsPattern[]}};

Options[HypergraphPlot] = Join[{
	"EdgeType" -> "CyclicOpen",
	GraphHighlight -> {},
	GraphLayout -> "SpringElectricalPolygons",
	VertexCoordinates -> {},
	VertexLabels -> None},
	Options[Graphics]];

$edgeTypes = {"Ordered", "CyclicClosed", "CyclicOpen"};
$graphLayouts = {"SpringElectricalEmbedding", "SpringElectricalPolygons"};

(* Messages *)

HypergraphPlot::notImplemented =
	"Not implemented: `1`.";

HypergraphPlot::invalidEdges =
	"First argument of HypergraphPlot must be list of lists, where elements represent vertices.";

HypergraphPlot::invalidFiniteOption =
	"Value `2` of option `1` should be one of `3`.";

HypergraphPlot::invalidCoordinates =
	"Coordinates `1` should be a list of rules from vertices to pairs of numbers.";

HypergraphPlot::invalidHighlight =
	"GraphHighlight value `1` should be a list of vertices and edges.";

(* Evaluation *)

func : HypergraphPlot[args___] := Module[{result = hypergraphPlot$parse[args]},
	If[Head[result] === hypergraphPlot$failing,
		Message[HypergraphPlot::notImplemented, Defer[func]];
		result = $Failed];
	result /; result =!= $Failed
]

(* Arguments parsing *)

hypergraphPlot$parse[args___] /; !Developer`CheckArgumentCount[HypergraphPlot[args], 1, 1] := $Failed

hypergraphPlot$parse[edges : Except[{___List}], o : OptionsPattern[]] := (
	Message[HypergraphPlot::invalidEdges];
	$Failed
)

hypergraphPlot$parse[args : PatternSequence[edges_, o : OptionsPattern[]]] := With[{
		unknownOptions = Complement @@ {{o}, Options[HypergraphPlot]}[[All, All, 1]]},
	If[Length[unknownOptions] > 0,
		Message[HypergraphPlot::optx, unknownOptions[[1]], Defer[HypergraphPlot[args]]]
	];
	$Failed /; Length[unknownOptions] > 0
]

hypergraphPlot$parse[edges_, o : OptionsPattern[]] /;
		! (And @@ (supportedOptionQ[HypergraphPlot, ##, {o}] & @@@ {
			{"EdgeType", $edgeTypes},
			{GraphLayout, $graphLayouts}})) :=
	$Failed

supportedOptionQ[func_, optionToCheck_, validValues_, opts_] := Module[{value, supportedQ},
	value = OptionValue[func, {opts}, optionToCheck];
	supportedQ = MemberQ[validValues, value];
	If[!supportedQ,
		Message[MessageName[func, "invalidFiniteOption"], optionToCheck, value, validValues]
	];
	supportedQ
]

hypergraphPlot$parse[edges_, o : OptionsPattern[]] := Module[{
		result, vertexCoordinates},
	vertexCoordinates = OptionValue[HypergraphPlot, {o}, VertexCoordinates];
	result = If[!MatchQ[vertexCoordinates,
			Automatic |
			{(_ -> {Repeated[_ ? NumericQ, {2}]})...}],
		Message[HypergraphPlot::invalidCoordinates, vertexCoordinates];
		$Failed];
	result /; result === $Failed
]

hypergraphPlot$parse[edges_, o : OptionsPattern[]] := Module[{
		highlight, vertices, validQ},
	highlight = OptionValue[HypergraphPlot, {o}, GraphHighlight];
	vertices = Union[Catenate[edges]];
	validQ = ListQ[highlight] && (And @@ (MemberQ[Join[vertices, edges], #] & /@ highlight));
	If[!validQ, Message[HypergraphPlot::invalidHighlight, highlight]];
	$Failed /; !validQ
]

hypergraphPlot$parse[edges : {___List}, o : OptionsPattern[]] :=
	hypergraphPlot[edges, ##, FilterRules[{o}, Options[Graphics]]] & @@
		(OptionValue[HypergraphPlot, {o}, #] & /@ {
			"EdgeType", GraphHighlight, GraphLayout, VertexCoordinates, VertexLabels})

(* Implementation *)

hypergraphPlot[edges_, edgeType_, highlight_, layout_, vertexCoordinates_, vertexLabels_, graphicsOptions_] := Show[
	drawEmbedding[vertexLabels, highlight] @
		hypergraphEmbedding[edgeType, layout, vertexCoordinates] @
		edges,
	graphicsOptions
]

(** Embedding **)
(** hypergraphEmbedding produces an embedding of vertices and edges. The format is {vertices, edges},
			where both vertices and edges are associations of the form <|vertex -> {graphicsPrimitive, ...}, ...|>,
			where graphicsPrimitive is either a Point, a Line, or a Polygon. **)

(*** SpringElectricalEmbedding ***)

hypergraphEmbedding[edgeType_, layout : "SpringElectricalEmbedding", vertexCoordinates_][edges_] := Module[{
		vertices, vertexEmbeddingNormalEdges, edgeEmbeddingNormalEdges},
	vertices = Union[Catenate[edges]];
	vertexEmbeddingNormalEdges = toNormalEdges[edgeType] /@ edges;
	edgeEmbeddingNormalEdges = If[edgeType === "CyclicOpen",
		If[# === {}, Identity[#], Most[#]] & /@ # &,
		Identity][
			vertexEmbeddingNormalEdges];
	normalToHypergraphEmbedding[
		edges,
		edgeEmbeddingNormalEdges,
		graphEmbedding[
			vertices,
			Catenate[vertexEmbeddingNormalEdges],
			Catenate[edgeEmbeddingNormalEdges],
			layout,
			vertexCoordinates]]
]

toNormalEdges["Ordered"][hyperedge_] :=
	DirectedEdge @@@ Partition[hyperedge, 2, 1]

toNormalEdges["CyclicOpen" | "CyclicClosed"][hyperedge : Except[{}]] :=
	DirectedEdge @@@ Append[Partition[hyperedge, 2, 1], hyperedge[[{-1, 1}]]]

toNormalEdges["CyclicOpen" | "CyclicClosed"][{}] := {}

graphEmbedding[vertices_, vertexEmbeddingEdges_, edgeEmbeddingEdges_, layout_, coordinateRules_] := Module[{embedding},
	embedding = constrainedGraphEmbedding[Graph[vertices, vertexEmbeddingEdges], layout, coordinateRules];
	graphEmbedding[vertices, edgeEmbeddingEdges, layout, embedding]
]

constrainedGraphEmbedding[graph_, layout_, coordinateRules_] := Module[{
		indexGraph, vertexToIndex, relevantCoordinateRules, graphPlot, graphPlotCoordinateRules, displacement},
	indexGraph = IndexGraph[graph];
	vertexToIndex = Thread[VertexList[graph] -> VertexList[indexGraph]];
	relevantCoordinateRules =
		Normal[Merge[Select[MemberQ[vertexToIndex[[All, 1]], #[[1]]] &][coordinateRules], Last]];
	graphPlot = GraphPlot[
		indexGraph, {
		Method -> layout,
		PlotTheme -> "Classic",
		If[Length[relevantCoordinateRules] > 1,
			VertexCoordinateRules ->
				Thread[(relevantCoordinateRules[[All, 1]] /. vertexToIndex) ->
					relevantCoordinateRules[[All, 2]]],
			Nothing]}];
	graphPlotCoordinateRules = VertexCoordinateRules /. Cases[graphPlot, _Rule, Infinity];
	If[Length[relevantCoordinateRules] != 1,
		graphPlotCoordinateRules,
		displacement =
			relevantCoordinateRules[[1, 2]] -
			(relevantCoordinateRules[[1, 1]] /. Thread[VertexList[graph] -> graphPlotCoordinateRules]);
		# + displacement & /@ graphPlotCoordinateRules
	]
]

graphEmbedding[vertices_, edges_, layout_, coordinates_] := Replace[
	Reap[
		GraphPlot[
			Graph[vertices, edges],
			GraphLayout -> layout,
			VertexCoordinates -> coordinates,
			VertexShapeFunction -> (Sow[#2 -> #, "v"] &),
			EdgeShapeFunction -> (Sow[#2 -> #, "e"] &)],
		{"v", "e"}][[2]],
	el : Except[{}] :> el[[1]],
	{1}
]

normalToHypergraphEmbedding[edges_, normalEdges_, normalEmbedding_] := Module[{
		vertexEmbedding, indexedHyperedges, normalEdgeToIndexedHyperedge, normalEdgeToLinePoints, lineSegments,
		indexedHyperedgesToLineSegments, edgeEmbedding, singleVertexEdges, singleVertexEdgeEmbedding},
	vertexEmbedding = #[[1]] -> {Point[#[[2]]]} & /@ normalEmbedding[[1]];

	indexedHyperedges = MapIndexed[{#, #2} &, edges];
	(* vertices in the normalEdges should already be sorted by now. *)
	normalEdgeToIndexedHyperedge = Sort[Catenate[MapThread[Thread[#2 -> Defer[#]] &, {indexedHyperedges, normalEdges}]]];

	normalEdgeToLinePoints = Sort[If[Head[#] === DirectedEdge, #, Sort[#]] & /@ normalEmbedding[[2]]];
	lineSegments = Line /@ normalEdgeToLinePoints[[All, 2]];

	indexedHyperedgesToLineSegments =
		#[[1, 1]] -> #[[2]] & /@
			Normal[Merge[Thread[normalEdgeToIndexedHyperedge[[All, 2]] -> lineSegments], Identity]];
	edgeEmbedding = #[[1, 1]] -> #[[2]] & /@ indexedHyperedgesToLineSegments;

	singleVertexEdges = Cases[edges[[Position[normalEdges, {}, 1][[All, 1]]]], Except[{}], 1];
	singleVertexEdgeEmbedding = (# -> (#[[1]] /. vertexEmbedding)) & /@ singleVertexEdges;

	{vertexEmbedding, Join[edgeEmbedding, singleVertexEdgeEmbedding]}
]

(*** SpringElectricalPolygons ***)

hypergraphEmbedding[edgeType_, layout : "SpringElectricalPolygons", vertexCoordinates_][edges_] := Module[{
		embeddingWithNoRegions, vertexEmbedding, edgePoints, edgePolygons, edgeEmbedding},
	embeddingWithNoRegions = hypergraphEmbedding[edgeType, "SpringElectricalEmbedding", vertexCoordinates][edges];
	vertexEmbedding = embeddingWithNoRegions[[1]];
	edgePoints =
		Flatten[#, 2] & /@ (embeddingWithNoRegions[[2, All, 2]] /. {Line[pts_] :> {pts}, Point[pts_] :> {{pts}}});
	edgePolygons = Map[
		Polygon,
		Map[
			With[{region = ConvexHullMesh[Map[# + RandomReal[1.*^-10] &, #, {2}]]},
				Table[MeshCoordinates[region][[polygon]], {polygon, MeshCells[region, 2][[All, 1]]}]
			] &,
			edgePoints],
		{2}];
	edgeEmbedding = MapThread[#1[[1]] -> Join[#1[[2]], #2] &, {embeddingWithNoRegions[[2]], edgePolygons}];
	{vertexEmbedding, edgeEmbedding}
]

(** Drawing **)

$highlightColor = Hue[1.0, 1.0, 0.7];
$edgeColor = Hue[0.6, 0.7, 0.5];
$vertexColor = Hue[0.6, 0.2, 0.8];

drawEmbedding[vertexLabels_, highlight_][embedding_] := Module[{
		plotRange, vertexSize, arrowheadsSize, embeddingShapes, vertexPoints, lines, polygons, polygonBoundaries,
		edgePoints, labels, singleVertexEdgeCounts, getSingleVertexEdgeRadius},
	plotRange = #2 - #1 & @@ MinMax[embedding[[1, All, 2, 1, 1, 1]]];
	vertexSize = computeVertexSize[plotRange];
	arrowheadsSize = computeArrowheadsSize[Length[embedding[[1]]], plotRange, vertexSize];

	embeddingShapes = Map[
		#[[2]] /. (h : (Point | Line | Polygon))[pts_] :> highlighted[h[pts], MemberQ[highlight, #[[1]]]] &,
		embedding,
		{2}];

	vertexPoints = Cases[embeddingShapes[[1]], #, All] & /@ {
		highlighted[Point[p_], h_] :> {
			If[h,
				Directive[$highlightColor, EdgeForm[Directive[$highlightColor, Opacity[1]]]],
				Directive[$vertexColor, EdgeForm[Directive[GrayLevel[0], Opacity[0.7]]]]
			],
			Disk[p, vertexSize]}
	};

	singleVertexEdgeCounts = <||>;
	getSingleVertexEdgeRadius[coords_] := (
		singleVertexEdgeCounts[coords] = Lookup[singleVertexEdgeCounts, Key[coords], vertexSize] + vertexSize
	);

	{lines, polygons, polygonBoundaries, edgePoints} = Cases[embeddingShapes[[2]], #, All] & /@ {
		highlighted[Line[pts_], h_] :> {
			If[h,
				Directive[Opacity[1], $highlightColor],
				Directive[Opacity[0.7], $edgeColor]
			],
			Arrowheads[arrowheadsSize],
			Arrow[pts]},
		highlighted[Polygon[pts_], h_] :> {
			Opacity[0.3],
			If[h,
				$highlightColor,
				Lighter[$edgeColor, 0.7]
			],
			Polygon[pts]},
		highlighted[Polygon[pts_], h_] :> {
			EdgeForm[White],
			Transparent,
			Polygon[pts]},
		highlighted[Point[p_], h_] :> {
			If[h,
				Directive[Opacity[1], $highlightColor],
				Directive[Opacity[0.7], $edgeColor]
			],
			Circle[p, getSingleVertexEdgeRadius[p]]}
	};

	(* would only work if coordinates consist of a single point *)
	labels = If[VertexLabels === None,
		Nothing,
		GraphPlot[
			Graph[embedding[[1, All, 1]], {}],
			VertexCoordinates -> embedding[[1, All, 2, 1, 1]],
			VertexLabels -> vertexLabels,
			VertexShapeFunction -> None,
			EdgeShapeFunction -> None]];
	Show[Graphics[{polygons, polygonBoundaries, lines, vertexPoints, edgePoints}], labels]
]

(*** Arrowhead and vertex sizes are approximately the same as GraphPlot ***)
computeArrowheadsSize[vertexCount_ ? (# <= 20 &), plotRange_, vertexSize_] := Medium
computeArrowheadsSize[vertexCount_ ? (# > 20 &), plotRange_, vertexSize_] := 1.25 * 2 * vertexSize / plotRange

computeVertexSize[plotRange_] := 0.15 - 2. * 1 / (plotRange + 13.7)
