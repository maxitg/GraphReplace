BeginTestSection["OrderedHypergraphPlot"]

(* Argument Checks *)

(** Argument count **)

VerificationTest[
  OrderedHypergraphPlot[],
  OrderedHypergraphPlot[],
  {OrderedHypergraphPlot::argx}
]

VerificationTest[
  OrderedHypergraphPlot[{{1, 2}}, {{1, 2}}],
  OrderedHypergraphPlot[{{1, 2}}, {{1, 2}}],
  {OrderedHypergraphPlot::argx}
]

(** Valid edges **)

VerificationTest[
  OrderedHypergraphPlot[1],
  OrderedHypergraphPlot[1],
  {OrderedHypergraphPlot::invalidEdges}
]

VerificationTest[
  OrderedHypergraphPlot[{1, 2}],
  OrderedHypergraphPlot[{1, 2}],
  {OrderedHypergraphPlot::invalidEdges}
]

VerificationTest[
  OrderedHypergraphPlot[{{1, 3}, 2}],
  OrderedHypergraphPlot[{{1, 3}, 2}],
  {OrderedHypergraphPlot::invalidEdges}
]

VerificationTest[
  OrderedHypergraphPlot[{{1, 3}, 6, {2, 4}}],
  OrderedHypergraphPlot[{{1, 3}, 6, {2, 4}}],
  {OrderedHypergraphPlot::invalidEdges}
]

(** PlotStyle is an indexed ColorDataFunction **)

VerificationTest[
  OrderedHypergraphPlot[{{1, 2}, {2, 3}, {3, 1}}, PlotStyle -> Red],
  OrderedHypergraphPlot[{{1, 2}, {2, 3}, {3, 1}}, PlotStyle -> Red],
  {OrderedHypergraphPlot::unsupportedPlotStyle}
]

VerificationTest[
  OrderedHypergraphPlot[{{1, 2}, {2, 3}, {3, 1}}, PlotStyle -> 23],
  OrderedHypergraphPlot[{{1, 2}, {2, 3}, {3, 1}}, PlotStyle -> 23],
  {OrderedHypergraphPlot::unsupportedPlotStyle}
]

VerificationTest[
  OrderedHypergraphPlot[{{1, 2}, {2, 3}, {3, 1}}, PlotStyle -> ColorData["DarkRainbow"]],
  OrderedHypergraphPlot[{{1, 2}, {2, 3}, {3, 1}}, PlotStyle -> ColorData["DarkRainbow"]],
  {OrderedHypergraphPlot::unsupportedPlotStyle}
]

VerificationTest[
  Head[OrderedHypergraphPlot[{{1, 2}, {2, 3}, {3, 1}}, PlotStyle -> ColorData[1]]],
  Graphics
]

(* Implementation *)

(** Simple examples **)

VerificationTest[
  Head[OrderedHypergraphPlot[{{1, 3}, {2, 4}}]],
  Graphics
]

(** Large graphs **)

VerificationTest[
  Head @ OrderedHypergraphPlot @ SetReplace[
    {{0, 1}, {0, 2}, {0, 3}},
    ToPatternRules[
      {{0, 1}, {0, 2}, {0, 3}} ->
      {{4, 5}, {5, 4}, {4, 6}, {6, 4},
        {5, 6}, {6, 5}, {4, 1}, {5, 2}, {6, 3}}],
    #],
  Graphics
] & /@ {10, 5000}

(* Vertices with single-vertex edges colored differently *)

VerificationTest[
  FreeQ[OrderedHypergraphPlot[{{1, 2}}], ColorData[97, #]] & /@ {1, 2, 3},
  {False, True, True}]

VerificationTest[
  FreeQ[OrderedHypergraphPlot[{{1}}], ColorData[97, #]] & /@ {1, 2, 3},
  {True, False, True}]

VerificationTest[
  FreeQ[OrderedHypergraphPlot[{{1}, {1}}], ColorData[97, #]] & /@ {1, 2, 3},
  {True, True, False}]

EndTestSection[]
