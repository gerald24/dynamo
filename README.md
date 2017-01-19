# dynamo

A JSON serialization for object graphs. This library will not generate a simple JSON but add some information for types and references.
Thus this library supports circle references, inheritance and object graphs (reference aware).

Dynamo uses [source_gen](https://pub.dartlang.org/packages/source_gen) to generate code. Build steps are needed to setup,

It has no dependency to the 'dart:mirror'.

If you need just simple JSON serialization you might use JsonSerializable from [source_gen](https://pub.dartlang.org/packages/source_gen) instead,
 or [Dartson](https://pub.dartlang.org/packages/dartson). Latter uses code transformers.

Dynamo is rewritten from scratch, but influenced from [Dartson](https://pub.dartlang.org/packages/dartson) ([dartson on github](https://github.com/eredo/dartson)),
 with some [some extensions to Dartson](https://github.com/gerald24/dartson).
  

This is the first working draft - Docu and more enhancement coming soon. Right now see tests for usage.


