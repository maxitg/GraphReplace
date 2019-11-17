<|
  "WolframModelEvolutionObject" -> <|
    "init" -> (
      Attributes[Global`testUnevaluated] = {HoldAll};
      Global`testUnevaluated[args___] := SetReplace`PackageScope`testUnevaluated[VerificationTest, args];

      $largeEvolution = Hold[WolframModel[
        {{0, 1}, {0, 2}, {0, 3}} ->
          {{4, 5}, {5, 6}, {6, 4}, {4, 6}, {6, 5}, {5, 4},
          {4, 1}, {5, 2}, {6, 3},
          {1, 6}, {3, 4}},
        {{0, 0}, {0, 0}, {0, 0}},
        7]];
    ),
    "tests" -> With[{pathGraph17 = Partition[Range[17], 2, 1]}, {
      (** Argument checks **)

      (* Corrupt object *)

      testUnevaluated[
        WolframModelEvolutionObject[],
        {WolframModelEvolutionObject::argx}
      ],

      testUnevaluated[
        WolframModelEvolutionObject[<||>],
        {WolframModelEvolutionObject::corrupt}
      ],

      testUnevaluated[
        WolframModelEvolutionObject[<|a -> 1, b -> 2|>],
        {WolframModelEvolutionObject::corrupt}
      ],

      (* Incorrect property arguments *)

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["$$$UnknownProperty$$$,,,"],
        WolframModelEvolutionObject[___]["$$$UnknownProperty$$$,,,"],
        {WolframModelEvolutionObject::unknownProperty},
        SameTest -> MatchQ
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["GenerationsCount", 3],
        WolframModelEvolutionObject[___]["GenerationsCount", 3],
        {WolframModelEvolutionObject::pargx},
        SameTest -> MatchQ
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["GenerationsCount", 3, 3],
        WolframModelEvolutionObject[___]["GenerationsCount", 3, 3],
        {WolframModelEvolutionObject::pargx},
        SameTest -> MatchQ
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["Generation", 3, 3],
        WolframModelEvolutionObject[___]["Generation", 3, 3],
        {WolframModelEvolutionObject::pargx},
        SameTest -> MatchQ
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["Generation"],
        WolframModelEvolutionObject[___]["Generation"],
        {WolframModelEvolutionObject::pargx},
        SameTest -> MatchQ
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["SetAfterEvent"],
        WolframModelEvolutionObject[___]["SetAfterEvent"],
        {WolframModelEvolutionObject::pargx},
        SameTest -> MatchQ
      ],

      (* Incorrect step arguments *)

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["SetAfterEvent", 16],
        WolframModelEvolutionObject[___]["SetAfterEvent", 16],
        {WolframModelEvolutionObject::eventTooLarge},
        SameTest -> MatchQ
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["SetAfterEvent", -17],
        WolframModelEvolutionObject[___]["SetAfterEvent", -17],
        {WolframModelEvolutionObject::eventTooLarge},
        SameTest -> MatchQ
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["SetAfterEvent", 1.2],
        WolframModelEvolutionObject[___]["SetAfterEvent", 1.2],
        {WolframModelEvolutionObject::eventNotInteger},
        SameTest -> MatchQ
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["SetAfterEvent", "good"],
        WolframModelEvolutionObject[___]["SetAfterEvent", "good"],
        {WolframModelEvolutionObject::eventNotInteger},
        SameTest -> MatchQ
      ],

      (* Incorrect generation arguments *)

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["Generation", 5],
        WolframModelEvolutionObject[___]["Generation", 5],
        {WolframModelEvolutionObject::generationTooLarge},
        SameTest -> MatchQ
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["Generation", -6],
        WolframModelEvolutionObject[___]["Generation", -6],
        {WolframModelEvolutionObject::generationTooLarge},
        SameTest -> MatchQ
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["Generation", 2.3],
        WolframModelEvolutionObject[___]["Generation", 2.3],
        {WolframModelEvolutionObject::generationNotInteger},
        SameTest -> MatchQ
      ],

      (** Boxes **)

      VerificationTest[
        Head @ ToBoxes @ WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4],
        InterpretationBox
      ],

      (** Implementation of properties **)

      (* Properties *)

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["Properties"],
        _List,
        SameTest -> MatchQ
      ],

      (* EvolutionObject *)

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["EvolutionObject"],
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]
      ],

      (* Rules *)

      VerificationTest[
        WolframModel[
          <|"PatternRules" -> {{a_, b_}, {b_, c_}} :> {{a, c}}|>,
          pathGraph17,
          4]["Rules"],
        <|"PatternRules" -> {{a_, b_}, {b_, c_}} :> {{a, c}}|>
      ],

      VerificationTest[
        WolframModel[
          {{{1, 2}, {2, 3}} -> {{1, 3}}, {{1, 2}} -> {{1, 3}, {3, 2}}},
          pathGraph17,
          4]["Rules"],
        {{{1, 2}, {2, 3}} -> {{1, 3}}, {{1, 2}} -> {{1, 3}, {3, 2}}}
      ],

      VerificationTest[
        WolframModel[1 -> 2, {1}, 4]["Rules"],
        1 -> 2
      ],

      (* GenerationsCount *)

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["GenerationsCount"],
        4
      ],

      (* EventsCount *)

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["EventsCount"],
        15
      ],

      (* SetAfterEvent *)

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["SetAfterEvent", 0],
        pathGraph17
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["SetAfterEvent", 1],
        Join[Partition[Range[3, 17], 2, 1], {{1, 3}}]
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["SetAfterEvent", 2],
        Join[Partition[Range[5, 17], 2, 1], {{1, 3}, {3, 5}}]
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["SetAfterEvent", 14],
        {{1, 9}, {9, 17}}
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["SetAfterEvent", -2],
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["SetAfterEvent", 14]
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["SetAfterEvent", 15],
        {{1, 17}}
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["SetAfterEvent", -1],
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["SetAfterEvent", 15]
      ],

      (* FinalState *)

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["FinalState"],
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["SetAfterEvent", -1]
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          0]["FinalState"],
        pathGraph17
      ],

      (* UpdatedStatesList *)

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["UpdatedStatesList"],
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["SetAfterEvent", #] & /@ Range[0, 15]
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          0]["UpdatedStatesList"],
        {pathGraph17}
      ],

      (* Generation *)

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["Generation", 0],
        pathGraph17
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["Generation", 1],
        Partition[Range[1, 17, 2], 2, 1]
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["Generation", 2],
        Partition[Range[1, 17, 4], 2, 1]
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["Generation", 3],
        {{1, 9}, {9, 17}}
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["Generation", -2],
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["Generation", 3]
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["Generation", 4],
        {{1, 17}}
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["Generation", -1],
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["Generation", 4]
      ],

      (* StatesList *)

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["StatesList"],
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["Generation", #] & /@ Range[0, 4]
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          0]["StatesList"],
        {pathGraph17}
      ],

      (* AtomsCountFinal *)

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["AtomsCountFinal"],
        2
      ],

      VerificationTest[
        WolframModel[
          1 -> 2,
          {1},
          5]["AtomsCountFinal"],
        1
      ],

      VerificationTest[
        WolframModel[
          1 -> 1,
          {1},
          5]["AtomsCountFinal"],
        1
      ],

      (* AtomsCountTotal *)

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["AtomsCountTotal"],
        17
      ],

      VerificationTest[
        WolframModel[
          1 -> 2,
          {1},
          5]["AtomsCountTotal"],
        6
      ],

      VerificationTest[
        WolframModel[
          1 -> 1,
          {1},
          5]["AtomsCountTotal"],
        1
      ],

      (* ExpressionsCountFinal *)

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["ExpressionsCountFinal"],
        1
      ],

      (* ExpressionsCountTotal *)

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["ExpressionsCountTotal"],
        16 + 8 + 4 + 2 + 1
      ],

      (* CausalGraph *)

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["CausalGraph", 1],
        WolframModelEvolutionObject[___]["CausalGraph", 1],
        {WolframModelEvolutionObject::nonopt},
        SameTest -> MatchQ
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["CausalGraph", 1, "str" -> 3],
        WolframModelEvolutionObject[___]["CausalGraph", 1, "str" -> 3],
        {WolframModelEvolutionObject::nonopt},
        SameTest -> MatchQ
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["CausalGraph", "BadOpt" -> "NotExist"],
        WolframModelEvolutionObject[___]["CausalGraph", "BadOpt" -> "NotExist"],
        {WolframModelEvolutionObject::optx},
        SameTest -> MatchQ
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["CausalGraph"],
        Graph[Range[15], {
          1 -> 9, 2 -> 9, 3 -> 10, 4 -> 10, 5 -> 11, 6 -> 11, 7 -> 12, 8 -> 12,
          9 -> 13, 10 -> 13, 11 -> 14, 12 -> 14,
          13 -> 15, 14 -> 15
        }]
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          4]["CausalGraph", VertexLabels -> "Name", GraphLayout -> "SpringElectricalEmbedding"],
        Graph[Range[15], {
          1 -> 9, 2 -> 9, 3 -> 10, 4 -> 10, 5 -> 11, 6 -> 11, 7 -> 12, 8 -> 12,
          9 -> 13, 10 -> 13, 11 -> 14, 12 -> 14,
          13 -> 15, 14 -> 15
        }, VertexLabels -> "Name", GraphLayout -> "SpringElectricalEmbedding"]
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          pathGraph17,
          1]["CausalGraph"],
        Graph[Range[8], {}]
      ],

      VerificationTest[
        WolframModel[
          {{1, 2}, {2, 3}} -> {{1, 3}},
          Partition[Range[17], 2, 1],
          2]["CausalGraph"],
        Graph[Range[12], {1 -> 9, 2 -> 9, 3 -> 10, 4 -> 10, 5 -> 11, 6 -> 11, 7 -> 12, 8 -> 12}]
      ],

      With[{largeEvolution = $largeEvolution}, {
        VerificationTest[
          AcyclicGraphQ[ReleaseHold[largeEvolution["CausalGraph"]]]
        ],

        VerificationTest[
          LoopFreeGraphQ[ReleaseHold[largeEvolution["CausalGraph"]]]
        ],

        VerificationTest[
          Count[VertexInDegree[ReleaseHold[largeEvolution["CausalGraph"]]], 3],
          ReleaseHold[largeEvolution["EventsCount"]] - 1
        ],

        VerificationTest[
          VertexCount[ReleaseHold[largeEvolution["CausalGraph"]]],
          ReleaseHold[largeEvolution["EventsCount"]]
        ],

        VerificationTest[
          GraphDistance[ReleaseHold[largeEvolution["CausalGraph"]], 1, ReleaseHold[largeEvolution["EventsCount"]]],
          ReleaseHold[largeEvolution["GenerationsCount"]] - 1
        ]
      }] /. HoldPattern[ReleaseHold[Hold[expr_]]] :> expr,

      VerificationTest[
        WolframModel[
          {{0, 1}, {0, 2}, {0, 3}} ->
            {{4, 5}, {5, 6}, {6, 4}, {4, 6}, {6, 5}, {5, 4},
            {4, 1}, {5, 2}, {6, 3},
            {1, 6}, {3, 4}},
          {{0, 0}, {0, 0}, {0, 0}},
          3,
          Method -> "Symbolic"]["CausalGraph"],
        WolframModel[
          {{0, 1}, {0, 2}, {0, 3}} ->
            {{4, 5}, {5, 6}, {6, 4}, {4, 6}, {6, 5}, {5, 4},
            {4, 1}, {5, 2}, {6, 3},
            {1, 6}, {3, 4}},
          {{0, 0}, {0, 0}, {0, 0}},
          3,
          Method -> "LowLevel"]["CausalGraph"]
      ]
    }]
  |>
|>
