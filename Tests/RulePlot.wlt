<|
  "RulePlot" -> <|
    "init" -> (
      Attributes[Global`testUnevaluated] = Attributes[Global`testSymbolLeak] = {HoldAll};
      Global`testUnevaluated[args___] := SetReplace`PackageScope`testUnevaluated[VerificationTest, args];
      Global`testSymbolLeak[args___] := SetReplace`PackageScope`testSymbolLeak[VerificationTest, args];
      Global`checkGraphics[args___] := SetReplace`PackageScope`checkGraphics[args];
      Global`graphicsQ[args___] := SetReplace`PackageScope`graphicsQ[args];

      $rulesForVertexSizeConsistency = {
        {{1}} -> {{1}},
        {{1}} -> {{2}},
        {{1, 2}} -> {{1}},
        {{1, 2}} -> {{1, 2}},
        {{1, 2, 3}} -> {{1}},
        {{1, 2, 3}} -> {{1, 2}},
        {{1}, {2}} -> {{2}, {3}},
        {{1}, {2}, {3}} -> {{2}, {3}, {4}},
        {{1, 2, 3}} -> {{3, 4, 5}},
        {{1, 2, 3}} -> {{1, 2}, {2, 3}},
        {{1, 2, 3}} -> {{2, 3}, {3, 4}}};

      aspectRatio[{{xMin_, xMax_}, {yMin_, yMax_}}] := (yMax - yMin) / (xMax -xMin);

      checkAspectRatio[graphics_, answer_, tolerance_, count_] := VerificationTest[
        count <= Length[
          Select[Abs[# - answer] <= tolerance &][
            aspectRatio[CoordinateBounds[#[[1]]]] & /@
              Select[Length[#[[1]]] == 5 && Abs[Norm[#[[1, 1]] - #[[-1, 1]]]] < 0.001 &] @
                Cases[graphics, _Line, All]]]];
    ),
    "tests" -> {
      (* Symbol Leak *)

      testSymbolLeak[
        SeedRandom[123];
        RulePlot[WolframModel[Rule @@ RandomInteger[100, {2, 50, 3}]]]
      ],

      (* Rule correctness checking *)

      testUnevaluated[
        RulePlot[WolframModel[1]],
        {RulePlot::invalidRules}
      ],

      testUnevaluated[
        RulePlot[WolframModel[1 -> 2]],
        {RulePlot::notHypergraphRule}
      ],

      testUnevaluated[
        RulePlot[WolframModel[{1} -> {2}]],
        {RulePlot::notHypergraphRule}
      ],

      testUnevaluated[
        RulePlot[WolframModel[{{1}} -> {2}]],
        {RulePlot::notHypergraphRule}
      ],

      VerificationTest[
        graphicsQ[RulePlot[WolframModel[{{1}} -> {{2}}]]]
      ],

      testUnevaluated[
        RulePlot[WolframModel[<|"PatternRules" -> {{1}} -> {{2}}|>]],
        {RulePlot::patternRules}
      ],

      VerificationTest[
        graphicsQ[RulePlot[WolframModel[{{1}} -> {{2}}, Method -> "$$$AnyMethod$$$"]]]
      ],

      testUnevaluated[
        RulePlot[WolframModel[{{{1}} -> {{2}}, 1}]],
        {RulePlot::invalidRules}
      ],

      testUnevaluated[
        RulePlot[WolframModel[{{{1}} -> {{2}}, 1 -> 2}]],
        {RulePlot::notHypergraphRule}
      ],

      VerificationTest[
        graphicsQ[RulePlot[WolframModel[{{{1}} -> {{2}}, {{1}} -> {{2}}}]]]
      ],

      (** malformed WolframModelEvolutionObject **)

      testUnevaluated[
        RulePlot[WolframModelEvolutionObject[]],
        {WolframModelEvolutionObject::argx}
      ],

      testUnevaluated[
        RulePlot[WolframModelEvolutionObject[<|"Version" -> 2|>]],
        {WolframModelEvolutionObject::corrupt}
      ],

      (* Options *)

      (** EdgeType **)

      VerificationTest[
        graphicsQ[RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], "EdgeType" -> #]]
      ] & /@ {"Ordered", "Cyclic"},

      testUnevaluated[
        RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], "EdgeType" -> "Invalid"],
        {RulePlot::invalidEdgeType}
      ],

      testUnevaluated[
        RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], "EdgeType" -> 3],
        {RulePlot::invalidEdgeType}
      ],

      (** GraphhighlightStyle **)

      VerificationTest[
        !graphicsQ[RulePlot[WolframModel[{{1, 2, 3}, {3, 4, 5}} -> {{3, 4, 5}, {5, 6, 7}}], GraphHighlightStyle -> 1]]
      ],

      VerificationTest[
        With[{
            color = RGBColor[0.4, 0.6, 0.2]},
          FreeQ[checkGraphics @ RulePlot[WolframModel[#], GraphHighlightStyle -> color], color] & /@
            {{{1}} -> {{2}}, {{1}} -> {{1}}, {{1, 2}} -> {{1, 2}}, {{1, 2}} -> {{2, 3}}, {{1, 2}} -> {{3, 4}}}],
        {True, False, False, False, True}
      ],

      (** HyperedgeRendering **)

      VerificationTest[
        graphicsQ[RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], "HyperedgeRendering" -> #]]
      ] & /@ {"Subgraphs", "Polygons"},

      testUnevaluated[
        RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], "HyperedgeRendering" -> "Invalid"],
        {RulePlot::invalidFiniteOption}
      ],

      testUnevaluated[
        RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], "HyperedgeRendering" -> 3],
        {RulePlot::invalidFiniteOption}
      ],

      (** VertexCoordinates **)

      VerificationTest[
        SameQ @@
          Cases[
            checkGraphics @ RulePlot[
              WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}],
              VertexCoordinates -> {1 -> {0, 0}, 2 -> {1, 0}, 3 -> {2, 0}, 4 -> {3, 0}, 5 -> {4, 0}}],
            Disk[p_, _] :> p,
            All][[All, 2]]
      ],

      (*** Due to scaling and translation being computed in the frontend instead of ahead of time,
            coordinates on both sides of the rule might be the same. ***)
      VerificationTest[
        Length[
            Union[
              Cases[
                checkGraphics @ RulePlot[
                  WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}],
                  VertexCoordinates -> {1 -> {0, 0}, 2 -> {0, 0}, 3 -> {0, 0}, 4 -> {0, 0}, 5 -> {0, 0}}],
                Disk[p_, _] :> p,
                All]]]
          <= 2
      ],

      VerificationTest[
        graphicsQ[RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], VertexCoordinates -> {}]]
      ],

      testUnevaluated[
        RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], VertexCoordinates -> {1}],
        {RulePlot::invalidCoordinates}
      ],

      (** VertexLabels **)

      VerificationTest[
        Sort[Cases[
          checkGraphics @ RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], VertexLabels -> Automatic],
          Text[i_, ___] :> i,
          All]],
        {1, 2, 3, 3, 4, 5}
      ],

      VerificationTest[
        Length[Cases[
          checkGraphics @ RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], VertexLabels -> x], Text[x, ___], All]],
        6
      ],

      (** Graphics **)

      VerificationTest[
        Background /. AbsoluteOptions[
          checkGraphics @ RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], Background -> Black], Background],
        Black,
        SameTest -> Equal
      ],

      VerificationTest[
        graphicsQ @ RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], Background -> Automatic]
      ],

      (** Frame **)

      VerificationTest[
        graphicsQ[RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], Frame -> #]]
      ] & /@ {False, True, Automatic},

      testUnevaluated[
        RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], Frame -> "Invalid"],
        {RulePlot::invalidFiniteOption}
      ],

      (** FrameStyle **)

      VerificationTest[
        MemberQ[
          Cases[
            checkGraphics @ RulePlot[
              WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], FrameStyle -> RGBColor[0.33, 0.66, 0.77], Frame -> True][[1]],
            _ ? ColorQ,
            All],
          RGBColor[0.33, 0.66, 0.77]]
      ],

      VerificationTest[
        Not @ MemberQ[
          Cases[
            checkGraphics @ RulePlot[
              WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], FrameStyle -> RGBColor[0.33, 0.66, 0.77], Frame -> False][[1]],
            _ ? ColorQ,
            All],
          RGBColor[0.33, 0.66, 0.77]]
      ],

      (** PlotLegends **)

      VerificationTest[
        MatchQ[
          checkGraphics @ RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], PlotLegends -> "Text"],
          Legended[_, Placed[StandardForm[{{1, 2, 3}} -> {{3, 4, 5}}], Below]]]
      ],

      VerificationTest[
        MatchQ[
          checkGraphics @ RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], PlotLegends -> "test"],
          Legended[_, "test"]]
      ],

      VerificationTest[
        Not @ MatchQ[checkGraphics @ RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}]], Legended[___]]
      ],

      (** Spacings **)

      VerificationTest[
        graphicsQ[RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], Spacings -> #]]
      ] & /@ {0, 1, {{1, 0}, {0, 0}}, {{0, 1}, {0, 0}}, {{0, 0}, {1, 0}}, {{0, 0}, {0, 1}}},

      VerificationTest[
        graphicsQ[RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], Spacings -> #]]
      ] & /@ {1, {{1, 1}, {1, 1}}},

      testUnevaluated[
        RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], Spacings -> #],
        {RulePlot::invalidSpacings}
      ] & /@ {
        "Incorrect",
        {1, 1},
        {{1, 2}, 1},
        {1, {1, 2}},
        {{1, 2, 3}, {1, 2}},
        {{1, {2, 3}}, {1, 2}}
      },

      (** Style options **)

      SeedRandom[911];
      With[{color = RandomColor[]},
        VerificationTest[
          !FreeQ[checkGraphics @ RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], #], color]
        ] & /@ {
          PlotStyle -> color,
          PlotStyle -> <|1 -> color|>,
          VertexStyle -> color,
          VertexStyle -> <|1 -> color|>,
          EdgeStyle -> color,
          EdgeStyle -> <|{1, 2, 3} -> color|>,
          "EdgePolygonStyle" -> color,
          "EdgePolygonStyle" -> <|{1, 2, 3} -> color|>
        }
      ],

      testUnevaluated[
        RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], PlotStyle -> {1}],
        RulePlot::invalidPlotStyle
      ],

      testUnevaluated[
        RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], # -> {1}],
        RulePlot::elementwiseStyle
      ] & /@ {VertexStyle, EdgeStyle, "EdgePolygonStyle"},

      (** WolframModelEvolutionObject (#230) **)
      VerificationTest[
        RulePlot[WolframModel[{{1, 2}} -> {{1, 3}, {1, 3}, {3, 2}}, {{1, 1}}]],
        RulePlot[WolframModel[{{1, 2}} -> {{1, 3}, {1, 3}, {3, 2}}]]
      ],

      VerificationTest[
        FirstCase[
          checkGraphics @ RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}], VertexSize -> 0.213],
          Disk[_, r_] :> r,
          0, (* default *)
          All],
        0.213
      ],

      VerificationTest[
        4 == #2 / #1 & @@ (FirstCase[
          checkGraphics @ RulePlot[WolframModel[{{1, 2}} -> {{2, 3}}], "ArrowheadLength" -> #],
          p_Polygon :> Area[p],
          0,
          All] & /@ {0.1, 0.2})
      ],

      (* Scaling consistency *)

      (** Vertex amplification **)

      VerificationTest[
        First[Cases[checkGraphics @ RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}]], Disk[_, r_] :> r, All]] >
          First[Cases[checkGraphics @ HypergraphPlot[{{1, 2, 3}}], Disk[_, r_] :> r, All]]
      ],

      (** Consistent vertex sizes **)

      VerificationTest[
        SameQ @@ Cases[checkGraphics @ RulePlot[WolframModel[#]], Disk[_, r_] :> r, All]
      ] & /@ $rulesForVertexSizeConsistency,

      (** Shared vertices are colored **)

      VerificationTest[
        Cases[checkGraphics @ RulePlot[WolframModel[{{1, 2, 3}} -> {{3, 4, 5}}]], _ ? ColorQ, All] =!=
          Cases[checkGraphics @ RulePlot[WolframModel[{{1, 2, 3}} -> {{4, 5, 6}}]], _ ? ColorQ, All]
      ],

      (** RulePartsAspectRatio **)

      With[{
          rule = {{1, 3}} -> {{1, 2}, {2, 3}, {3, 4}, {3, 5}},
          coordinatesNormal = {1 -> {0, 0}, 2 -> {1, 0}, 3 -> {2, 0}, 4 -> {3, -1}, 5 -> {3, 1}},
          coordaintesSquare = {1 -> {0, 0}, 2 -> {1, 0}, 3 -> {2, 0}, 4 -> {3, -1.5}, 5 -> {3, 1.5}},
          coordinatesFlipped = {1 -> {0, 0}, 2 -> {1, 0}, 3 -> {2, 0}, 4 -> {3, -3}, 5 -> {3, 3}},
          coordinatesHorizontal = {1 -> {0, 0}, 2 -> {1, 0}, 3 -> {2, 0}, 4 -> {3, 0}, 5 -> {4, 0}},
          coordinatesVertical = {1 -> {0, 0}, 2 -> {0, 1}, 3 -> {0, 2}, 4 -> {0, 3}, 5 -> {0, 4}}}, {
        testUnevaluated[
          RulePlot[WolframModel[rule], "RulePartsAspectRatio" -> #],
          {RulePlot::invalidAspectRatio}
        ] & /@ {-1, 0, "xxx", xxx},

        VerificationTest[
          SameQ @@ (ImageSizeRaw /.
              Options[
                  checkGraphics @ RulePlot[
                    WolframModel[rule], VertexCoordinates -> coordinatesNormal, "RulePartsAspectRatio" -> #],
                  ImageSizeRaw] & /@
                {0.01, 0.1})
        ],

        Function[coordinates, checkAspectRatio[
            checkGraphics @ RulePlot[
              WolframModel[rule], VertexCoordinates -> coordinates, "RulePartsAspectRatio" -> #],
            #,
            0.001,
            2] & /@
          {0.01, 0.1, 0.5, 0.8, 1, 1.2, 2, 10, 100}] /@ {coordinatesNormal, coordaintesSquare, coordinatesFlipped},

        checkAspectRatio[checkGraphics @ RulePlot[WolframModel[rule], VertexCoordinates -> #1], #2, #3, 2] & @@@ {
          {coordinatesNormal, 2 / 3, 0.1},
          {coordaintesSquare, 1, 0.1},
          {coordinatesFlipped, 2, 0.1},
          {coordinatesHorizontal, 0.2, 0.1},
          {coordinatesVertical, 5, 1}},

        (* outer frame *)
        checkAspectRatio[
            checkGraphics @ RulePlot[WolframModel[Table[rule, #]], Frame -> True, VertexCoordinates -> #2],
            #3,
            0.1,
            1] & @@@ {
          {1, coordinatesNormal, 1 / 3},
          {2, coordinatesNormal, 1 / 6},
          {1, coordaintesSquare, 1 / 2},
          {2, coordaintesSquare, 1 / 4},
          {3, coordaintesSquare, 1 / 6}}
      }]
    },
    "options" -> {
      "Parallel" -> False
    }
  |>
|>
