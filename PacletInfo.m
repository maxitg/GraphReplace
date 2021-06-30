(* ::Package:: *)

Paclet[
  Name -> "SetReplace",
  Version -> "0.3",
  MathematicaVersion -> "12.3+", (* Check MultisetSubstitutionSystem understands all new patterns before upgrading. *)
  Description -> "SetReplace implements WolframModel and other functions used in the Wolfram Physics Project.",
  Creator -> "Wolfram Research",
  URL -> "https://github.com/maxitg/SetReplace",
  SystemID -> {"MacOSX-x86-64", "Linux-x86-64", "Windows-x86-64", "MacOSX-ARM64"},
  Extensions -> {
    {"Kernel", Context -> "SetReplace`"},
    {"LibraryLink"}
  }
]
