# wani-example

A minimal example project demonstrating how to use the [`lightblue`](https://github.com/DaisukeBekki/lightblue) package — a logical reasoning and proof search library written in Haskell.

This example defines several test queries (`QType`) and runs `Wani.prove'` for each,  
checking whether the proof search succeeds under different logical settings.

For the correspondence between `U.*` constructors and logical syntax,
see [AST Syntax Table in wani](https://github.com/DaisukeBekki/wani#syntax-correspondence-table).

---

## 🧩 Prerequisites

Make sure you have the following installed:

- **GHC** (≥ 9.8)
- **Stack** (≥ 3.7)

You can verify with:
```bash
ghc --version
stack --version
```

## 🚀 Build and Run

Clone this example repository:

```bash
git clone https://github.com/hinarid/wani-example
cd wani-example
stack run
```
If successful, you should see output similar to:

```vbnet
wani-example: testing lightblue imports
[("q1 id",True),("q2 id with debug",True),("q3 Wanis are green reptiles...",True), ...]
```

## 🧠 Concept
Each query (QType) describes a type-theoretic formula in dependent type style.
Wani.prove' attempts to construct a proof term inhabiting that type.
If a proof exists, the query is considered satisfied.

To explore new examples, you can define your own `QType` values and  
add them to the `questions` list in `Main.hs`.

This example covers:

- Identity functions

- Negation and contradiction

- Simple classical logic examples with DNE

- Toy natural language semantics cases (“Wani are green reptiles” etc.)

## 🔗 Related Repositories

- [lightblue (core library)](https://github.com/DaisukeBekki/lightblue)

- wani-example (this project)

