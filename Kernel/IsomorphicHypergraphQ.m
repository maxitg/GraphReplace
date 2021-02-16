Package["SetReplace`"]

PackageImport["GeneralUtilities`"]

PackageExport["IsomorphicHypergraphQ"]

(* Documentation *)

SetUsage @ "
IsomorphicHypergraphQ[hypergraph$1, hypergraph$2] yields True if hypergraph$1 and hypergraph$2 are isomorphic, and \
False otherwise.
";

(* SyntaxInformation *)
SyntaxInformation[IsomorphicHypergraphQ] =
  {"ArgumentsPattern" -> {hypergraph1_, hypergraph2_}};

(* Argument count *)
IsomorphicHypergraphQ[args___] := 0 /;
  !Developer`CheckArgumentCount[IsomorphicHypergraphQ[args], 2, 2] && False;

(* main *)
expr : IsomorphicHypergraphQ[hypergraph1_, hypergraph2_] := ModuleScope[
  res = Catch[isomorphicHypergraphQ[HoldForm @ expr, hypergraph1, hypergraph2]];
  res /; res =!= $Failed
];

(* Normal form *)
isomorphicHypergraphQ[_, hypergraph1_ ? hypergraphQ, hypergraph2_ ? hypergraphQ] := With[{
    graph1 = HypergraphToGraph[hypergraph1, "StructurePreserving"],
    graph2 = HypergraphToGraph[hypergraph2, "StructurePreserving"]},
  IsomorphicGraphQ[graph1, graph2]
];

(* Incorrect arguments messages *)
isomorphicHypergraphQ[expr_, _ ? (Not @* hypergraphQ), _] :=
  (Message[IsomorphicHypergraphQ::invalidHypergraph, 1, HoldForm @ expr];
  Throw[$Failed]);

isomorphicHypergraphQ[expr_, _, _? (Not @* hypergraphQ)] :=
  (Message[IsomorphicHypergraphQ::invalidHypergraph, 2, HoldForm @ expr];
  Throw[$Failed]);
