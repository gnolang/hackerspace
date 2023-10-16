# SOGNO -- refactor+reflect+gc

> A large VM change proposal to include Reflection, GC, fully-deterministic maps,
> improved debugging, improve performance, defining realm ownership, and
> efficient realm storage, add Unit Tests to many missing areas and possibly,
> fix many outstanding issues

Sogno means "dream" in Italian, and is pronounced with the "gn" cluster in the
same way as "ñ" in Spanish. Check [Wikipedia](https://en.wikipedia.org/wiki/Voiced_palatal_nasal#Palatal_or_alveolo-palatal)
for more info.

The following proposal comprises of a large list of features and
improvements I would like to see and experiment with in the GnoVM. Most of these
have arisen from issues I've encountered working on [GnoChess](https://github.com/gnolang/gnochess).
Reflection is necessary for good JSON encoding, unclear functioning of Realm
Ownership lead to many issues popping up in that regard, and a lack of good
debugging support made finding root causes of issues very hard at times.

The following is a wishlist of large areas I would like to work on myself. The
reason why I am compiling them all together in a big Hackerspace issue is that I
would like to embark on a journey to try to implement this in my own fork on
GitHub, following the [solo voyager](https://github.com/gnolang/guide/pull/32)
workflow already undertaken by many of us in different projects.

The plan would thus be to implement each feature in order on separate branches,
stemming from the `gnolang/gno` master branch directly, and create gradual PRs
comprising the refactor / proposed changes for each feature. The difference from
our normal monorepo workflow, though, is to continue development without
necessarily awaiting for merging on upstream: the goal is to arrive at this
entire featureset being developed and ready to test as early as possible, in
order to have a full "dream" experience for anyone to test and try out.
The idea is to try to create a "next generation" experience for developing Gno
code, where many of the areas that I currently identify as critical are greatly
improved.

I don't intend to create an independent, "spinoff" fork, and for this purpose as
much as possible I'd want for changes on the Gno monorepo to be synced to the fork.
The reader may understand that such big changes not in sync with master entail
spending hours on merge conflicts; but I think I decently know my way around them
and I am prepared for that ;).

The goal is not necessarily to have the _entirety_ of these features merged into
the upstream, as obviously each one of these will need to undergo review &
understand if it is the right way to go independently. I expect some of these to
be merged only after extensive review & changes, and maybe a few rejected after
careful consideration (hopefully deciding for a different approach to tackle the
underlying issue). However, my idea would be that of embarking on a journey to
quickly iterate and try to bring in a timely manner many of the critical changes
I currently see to the Gno language's usability, and the clarity of the
implementation.

A note on contribution and collaboration: if somebody wants to help on any of
the following topics (ie. by also working on the code and iterating quickly with
me) you are welcome to ask me to join & take on a part of the work. I don't need
this to be done all by myslef, I need all of this to be done and working. The
"solo voyager" workflow is referenced only because I still intend to work on a
philosophy of being able to quickly develop a lot of features and reach my
"dream" as early as possible, while not removing the adequate time we need to
review and consider merges on the master branch.

# Rough Plan

Also include efforts relating to NatBind, GoDoc.

Sogno starts from [native bindings](https://github.com/gnolang/gno/pull/859)
being already merged & accepted as the way forward.

**Groundwork** -- on this work depends largely everything that comes afterward,
and so would be done strictly before the rest. All of these can be developed in
parallel & merged independently:

1. Improved Debugging
2. Convert `strconv` to native bindings, as well as all code that uses
   `gonative` currently. \
   _Depends on [native bindings](https://github.com/gnolang/gno/pull/859)._
3. Remove Support for Gonative. \
   _Depends on [native bindings](https://github.com/gnolang/gno/pull/859), and
   previous item._
4. Add support to `gno doc` for `tests/stdlibs/` (new directory with Native
   Bindings). \
   _Depends on [native bindings](https://github.com/gnolang/gno/pull/859)._

**Main work**:

1. Improved TypedValue representation, Realm Storage, and Synchronous Garbage Collection.
2. Maps as AVL trees. \
   _Depends on improved TypedValue repesentation._
3. Substitute the `range` uverse function with a "slice" syntax for maps. (Language change) \
   _Depends on maps as AVL trees._
4. Reflection. \
  _Depends on improved TypedValue representation._

# Groundwork

## Improved Debugging

This is part of the groundwork simply because I see that entering the realm of
"core GnoVM changes" without the right tools is a recipe for disaster, so I want
to make sure to enter with the right tools to inspect problems as they arise,
and possibly iterate on these to create a better deubgging environment for
everyone.

A rough wishlist of a lot of things I want to add:

- Disabling debugging features entirely with build tag `nodebug`. (Should allow
  for a faster release-time Gnovm)
- Breakpoint support (dumping the VM stack, and waiting for user input to resume).
- Granular `DEBUG` flag. Essentially a lot of "flags" that can be enabled, most
  boolean, some with values, everything added as documentation to `docs/`. \
  This includes: show import load time, use file instead of stdout (also as
  "tee", so print+write), debug preprocess?, debug execution?...
- Other things which come to mind during development and seem like good ideas,
  essentially.

This is a bit free-form, mostly because I think that if debugging features
already start being better & more usable, I will have more ideas on how to
improve this. If the set of changes becomes too large, I'll cluster it off onto
a second PR, but the idea is still to create a much better debugging experience
for anyone working on Gno code (not just for us, as core developers).

## Remove support for Gonative

... and move every code that currently uses it to native bindings.

The reason is the following: there currently is a lot of lines of code inside of
the `gnolang` package dedicated to covering the case of `*NativeValue` being
used. The only place where it is used right now is for `strconv` (in live Gno
code) and for injecting some native functions inside of `tests/stdlibs.go`.

This would uniform all code inside of the GnoVM to use native bindings as the
only method to gain data from the "Go world". In other words, inside of `gnovm`,
the only implementation difference there is is that if a function contains a
`NativePkg/NativeName`, then it needs to call that Go code, a
`func(m *gno.Machine)`, in order to get the function's results. That's it.

The desire to have this is to simply remove a lot of lines of code from the
GnoVM for what is essentially duplicate functionality with native bindings; so
removing a lot of code to re-organise and consider when making the successive
changes.

## Add support for `tests/stdlibs` to `gno doc`

The native bindings PR introduced a new directory, `tests/stdlibs`, to include
functions which should exist in the `gno test/run` context, but not outside.
This should be properly documented to `gno doc`. While this is probably some
work that may seem to stray from the "scope" of this proposal, it is actually
instrumental for properly documenting the eventual Breakpoint function, and
possibly `reflect` helpers which may only be useful in test context.

# Main work

## Improved TypedValue representation, Realm Storage, and Synchronous Garbage Collection.

Also known as: the big one -- and where this entire proposal originated from.

The core idea:

- Strictly separate the "storage layer" and the "execution layer" within the
  GnoVM, allowing the VM to run only depending on some "stacks" of types and
  values and _almost_ not `m.Store` (there is one caveat...).
- Convert `TypedValue` to being simply represented in 128 bits (16 bytes), that
  completely identify the package creating the type and its ID, and the realm
  owning the value and its ID.
- Clearly define, also in documentation, how realm storage and ownership is
  defined, what operations copy a value and which ones modify it.
- Create unit tests all along the way to properly test realm storage and
  recovery.
- Make the underlying representation of type information closely matching that
  of Go's `reflect` package, paving the way for `reflect` later and providing a
  familiar API to all who are working on the GnoVM internals.
- Create a canonical way to store realm values which is purely
  deterministic, and removes all unneccessary items by performing reference
  counting -- AKA, garbage collection.

```go
type TypedValue struct {
	TypePackage, TypeID uint32
	ValueRealm, ValueID uint32
}

func (t TypedValue) T(m *Machine) Type
func (t TypedValue) V(m *Machine) Value
```

Understanding why types should be split by package and values should be split by
realm is a lengthy one. For that, see the "Realm Storage" section afterwards.

```go
type Type interface {
	// pretty much the same as reflect.Type
}

// impl of Type where everything panics.
type panicType struct{}

type namedType struct {
	Type
	pkgPath, name string
	methods []Method
}

// string, ints.
type scalarType struct {
	panicType
	kind int8
}

type arrayType struct {
	panicType
	len uint64
	elem Type
}

type sliceType struct {
	panicType
	elem Type
}

type mapType struct {
	panicType
	key, elem Type
}

// ...

type Method struct {}
type StructField struct {}

```

```go
type valuePtr [2]uint32

// possible types (+= means "represents"):
// - uint8/16/32/64: respective integer values (and equivalents),
//   uint8 += bool, uint32 += float32, uint64 += float64.
// - []T of the above, for optimization. []byte += string.
// - valuePtr: *ptr.
// - []valuePtr: slice array struct.
// - map[string]valuePtr: map values. (string is a canonical string value of the underlying key)
//   This will probably be a different, map-like data structure, where we can
//   have range determinism. However, the idea here is that, with another chunk
//   of work, this should be changed to avlTree[string, valuePtr].
// - func([]TypedValue) []TypedValue: closures
//   (likely different internal representation, to allow for encoding)
// - TypedValue: interface value.
//
// NOTE: the preferred value for slices of numeric values is []T, as it
// (likely) significantly speeds up many operations by trying to make them
// at metal-level. The implication is, though, that these are not addressable
// within Gno code. So whenever a value within these slices is referenced, the value
// is subsequently split into []valuePtr (for all values of the slice).
//
// It'll be the GC job to join any []valuePtr back into []T, should their
// underlying values all be unreferenced numerics.
type Value interface{}
```

### Garbage Collection

As part of the initial ideas of the proposal, I quoted that this proposal would
also entail "garbage collection", essentially as a corollary for the underlying
data representation.

The realm storage needs only to encode the "value stacks" after full synchronous GC
has completed. While type information is missing, it could be included (cached)
for performance, but the point is that from an AST, we have a well-defined and
determinstic method to map a name to a value pointer, when executing the GnoVM.

> There is an asterisk with the last paragraph, alas! See the following
> subsection for more details.

For each realm:
- Files are parsed in ascending order.
- Import list is generated (recursively), excluding other realms.
- Top-level declarations are processed (preprocessing stage).
- To each top-level name, starting from the realm, adn then all the imports in
  order, an ID is assigned, and its equivalent value in the valueStack is
  initialized to the zero value.
- Imported realms go through this algorithm.
- Initialization is performed.
- GC is performed.

#### Storage of Data from Unknown Realms

The above model works perfectly if all of the values that are to be stored in a
realm only make references to other realms/packages already known at realm
initialization (ie. before it has started executing). However, there are
patterns where this is not the case.

Consider the following "registration" pattern, similar to one you may see for
webserver routing.

```go
package myrealm

var handlers map[string]*int

func Register(path string, g *int) string) {
	if _, ok := handlers[path]; !ok {
		panic("handler exists at path")
	}
	handlers[path] = g
}
```

Here, myrealm does not know from the beginning what other realms may call it
and register their values through the `Register` function. The realm calling it
probably does; however `myrealm` does not. We need to store an arbitrary number
of values, which can come from an arbitrary number of realms (possibly more than
`2**32`). To tackle this, as an addendum to the above model, I suggest this, to
be used in the above value storage model in places where we can use a
`valuePtr`:

```go
type borrowedValue struct {
	typePackage string
	typeID uint32
	valueRealm string
	valueID uint32
}
```

The idea behind this is that after registering a value through the above
pattern, we don't add a new realm (and possibly package) to the list of realms
and packages to be loaded at startup. `myrealm` may not call all of its
"borrowed values" during every single execution of its functions.

Any `borrowedValue`, if at one point any name "evaluates" it during GnoVM
execution, is "expanded" into a `valuePtr`. If the respective package and/or
realm are not loaded, they are implicitly retrieved and loaded, with their
respective IDs registered and added to each "stack". We may call these
"temporary IDs", and they are deterministic in execution, but not deterministic
_across_ executions (ie. they depend on when a value is loaded, which can change
in a realm's lifetime).

At Garbage Collection, all of the `valuePtr` which point to temporary IDs are
reverted back to their `borrowedValue` representations. Then, the changed data
of the other realms is stored (if changed), as happens for all normally-loaded
realms.

NOTE: this `borrowedValue` will likely be used also for storing closure values.
Closure values are conceptually passed by value (also because no "write"
operations are allowed on them), but they are really references. Closure values
should essentially have:

- What function they point to. (Since we won't likely allow creating functions
  through reflect, this is a reference to a specific `func` literal from a
  package/realm's source code.)
- A set of values that the closure _uses_ (the "scope" of the closure).

While the former probably benefits from its own representation, the latter
should have its `valuePtr`s replaced by `borrowedValue`s.

TO BE ANSWERED:

- If a realmA passes to realmB a `valuePtr` to a "temporary" value (ie. a
  local variable in a function), and realmB stores it, how and where is the
  value persisted, making sure that it is not garbage collected and minimizing
  any cross-realm valuePtr updating.

### Realm Storage, Ownership

The ownership model that I'd like to have here is simple:

- A realm's values are identified by any top-level declarations that it has, as
  well as any top-level declarations by any of its imported packages.
- A realm may read and write any value with its same realm ID.
- A realm may not modify any value with a different realm ID.
- A realm may call any exported function or method in a different realm.
- A closure created by a realm is always executed in the context of the creating
  realm (ie. where the source code for the closure is).
- Like Go, a type implements another package's interface only if it implements all of
  its methods. If the interface contains unexported methods, then that interface
  can only be implemented by types of the same package. \
  Users should still be wary of embedding: if `pkg2.A` implements `pkg2.I`, but
  `pkg2.I` can only be implemented within `pkg2`, `pkg1` may still create a type
  implementing `pkg2.I` if it embeds `pkg2.A` (but it cannot "overwrite" its
  unexported methods).

These rules are crucial for disallowing unauthorized modifications to realms,
while enabling a model whereby any _closure_ can modify values in the realm
where it came from, enabling a setter model if so desired.

One very important part is the first clause: imported packages are scoped to the
realm importing them. This is done partly to tackle the issue by which we were
considering `invar` as an expansion to the language: if package `p/demo/errors`
has the following line:

```go
var ErrorA = errors.New("a")
```

realmA may modify `errors.ErrorA`, however `ErrorA` will _only be modified_ for
realmA; in other words, realmB's `errors.ErrorA` is still the same.
Corollary: the two errors are different pointers; if a realm passes the value of
`ErrorA` to another, then the "paradox" is that `errors.ErrorA (realmA) !=
errors.ErrorB (realmB)`.

Note, however, that we should still be able to compare the two errors. Which
brings us finally to the following corollary: **a value should be
"realm-scoped", but a type should be "package-scoped".**

Most package values will not be changed from their original values. To
account for this, when a package is added to the chain, as well for stdlibs,
their "base state" is cached, and can be referenced when encoding the realm
state (ie. "expand to the cached base state of this pkg"). If a realm does
change the values, then we apply COW, and the cache cannot be used anymore
(unless it somehow reverts to that state, again. This will probably be a
hash).

## Making Map an AVL tree

This is to change the internal representation of a map inside of the VM to go
from being equivalent to the Go map to being, effectively, a balanced binary
tree like the implementation we have in `p/demo/avl`.

The biggest reason is type safety. It is clear to most people working on Gno
code that `avl.Tree`s are very useful, first and foremost because they allow ~
O(1) alphabetical (ordered) iteration on a dataset. However, they are currently
implemented using `interface{}`. Seeing as it is unlikely that we will have
generics by mainnet, I propose we instead re-write the map to use avl.Tree under
the hood, implying the following language changes:

- Access Complexity: O(1) -> O(logN), so mathematically worse, though practically it
  matters less and less as N gets larger. \
  If O(1) complexity is an absolute requirement, it can be worked back in
  (supporting hashmap, mapping key -> btree indexes).
- Ranges: converted to alphabetic, fully deterministic, still O(1).

A couple features from p/demo/avl would need to be dropped, with the Go map
implementation, namely "subranges", "offsets", reverse iteration. I propose the
two following builtin functions:

- **`func submap(m map[K]V, start, end int) map[K]V`** \
  Creates a "slice" of the map, from [start;end). If start > end, iteration is
  done in reverse, (start;end]. Both values must be contained in [0;len(map))
  (or panic otherwise).
- **`func offset(m map[K]V, v K) int`** \
  Determine the offset of v in m. Returns -1 if not found.

These are "smaller" language changes, which don't significantly change the
grammar per se, more than the semantics. However, I do have another proposal
which would change the grammar:

## Adding "slice range" to maps

To remove the need for `submap`, my proposal is to extend the [Slice
Expression](https://go.dev/ref/spec#Slice_expressions) specification to allow
it to do the `submap` operation outlined above, with the same semantics allowing
for reverse iteration.

(This can probably be done without changes at the parser-level, still, but it
involves a significant shift from Go's behaviour, which is why it is a separate
part in the proposal.)

## Reflection

And finally, reflection!

The proposal here is to conservatively add reflection features. What I would see
right now are the following features, with same (or similar) API to Go:

- `reflect.TypeOf`, returning a `reflect.Type` (probably mostly the same,
  perhaps without the channel-specific methods).
- `reflect.ValueOf`, returning a `reflect.Value`, for now in conservative
  read-only mode.

Both TypeOf and ValueOf can only be called with values which are recursively
owned by the calling realm.
