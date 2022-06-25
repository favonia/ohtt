# Higher Observational Type Theory

## Overview

This is an implementation in Agda of Higher Observational Type Theory (a.k.a. Observational Homotopy Type Theory, especially in case-insensitive contexts such as github repository names).

It is a "very shallow" embedding using Agda's experimental `--two-level` type theory: the fibrant fragment contains HOTT with a homotopical identity type, while the strict equality of the exo-fragment represents the definitional equality of HOTT.  In addition, we declare most of these definitional equalities to be rewrite rules using Agda's `--rewriting` feature, thereby making them into definitional equalities in Agda and therefore much more practical to use.  These rewrite rules are not globally confluent and potentially break subject reduction, but I believe that when restricted to the HOTT fragment they become so.

This is not a formalization *of* HOTT that can be used to prove metatheorems about it; it is intended as an experimental way to formalize results *in* HOTT.  Of necessity, when setting up the library we must engage with some metatheory, such as postulating the expected admissible equalities and coercing along them to ensure that each rewrite rule is well-typed.  However, we intend to set things up so that when working in the HOTT fragment these coercions always vanish.

In addition to `--rewriting` and `--two-level`, we of course have to use the flag `--without-K` to have any consistent homotopical identity type.  (Note that when combined with `--two-level` this applies only to the fibrant fragment; axiom K is still provable for exo-types.)  We also currently use `--type-in-type` to avoid the bureaucracy of universe polymorphism; eventually we intend to migrate away from this.

## Installation

We depend on several bug-fixes and enhancements to Agda that have not made it into a released version yet (they are slated for 2.6.3), so you will need to compile the development version of Agda.  Indeed, as of 6/24/2022 we depend on Agda pull request [5973](https://github.com/agda/agda/pull/5973) which has not even been merged to the master branch yet, so you should pull the `multiple-rewrite` branch instead.

## Use

Once the library is complete, working in the HOTT fragment should hopefully be like ordinary (homotopical) Agda but with the added computing HOTT identity type.  The main difference is that we must restrict ourselves to the type and term formers whose HOTT behavior (computation laws for identity types and `ap`) has been defined in the library.

This means that we can't use pattern-matching, but must always define functions using eliminators.  It also means that instead of Agda's built-in function types `(x : A) → B x` we must use a wrapper around them denoted `Π[ x ﹕ A ] B x` (and `A ⇒ B` in the non-dependent case), with wrapped abstraction `Λ x ⇛ f` and application `f ⊙ a` (respectively `Λ x ⇒ f` and `f ∙ a` in the non-dependent case).  This applies to the parameters of all definitions.  Thus, for instance, instead of

```agda
swap : (A B : Type) → A × B → B × A
swap (a , b) = (b , a)
```
we must write
```agda
swap : Π[ A ﹕ Type ] Π[ B ﹕ Type ] A × B ⇒ B × A
swap = Λ A ⇛ Λ B ⇛ Λ u ⇒ (snd u , fst u)
```
Note that the colon inside the `Π[_]` is not the usual colon but `0xFE55 SMALL COLON`.  The non-dependent case is definitionally distinct because it has simpler computational behavior (this is open to debate and might change in the future; it's less true right now than it was with a previous attempt that did more explicit coercions and fewer rewrites).

Similarly, we have both dependent sigma-types `Σ[ x ﹕ A ] B x` and non-dependent product types `A × B`.  The latter have pairing `(a , b)` and projections `fst` and `snd`, while the former have pairing `(a ﹐ b)` using `0xFE50 SMALL COMMA` and projections `π₁` and `π₂`.  General inductive and coinductive types are not yet implemented.

The identity type of `x : A` and `y : A` is denoted `x ＝ y` with `0xFF1D FULLWIDTH EQUALS SIGN`, since Agda reserves the ordinary equals sign `=` for definitions, while the commonly-used `≡` has undesired connotations of judgmental equality (or modular congruence).  Indeed, internal to the library we use `≡` for the strict exo-equality (and `≡ᵉ` for the exo-equality on exo-types), although ideally the user should not have to think about this.

The dependent identity type is written `Id B δ x y` and the (dependent) application to an identification is written `ap f δ`.  However, here `δ` is an identification in a *telescope*, and similarly `B` and `f` take a telescope as input.  Telescopes in the library are exotypes, but hopefully the user should be able to avoid working with telescopes by referring to reflexivities instead.  Namely, given `B : A ⇒ Type` (note it belongs to the wrapped function-type), the dependent identity type over `a₂ : a₀ ＝ a₁` is `π₁ ((refl B ⊙ a₀ ⊙ a₁ ∙ a₂) ↓)`.  Similarly, given `f : Π[ x ﹕ A ] B x`, its application to `a₂ : a₀ ＝ a₁` is `refl f ⊙ a₀ ⊙ a₁ ⊙ a₂`.  We may define abbreviations for these.
