Package["SetReplace`"]

(* Style definitions are used at import in WolframPhysicsProjectStyleData. (Files are loaded lexicographically.) *)

PackageImport["GeneralUtilities`"]

PackageExport["$SetReplacePlotThemes"]
PackageExport["$WolframPhysicsProjectPlotThemes"]

PackageScope["style"]
PackageScope["$styleNames"]

PackageScope["$lightTheme"]

PackageScope["$typeVertexStyle"]
PackageScope["$typeVertexSize"]
PackageScope["$propertyVertexStyle"]
PackageScope["$propertyVertexSize"]
PackageScope["$methodImplementationVertexStyle"]
PackageScope["$methodImplementationVertexSize"]
PackageScope["$typeGraphEdgeStyle"]
PackageScope["$typeGraphLayout"]
PackageScope["$typeGraphBackground"]
PackageScope["$evolutionObjectIcon"]
PackageScope["$setReplaceTypeDisplayFunction"]
PackageScope["$setReplaceTypeDisplayFunctionVersioned"]
PackageScope["$destroyedEdgeStyle"]
PackageScope["$createdEdgeStyle"]
PackageScope["$destroyedAndCreatedEdgeStyle"]
PackageScope["$eventVertexStyle"]
PackageScope["$tokenVertexStyle"]
PackageScope["$initialEventVertexStyle"]
PackageScope["$finalEventVertexStyle"]
PackageScope["$causalEdgeStyle"]
PackageScope["$tokenEventGraphBackground"]
PackageScope["$vertexSize"]
PackageScope["$arrowheadLengthFunction"]
PackageScope["$edgeArrowheadShape"]
PackageScope["$vertexStyle"]
PackageScope["$edgeLineStyle"]
PackageScope["$edgePolygonStyle"]
PackageScope["$unaryEdgeStyle"]
PackageScope["$vertexStyleFromPlotStyleDirective"]
PackageScope["$edgeLineStyleFromPlotStyleDirective"]
PackageScope["$edgePolygonStyleFromEdgeStyleDirective"]
PackageScope["$highlightedVertexStyleDirective"]
PackageScope["$highlightedEdgeLineStyleDirective"]
PackageScope["$highlightedEdgePolygonStyleDirective"]
PackageScope["$highlightStyle"]
PackageScope["$hyperedgeRendering"]
PackageScope["$hypergraphPlotImageSize"]
PackageScope["$spatialGraphBackground"]
PackageScope["$sharedRuleElementsHighlight"]
PackageScope["$ruleHyperedgeRendering"]
PackageScope["$ruleVertexSize"]
PackageScope["$ruleArrowheadLength"]
PackageScope["$rulePartsAspectRatio"]
PackageScope["$rulePartsAspectRatioMin"]
PackageScope["$rulePartsAspectRatioMax"]
PackageScope["$ruleGraphPadding"]
PackageScope["$ruleSidesSpacing"]
PackageScope["$rulePartsFrameStyle"]
PackageScope["$ruleArrowShape"]
PackageScope["$ruleArrowLength"]
PackageScope["$ruleArrowPadding"]
PackageScope["$ruleArrowStyle"]
PackageScope["$ruleGridColor"]
PackageScope["$ruleImageSizePerPlotRange"]
PackageScope["$ruleBackground"]
PackageScope["$spatialGraph3DVertexStyle"]
PackageScope["$spatialGraph3DEdgeStyle"]
PackageScope["$statesGraphVertexStyle"]
PackageScope["$statesGraphEdgeStyle"]
PackageScope["$statesGraph3DEdgeStyle"]
PackageScope["$evolutionCausalGraphEvolutionEdgeStyle"]
PackageScope["$evolutionCausalGraphCausalEdgeStyle"]
PackageScope["$branchialGraphEdgeStyle"]
PackageScope["$rulialGraphVertexStyle"]
PackageScope["$rulialGraphEdgeStyle"]
PackageScope["$rulialGraphVertexIconFontColor"]
PackageScope["$rulialGraphVertexIconBackground"]
PackageScope["$rulialGraphVertexIconFrameStyle"]
PackageScope["$rulialGraphVertexIconFrameMargins"]
PackageScope["$genericLinePlotStyles"]
PackageScope["$genericGraphEdgeStyle"]
PackageScope["$structurePreservingHyperedgeVertexStyle"]
PackageScope["$structurePreservingHyperedgeToHyperedgeEdgeStyle"]

combinedOptionsProperties[plotFunction_][options__] := Sequence[
  "Options" -> {options},
  "Function" -> (plotFunction[#, options] &)
];

$styleNames = KeySort /@ KeySort @ <|
  "TypeGraph" -> <|
    "TypeVertexStyle" -> $typeVertexStyle,
    "TypeVertexSize" -> $typeVertexSize,
    "PropertyVertexStyle" -> $propertyVertexStyle,
    "PropertyVertexSize" -> $propertyVertexSize,
    "MethodImplementationVertexStyle" -> $methodImplementationVertexStyle,
    "MethodImplementationVertexSize" -> $methodImplementationVertexSize,
    "EdgeStyle" -> $typeGraphEdgeStyle,
    "GraphLayout" -> $typeGraphLayout,
    "Background" -> $typeGraphBackground
  |>,
  "EvolutionObject" -> <|"Icon" -> $evolutionObjectIcon|>,
  "SetReplaceType" -> <|
    "DisplayFunction" -> $setReplaceTypeDisplayFunction,
    "DisplayFunctionVersioned" -> $setReplaceTypeDisplayFunctionVersioned
  |>,
  "SpatialGraph" -> <|
    "DestroyedEdgeStyle" -> $destroyedEdgeStyle,
    "CreatedEdgeStyle" -> $createdEdgeStyle,
    "DestroyedAndCreatedEdgeStyle" -> $destroyedAndCreatedEdgeStyle,
    "VertexSize" -> $vertexSize,
    "ArrowheadLengthFunction" -> $arrowheadLengthFunction,
    "EdgeArrowheadShape" -> $edgeArrowheadShape,
    "VertexStyle" -> $vertexStyle,
    "EdgeLineStyle" -> $edgeLineStyle,
    "EdgePolygonStyle" -> $edgePolygonStyle,
    "UnaryEdgeStyle" -> $unaryEdgeStyle,
    "VertexStyleFromPlotStyleDirective" -> $vertexStyleFromPlotStyleDirective,
    "EdgeLineStyleFromPlotStyleDirective" -> $edgeLineStyleFromPlotStyleDirective,
    "EdgePolygonStyleFromEdgeStyleDirective" -> $edgePolygonStyleFromEdgeStyleDirective,
    "HighlightedVertexStyleDirective" -> $highlightedVertexStyleDirective,
    "HighlightedEdgeLineStyleDirective" -> $highlightedEdgeLineStyleDirective,
    "HighlightedEdgePolygonStyleDirective" -> $highlightedEdgePolygonStyleDirective,
    "HighlightStyle" -> $highlightStyle,
    "HyperedgeRendering" -> $hyperedgeRendering,
    "DefaultImageSize" -> $hypergraphPlotImageSize,
    "Background" -> $spatialGraphBackground,
    combinedOptionsProperties[Graph][VertexStyle -> $vertexStyle, EdgeStyle -> $edgeLineStyle]
  |>,
  "CausalGraph" -> <|
    "VertexStyle" -> $eventVertexStyle,
    "InitialVertexStyle" -> $initialEventVertexStyle,
    "FinalVertexStyle" -> $finalEventVertexStyle,
    "EdgeStyle" -> $causalEdgeStyle,
    "Background" -> $tokenEventGraphBackground,
    combinedOptionsProperties[Graph][VertexStyle -> $eventVertexStyle, EdgeStyle -> $causalEdgeStyle]
  |>,
  "ExpressionsEventsGraph" -> <|
    "EventVertexStyle" -> $eventVertexStyle,
    "ExpressionVertexStyle" -> $tokenVertexStyle,
    "InitialVertexStyle" -> $initialEventVertexStyle,
    "FinalVertexStyle" -> $finalEventVertexStyle,
    "EdgeStyle" -> $causalEdgeStyle,
    "Background" -> $tokenEventGraphBackground
  |>,
  "Rule" -> <|
    "SharedElementHighlight" -> $sharedRuleElementsHighlight,
    "HyperedgeRendering" -> $ruleHyperedgeRendering,
    "VertexSize" -> $ruleVertexSize,
    "ArrowheadLength" -> $ruleArrowheadLength,
    "PartsAspectRatio" -> $rulePartsAspectRatio,
    "PartsAspectRatioMin" -> $rulePartsAspectRatioMin,
    "PartsAspectRatioMax" -> $rulePartsAspectRatioMax,
    "GraphPadding" -> $ruleGraphPadding,
    "SidesSpacing" -> $ruleSidesSpacing,
    "PartsFrameStyle" -> $rulePartsFrameStyle,
    "ArrowShape" -> $ruleArrowShape,
    "ArrowLength" -> $ruleArrowLength,
    "ArrowPadding" -> $ruleArrowPadding,
    "ArrowStyle" -> $ruleArrowStyle,
    "GridColor" -> $ruleGridColor,
    "ImageSizePerPlotRange" -> $ruleImageSizePerPlotRange,
    "Background" -> $ruleBackground
  |>,

  (* For future use *)

  "SpatialGraph3D" -> <|
    "VertexStyle" -> $spatialGraph3DVertexStyle,
    "EdgeLineStyle" -> $spatialGraph3DEdgeStyle,
    combinedOptionsProperties[Graph3D][VertexStyle -> $spatialGraph3DVertexStyle, EdgeStyle -> $spatialGraph3DEdgeStyle]
  |>,

  (* MultiwaySystem styles *)

  "StatesGraph" -> <|
    "VertexStyle" -> $statesGraphVertexStyle,
    "EdgeStyle" -> $statesGraphEdgeStyle,
    combinedOptionsProperties[Graph][VertexStyle -> $statesGraphVertexStyle, EdgeStyle -> $statesGraphEdgeStyle]
  |>,
  "StatesGraph3D" -> <|
    "VertexStyle" -> $statesGraphVertexStyle, (* same as 2D *)
    "EdgeStyle" -> $statesGraph3DEdgeStyle,
    combinedOptionsProperties[Graph][VertexStyle -> $statesGraphVertexStyle, EdgeStyle -> $statesGraph3DEdgeStyle]
  |>,
  "EvolutionCausalGraph" -> <|
    "StateVertexStyle" -> $statesGraphVertexStyle,
    "EvolutionEdgeStyle" -> $evolutionCausalGraphEvolutionEdgeStyle,
    "EventVertexStyle" -> $eventVertexStyle,
    "CausalEdgeStyle" -> $evolutionCausalGraphCausalEdgeStyle
  |>,
  "BranchialGraph" -> <|
    "VertexStyle" -> $statesGraphVertexStyle,
    "EdgeStyle" -> $branchialGraphEdgeStyle,
    combinedOptionsProperties[Graph][VertexStyle -> $statesGraphVertexStyle, EdgeStyle -> $branchialGraphEdgeStyle]
  |>,
  "RulialGraph" -> <|
    "VertexStyle" -> $rulialGraphVertexStyle,
    "EdgeStyle" -> $rulialGraphEdgeStyle,
    "VertexIconFontColor" -> $rulialGraphVertexIconFontColor,
    "VertexIconBackground" -> $rulialGraphVertexIconBackground,
    "VertexIconFrameStyle" -> $rulialGraphVertexIconFrameStyle,
    "VertexIconFrameMargins" -> $rulialGraphVertexIconFrameMargins,
    combinedOptionsProperties[Graph][VertexStyle -> $rulialGraphVertexStyle, EdgeStyle -> $rulialGraphEdgeStyle]
  |>,

  (* Generic plots *)

  "GenericLinePlot" -> <|
    "PlotStyles" -> $genericLinePlotStyles,
    "Options" -> {PlotStyle -> $genericLinePlotStyles}
  |>,
  "GenericGraph" -> <|
    "EdgeStyle" -> $genericGraphEdgeStyle,
    combinedOptionsProperties[Graph][EdgeStyle -> $genericGraphEdgeStyle]
  |>,

  "HypergraphStructurePreservingGraph" -> <|
    "HyperedgeVertexStyle" -> $structurePreservingHyperedgeVertexStyle,
    "HyperedgeToHyperedgeEdgeStyle" -> $structurePreservingHyperedgeToHyperedgeEdgeStyle
  |>
|>;

$lightTheme = "Light";

SetUsage @ "
$SetReplacePlotThemes gives the list of plot themes available in SetReplace.
";

$SetReplacePlotThemes = {$lightTheme};

(* Backwards compatibility *)
SetUsage[$WolframPhysicsProjectPlotThemes,
         "$WolframPhysicsProjectPlotThemes is deprecated. Use $SetReplacePlotThemes."];
$WolframPhysicsProjectPlotThemes = $SetReplacePlotThemes;

style[$lightTheme] = <|
  (* Type graph *)
  $typeVertexStyle -> RGBColor[0.034, 0.30, 0.42],
  $typeVertexSize -> Medium,
  $propertyVertexStyle -> RGBColor[0.77, 0.83, 0.82],
  $propertyVertexSize -> Medium,
  $methodImplementationVertexStyle -> Black,
  $methodImplementationVertexSize -> Small,
  $typeGraphEdgeStyle -> GrayLevel[0.125],
  $typeGraphLayout -> "SpringElectricalEmbedding",
  $typeGraphBackground -> None,

  (* Evolution object *)
  $evolutionObjectIcon -> $graphIcon,

  (* SetReplaceType *)
  $setReplaceTypeDisplayFunction -> (FrameBox[
    PanelBox[
      GridBox[
        {{StyleBox[#1, FontSize -> 13, FontColor -> RGBColor[0.034, 0.3, 0.42], FontWeight -> "SemiBold"]}},
        BaselinePosition -> {1, 1}],
      Background -> RGBColor[0.9517, 0.965, 0.971],
      BaselinePosition -> Baseline,
      FrameMargins -> {{3, 3}, {1.5, 1.5}}],
    FrameMargins -> None,
    FrameStyle -> RGBColor[0.65, 0.65, 0.65],
    BaselinePosition -> Baseline,
    RoundingRadius -> 4] &),

  $setReplaceTypeDisplayFunctionVersioned -> (FrameBox[
    PanelBox[
      GridBox[{{
          StyleBox[#1, FontSize -> 13, FontColor -> RGBColor[0.034, 0.3, 0.42], FontWeight -> "SemiBold"],
          StyleBox[#2, FontColor -> RGBColor[0.517, 0.65, 0.71], FontSize -> 13, FontWeight -> "Plain"]}},
        GridBoxSpacings -> {"Columns" -> {{0.3}}, "Rows" -> {{0}}},
        BaselinePosition -> {1, 1}],
      Background -> RGBColor[0.9517, 0.965, 0.971],
      BaselinePosition -> Baseline,
      FrameMargins -> {{3, 3}, {1.5, 1.5}}],
    FrameMargins -> None,
    FrameStyle -> RGBColor[0.65, 0.65, 0.65],
    BaselinePosition -> Baseline,
    RoundingRadius -> 4] &),

  (* Hypergraph diffs *)
  $destroyedEdgeStyle -> Directive[Hue[0.08, 0, 0.42], AbsoluteDashing[{1, 2}]],
  $createdEdgeStyle -> Directive[Hue[0.02, 0.94, 0.83], Thick],
  $destroyedAndCreatedEdgeStyle -> Directive[Hue[0.02, 0.94, 0.83], Thick, AbsoluteDashing[{1, 3}]],

  (* Causal graph *)
  $eventVertexStyle -> Directive[Hue[0.11, 1, 0.97], EdgeForm[{Hue[0.11, 1, 0.97], Opacity[1]}]],
  $tokenVertexStyle ->
    Directive[Hue[0.63, 0.66, 0.81], Opacity[0.1], EdgeForm[Directive[Hue[0.63, 0.7, 0.5], Opacity[0.7]]]],
  $initialEventVertexStyle ->
    Directive[RGBColor[{0.259, 0.576, 1}], EdgeForm[{RGBColor[{0.259, 0.576, 1}], Opacity[1]}]],
  $finalEventVertexStyle -> Directive[White, EdgeForm[{Hue[0.11, 1, 0.97], Opacity[1]}]],
  $causalEdgeStyle -> Hue[0, 1, 0.56],
  $tokenEventGraphBackground -> None,

  (* HypergraphPlot *)
  $vertexSize -> 0.06,
  $arrowheadLengthFunction -> (Max[0.1, Min[0.185, 0.066 + 0.017 #PlotRange]] &),
  $edgeArrowheadShape -> Polygon[{
    {-1.10196, -0.289756}, {-1.08585, -0.257073}, {-1.05025, -0.178048}, {-1.03171, -0.130243}, {-1.01512, -0.0824391},
    {-1.0039, -0.037561}, {-1., 0.}, {-1.0039, 0.0341466}, {-1.01512, 0.0780486}, {-1.03171, 0.127805},
    {-1.05025, 0.178538}, {-1.08585, 0.264878}, {-1.10196, 0.301464}, {0., 0.}, {-1.10196, -0.289756}}],
  $vertexStyle -> Directive[Hue[0.63, 0.26, 0.89], EdgeForm[Directive[Hue[0.63, 0.7, 0.33], Opacity[0.95]]]],
  $edgeLineStyle -> Directive[Hue[0.63, 0.7, 0.5], Opacity[0.7]],
  $edgePolygonStyle -> Directive[Hue[0.63, 0.66, 0.81], Opacity[0.1], EdgeForm[None]],
  $unaryEdgeStyle -> Directive[Hue[0.63, 0.7, 0.5], Opacity[0.7]],
  $vertexStyleFromPlotStyleDirective -> EdgeForm[Directive[GrayLevel[0], Opacity[0.95]]],
  $edgeLineStyleFromPlotStyleDirective -> Opacity[0.7],
  $edgePolygonStyleFromEdgeStyleDirective -> Directive[Opacity[0.1], EdgeForm[None]],
  $highlightedVertexStyleDirective -> EdgeForm[Directive[GrayLevel[0], Opacity[0.7]]],
  $highlightedEdgeLineStyleDirective -> Opacity[1],
  $highlightedEdgePolygonStyleDirective -> Opacity[0.3],
  $highlightStyle -> Red,
  $hyperedgeRendering -> "Polygons",
  $hypergraphPlotImageSize -> {{360}, {420}},
  $spatialGraphBackground -> None,

  (* RulePlot *)
  $sharedRuleElementsHighlight -> RGBColor[0.5, 0.5, 0.95],
  $ruleHyperedgeRendering -> "Polygons",
  $ruleVertexSize -> 0.1,
  $ruleArrowheadLength -> 0.3,
  $rulePartsAspectRatio -> Automatic,
  $rulePartsAspectRatioMin -> 0.2,
  $rulePartsAspectRatioMax -> 5.0,
  $ruleGraphPadding -> Scaled[0.1],
  $ruleSidesSpacing -> 0.13,
  $rulePartsFrameStyle -> GrayLevel[0.7],
  $ruleArrowShape -> FilledCurve[
    {{{0, 2, 0}, {0, 1, 0}, {0, 1, 0}, {0, 1, 0}, {0, 1, 0}, {0, 1, 0}, {0, 1, 0}, {0, 1, 0}, {0, 1, 0}}},
    {{{-1., 0.1848}, {0.2991, 0.1848}, {-0.1531, 0.6363}, {0.109, 0.8982}, {1., 0.0034}, {0.109, -0.8982},
      {-0.1531, -0.6363}, {0.2991, -0.1848}, {-1., -0.1848}, {-1., 0.1848}}}],
  $ruleArrowLength -> 0.15,
  $ruleArrowPadding -> 0.4,
  $ruleArrowStyle -> GrayLevel[0.65],
  $ruleGridColor -> GrayLevel[0.85],
  $ruleImageSizePerPlotRange -> 128,
  $ruleBackground -> None,

  (* Spatial graph 3D *)
  $spatialGraph3DVertexStyle -> Directive[Hue[0.65, 0.64, 0.68], Specularity[Hue[0.71, 0.6, 0.64], 10]],
  $spatialGraph3DEdgeStyle -> Hue[0.61, 0.3, 0.85],

  (* States graph *)
  $statesGraphVertexStyle -> Directive[Opacity[0.7], Hue[0.62, 0.45, 0.87]],
  $statesGraphEdgeStyle -> Hue[0.75, 0, 0.35],

  (* States graph 3D *)
  $statesGraph3DEdgeStyle -> Directive[Hue[0.62, 0.05, 0.55], Opacity[0.6]],

  (* Evolution causal graph *)
  $evolutionCausalGraphEvolutionEdgeStyle -> Hue[0.75, 0, 0.24],
  $evolutionCausalGraphCausalEdgeStyle -> Hue[0.07, 0.78, 1],

  (* Branchial graph *)
  $branchialGraphEdgeStyle -> Hue[0.89, 0.97, 0.71],

  (* Rulial graph *)
  $rulialGraphVertexStyle -> Directive[Hue[0.54, 0.41, 0.89], EdgeForm[Directive[Hue[0.63, 0.7, 0.33], Opacity[0.95]]]],
  $rulialGraphEdgeStyle -> Hue[0.29, 0.97, 0.71],
  $rulialGraphVertexIconFontColor -> Hue[0.62, 1, 0.48],
  $rulialGraphVertexIconBackground -> Directive[Opacity[0.4], Hue[0.54, 0.41, 0.89]],
  $rulialGraphVertexIconFrameStyle -> Directive[Opacity[0.5], Hue[0.62, 0.52, 0.82]],
  $rulialGraphVertexIconFrameMargins -> {{2, 2}, {0, 0}},

  (* Generic line plot *)
  $genericLinePlotStyles -> {
    Hue[0.985, 0.845, 0.638], Hue[0.050, 0.949, 0.955], Hue[0.089, 0.750, 0.873], Hue[0.060, 1.000, 0.800],
    Hue[0.120, 1.000, 0.900], Hue[0.080, 1.000, 1.000], Hue[0.987, 0.673, 0.733], Hue[0.040, 0.680, 0.940],
    Hue[0.995, 0.989, 0.824], Hue[0.991, 0.400, 0.900]},

  (* Generic graph *)
  $genericGraphEdgeStyle -> Directive[Hue[0.62, 0.3, 0.45], Opacity[0.7], AbsoluteThickness[1.5]],

  (* HypergraphToGraph Structure Preserving *)
  $structurePreservingHyperedgeVertexStyle -> LightBlue,
  $structurePreservingHyperedgeToHyperedgeEdgeStyle -> Dashed
|>;
