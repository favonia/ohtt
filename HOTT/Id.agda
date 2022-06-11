{-# OPTIONS --exact-split --type-in-type --rewriting --two-level --cumulativity --without-K #-}

module HOTT.Id where

open import HOTT.Rewrite
open import HOTT.Telescope

--------------------------------------------------
-- Identity types and identity telescopes
--------------------------------------------------

-- Identity telescopes, collated and bundled.
ID : Tel → Tel

-- We define these mutually together with their projections to the
-- original telescope.
_₀ : {Δ : Tel} → el (ID Δ) → el Δ
_₁ : {Δ : Tel} → el (ID Δ) → el Δ
infix 10 _₀ _₁

-- They are also mutual with the (postulated) dependent/heterogeneous
-- identity *types* that they are composed of.
postulate
  -- Note that these depend on an element of the bundled (ID Δ), which
  -- consists of two points of Δ and an identification between them.
  Id′ : {Δ : Tel} (A : el Δ → Type) (δ : el (ID Δ)) (a₀ : A (δ ₀)) (a₁ : A (δ ₁)) → Type

ID ε = ε
ID (Δ ▸ A) = ID Δ ▸ (λ δ → A (δ ₀)) ▸ (λ δa → A ((pop δa)₁)) ▸ (λ δaa → Id′ A (pop (pop δaa)) (top (pop δaa)) (top δaa))

_₀ {ε} _ = []
_₀ {Δ ▸ A} δ = ((pop (pop (pop δ)))₀) ∷ top (pop (pop δ))

_₁ {ε} _ = []
_₁ {Δ ▸ A} δ = ((pop (pop (pop δ)))₁) ∷ top (pop δ)

----------------------------------------
-- Telescope ap and functoriality, I
----------------------------------------

postulate
  -- Since Id will be definitionally a special case of Id′, we don't
  -- need separate and non-dependent versions of ap.  Note that like
  -- Id′, it depends on an element of the bundled (ID Δ).
  ap : {Δ : Tel} {A : el Δ → Type} (f : (δ : el Δ) → A δ) (δ : el (ID Δ)) → Id′ A δ (f (δ ₀)) (f (δ ₁))

-- Telescope AP.  I hope we can get away with only the non-dependent version.  We'd like to *define* it by recursion on the target telescope:
{-
AP {Δ = ε} f γ = []
AP {Δ = Δ ▸ A} f γ = AP (λ x → pop (f x)) γ ∷
                     coe← (cong A (AP₀ (λ x → pop (f x)) γ)) (top (f (γ ₀))) ∷
                     coe← (cong A (AP₁ (λ x → pop (f x)) γ)) (top (f (γ ₁))) ∷
                     coe→ (Id′-AP (λ x → pop (f x)) γ A (top (f (γ ₀))) (top (f (γ ₁)))) (ap (λ x → top (f x)) γ)
-}
-- However, in order to get ap to compute on variables, we need AP to
-- compute on pop, and if it also computed on arbitrary telescopes
-- that would produce infinite loops.  (You can see an AP-pop in the
-- above definition.)  So instead we "define" it to compute in this
-- way only when the *term* is also of the form ∷.  This requires
-- matching inside a λ, so it has to be done with rewrite rules.  Note
-- that this is a *syntactic* restriction, not a semantic one: since ∷
-- satisfies an eta-rule, the two definitions have the same semantics.
postulate
  AP : {Γ Δ : Tel} (f : el Γ → el Δ) (γ : el (ID Γ)) → el (ID Δ)

-- We define AP mutually with proofs that its projections are the
-- action of the original f on the projections.  We don't need
-- computation rules for these on variables, so we can define them as
-- actual functions that compute only on the telescope Δ, rather than
-- postulates with rewrite rules that restrict computation to terms f
-- that involving ∷.
AP₀ : {Γ Δ : Tel} (f : el Γ → el Δ) (γ : el (ID Γ)) → ((AP f γ)₀) ≡ f (γ ₀)
AP₁ : {Γ Δ : Tel} (f : el Γ → el Δ) (γ : el (ID Γ)) → ((AP f γ)₁) ≡ f (γ ₁)

-- We also define AP mutually with postulated naturality for Id′.
-- This rule should be admissible, meaning we will give rewrite rules
-- making it hold definitionally on all concrete telescopes and terms.
-- Specifically, Id′-AP should compute on types, like Id′.
postulate
  Id′-AP : {Γ Δ : Tel} (f : el Γ → el Δ) (γ : el (ID Γ)) (A : el Δ → Type) (a₀ : A (f (γ ₀))) (a₁ : A (f (γ ₁))) →
    Id′ (λ w → A (f w)) γ a₀ a₁ ≡ Id′ A (AP f γ) (coe← (cong A (AP₀ f γ)) a₀) (coe← (cong A (AP₁ f γ)) a₁)

-- Note that in defining AP, we have to coerce along AP₀, AP₁ and
-- Id′-AP, justifying the mutual definition.
postulate
  APε : {Γ : Tel} (f : el Γ → el ε) (γ : el (ID Γ)) → AP {Δ = ε} f γ ≡ []
  AP∷ : {Γ Δ : Tel} (γ : el (ID Γ)) (f : el Γ → el Δ) (A : el Δ → Type) (g : (x : el Γ) → A (f x)) →
    AP {Δ = Δ ▸ A} (λ x → f x ∷ g x) γ ≡
      AP f γ ∷
      coe← (cong A (AP₀ f γ)) (g (γ ₀)) ∷
      coe← (cong A (AP₁ f γ)) (g (γ ₁)) ∷
      coe→ (Id′-AP f γ A (g (γ ₀)) (g (γ ₁))) (ap g γ)

{-# REWRITE APε AP∷ #-}

-- AP₀ and AP₁ also have to be "defined" on ∷ by matching inside λ.
-- But since ∷ has an eta-rule, and we don't care about preventing
-- computation on non-constructors, it suffices to decompose the
-- argument with top and pop and pass it off to a helper function.
AP₀∷ : {Γ Δ : Tel} (A : el Δ → Type) (f : el Γ → el Δ) (g : (x : el Γ) → A (f x)) (γ : el (ID Γ)) →
  ((AP (λ x → f x ∷ g x) γ)₀) ≡ f (γ ₀) ∷ g (γ ₀)
AP₀∷ A f g γ = ∷≡ʰ A (AP₀ f γ) (coe←≡ʰ (cong A (AP₀ f γ)) (g (γ ₀)))

AP₁∷ : {Γ Δ : Tel} (A : el Δ → Type) (f : el Γ → el Δ) (g : (x : el Γ) → A (f x)) (γ : el (ID Γ)) →
  ((AP (λ x → f x ∷ g x) γ)₁) ≡ f (γ ₁) ∷ g (γ ₁)
AP₁∷ A f g γ = ∷≡ʰ A (AP₁ f γ) (coe←≡ʰ (cong A (AP₁ f γ)) (g (γ ₁)))

AP₀ {Δ = ε} f γ = reflᵉ
AP₀ {Δ = Δ ▸ A} f γ = AP₀∷ A (λ x → pop (f x)) (λ x → top (f x)) γ
AP₁ {Δ = ε} f γ = reflᵉ
AP₁ {Δ = Δ ▸ A} f γ = AP₁∷ A (λ x → pop (f x)) (λ x → top (f x)) γ

-- The proofs of AP₀ and AP₁ imply that they should hold
-- definitionally for all concrete telescopes.  Thus, it is reasonable
-- to assert them as rewrite rules for all telescopens.  Note that
-- they have a volatile LHS, which reduces on concrete or
-- partially-concrete telescopes; but their definitions make them
-- consistent with such reductions.  Thus, they hold definitionally
-- for partially-concrete telescopes as well.
{-# REWRITE AP₀ AP₁ #-}

-- Since AP₀ and AP₁ hold definitionally on abstract telescopes
-- (at least), we can also prove by UIP that they are equal to reflexivity.
AP₀-reflᵉ : {Γ Δ : Tel} (f : el Γ → el Δ) (γ : el (ID Γ)) → AP₀ f γ ≡ reflᵉ
AP₀-reflᵉ f γ = axiomK

AP₁-reflᵉ : {Γ Δ : Tel} (f : el Γ → el Δ) (γ : el (ID Γ)) → AP₁ f γ ≡ reflᵉ
AP₁-reflᵉ f γ = axiomK

-- If we now declare these proofs also as rewrites, then the coercions
-- along AP₀ and AP₁ that we had to insert in the type of Id′-AP and
-- the definition of AP to make them well-typed will disappear.  I
-- think/hope that this won't produce any ill-typed terms, since as
-- noted above AP₀ and AP₁ should hold definitionally on concrete and
-- partially-concrete telescopes and terms too.
{-# REWRITE AP₀-reflᵉ AP₁-reflᵉ #-}

-- A useful derived rule for combining the admissible equality Id′-AP
-- with an equality of base identifications and heterogeneous
-- equalities of the endpoints.
Id′-AP≡ : {Γ Δ : Tel} (f : el Γ → el Δ) (γ : el (ID Γ)) (δ : el (ID Δ)) (e : δ ≡ AP f γ)
    (A : el Δ → Type) {a₀ : A (f (γ ₀))} {a₁ : A (f (γ ₁))} {b₀ : A (δ ₀)} {b₁ : A (δ ₁)}
    (e₀ : a₀ ≡ʰ b₀) (e₁ : a₁ ≡ʰ b₁) →
    Id′ (λ w → A (f w)) γ a₀ a₁ ≡ Id′ A δ b₀ b₁
Id′-AP≡ f γ .(AP f γ) reflᵉ A {a₀} {a₁} {b₀} {b₁} e₀ e₁ =
  Id′-AP f γ A a₀ a₁ • cong2 (Id′ A (AP f γ)) (≡ʰ→≡ e₀) (≡ʰ→≡ e₁)

-- Functoriality for ap should be admissible, like Id′-AP.
-- However, like ap, it should compute on terms, not types.
postulate
  ap-AP : {Γ Δ : Tel} {A : el Δ → Type} (f : el Γ → el Δ) (g : (x : el Δ) → A x) (γ : el (ID Γ)) →
    ap g (AP f γ) ≡ coe→ (Id′-AP f γ A (g (f (γ ₀))) (g (f (γ ₁)))) (ap (λ w → g (f w)) γ) 

-- From this we can prove the analogous functoriality property for AP,
-- with some awful wrangling of heterogeneous exo-equality.
AP-AP : {Γ Δ Θ : Tel} (f : el Γ → el Δ) (g : el Δ → el Θ) (γ : el (ID Γ)) →
  AP g (AP f γ) ≡ AP (λ w → g (f w)) γ

-- The proof requires a helper lemma for ∷, just like AP₀ and AP₁.
AP-AP-∷ : {Γ Δ Θ : Tel} (A : el Θ → Type) (f : el Γ → el Δ)
  (g : el Δ → el Θ) (h : (x : el Δ) → A (g x)) (γ : el (ID Γ)) →
  AP (λ x → g x ∷ h x) (AP f γ) ≡ AP (λ w → g (f w) ∷ h (f w)) γ
AP-AP-∷ A f g h γ =
      ∷≡ʰ (λ δaa → Id′ A (pop (pop δaa)) (top (pop δaa)) (top δaa))
      (∷≡ʰ (λ δa → A ((pop δa)₁))
           (∷≡ʰ (λ δ → A (δ ₀))
                (AP-AP f g γ)
                reflʰ)
           reflʰ)
       (coe→≡ʰ (Id′-AP g (AP f γ) A (h (f (γ ₀))) (h (f (γ ₁)))) _ •ʰ
       (≡→≡ʰ (ap-AP f h γ) •ʰ
       (coe→≡ʰ (Id′-AP f γ (λ z → A (g z)) (h (f (γ ₀))) (h (f (γ ₁)))) _ •ʰ
        revʰ (coe→≡ʰ (Id′-AP (λ x → g (f x)) γ A (h (f (γ ₀))) (h (f (γ ₁)))) _))))

AP-AP {Θ = ε} f g γ = reflᵉ
AP-AP {Γ} {Δ} {Θ ▸ A} f g γ = AP-AP-∷ A f (λ x → pop (g x)) (λ x → top (g x)) γ

-- Inspecting the above definition, we see that on a concrete
-- telescope, AP-AP consists essentially of reflexivities on points
-- and complex combinations of Id′-AP and ap-AP on identifications.
-- Thus, if the types and terms are also concrete, it should reduce
-- away to reflexivity too.

-- Now, since we defined AP to compute only on ∷ rather than just ▸,
-- we can also make it compute on top and pop.  More generally, we can
-- "prove" that all the pieces of the original ▸-only definition hold.

postulate
  AP-pop : {Γ Δ : Tel} (A : el Δ → Type) (f : el Γ → el (Δ ▸ A)) (γ : el (ID Γ)) →
    AP (λ x → pop (f x)) γ ≡ pop (pop (pop (AP f γ)))

{-# REWRITE AP-pop #-}

-- Unfortunately, these can't be rewrite rules, but we can make them
-- reduce on ∷.  (Below we will reduce them on idmap and pop too.)
top-pop-pop-AP : {Γ Δ : Tel} (A : el Δ → Type) (f : el Γ → el (Δ ▸ A)) (γ : el (ID Γ)) →
  top (pop (pop (AP f γ))) ≡ coe← (cong A (AP₀ (λ x → pop (f x)) γ)) (top (f (γ ₀)))

top-pop-pop-AP-∷ : {Γ Δ : Tel} (A : el Δ → Type) (f : el Γ → el Δ) (g : (x : el Γ) → A (f x)) (γ : el (ID Γ)) →
  top (pop (pop (AP {Δ = Δ ▸ A} (λ x → f x ∷ g x) γ))) ≡ coe← (cong A (AP₀ f γ)) (g (γ ₀))
top-pop-pop-AP-∷ A f g γ = reflᵉ

top-pop-pop-AP A f γ = top-pop-pop-AP-∷ A (λ x → pop (f x)) (λ x → top (f x)) γ

top-pop-AP : {Γ Δ : Tel} (A : el Δ → Type) (f : el Γ → el (Δ ▸ A)) (γ : el (ID Γ)) →
  top (pop (AP f γ)) ≡ coe← (cong A (AP₁ (λ x → pop (f x)) γ)) (top (f (γ ₁)))

top-pop-AP-∷ : {Γ Δ : Tel} (A : el Δ → Type) (f : el Γ → el Δ) (g : (x : el Γ) → A (f x)) (γ : el (ID Γ)) →
  top (pop (AP {Δ = Δ ▸ A} (λ x → f x ∷ g x) γ)) ≡ coe← (cong A (AP₁ f γ)) (g (γ ₁))
top-pop-AP-∷ A f g γ = reflᵉ

top-pop-AP A f γ = top-pop-AP-∷ A (λ x → pop (f x)) (λ x → top (f x)) γ

postulate
  ap-top : {Γ Δ : Tel} (A : el Δ → Type) (f : el Γ → el (Δ ▸ A)) (γ : el (ID Γ)) →
    ap (λ x → top (f x)) γ ≡
    coe← (Id′-AP (λ x → pop (f x)) γ A (top (f (γ ₀))) (top (f (γ ₁))))
      (coe→ (cong2 (Id′ A (pop (pop (pop (AP f γ))))) (top-pop-pop-AP A f γ) (top-pop-AP A f γ))
        (top (AP f γ)))

{-# REWRITE ap-top #-}

-- Note that we don't have rules for computing ap-top on "dependent
-- telescopes".  Hopefully this won't ever occur.

-- Combining ap-top and AP-pop with AP on the identity, we will be
-- able to compute ap on any (De Bruijn) variable.  It may seem like
-- this should be provable at this point, but I don't think it is.
postulate
  AP-idmap : {Δ : Tel} (δ : el (ID Δ)) → AP {Δ} {Δ} (λ w → w) δ ≡ δ

{-# REWRITE AP-idmap #-}

-- However, we can make it reduce away on endpoints.
AP-idmap₀ : {Δ : Tel} (δ : el (ID Δ)) → cong _₀ (AP-idmap δ) ≡ reflᵉ
AP-idmap₀ δ = axiomK

AP-idmap₁ : {Δ : Tel} (δ : el (ID Δ)) → cong _₁ (AP-idmap δ) ≡ reflᵉ
AP-idmap₁ δ = axiomK

{-# REWRITE AP-idmap₀ AP-idmap₁ #-}

-- With AP-idmap, we can compute the admissible rules like AP-AP and
-- Id′-AP on identities.
AP-AP-idmap : {Γ Δ : Tel} (f : el Γ → el Δ) (γ : el (ID Γ)) →
  AP-AP f (λ x → x) γ ≡ reflᵉ
AP-AP-idmap f γ = axiomK

AP-AP-idmap′ : {Γ Δ : Tel} (f : el Γ → el Δ) (γ : el (ID Γ)) →
  AP-AP (λ x → x) f γ ≡ reflᵉ
AP-AP-idmap′ f γ = axiomK

Id′-AP-idmap : {Δ : Tel} (δ : el (ID Δ)) (A : el Δ → Type) (a₀ : A (δ ₀)) (a₁ : A (δ ₁)) →
  Id′-AP {Δ} {Δ} (λ w → w) δ A a₀ a₁ ≡ reflᵉ
Id′-AP-idmap δ A a₀ a₁ = axiomK

{-
top-pop-pop-AP-idmap : {Δ : Tel} (A : el Δ → Type) (γ : el (ID (Δ ▸ A))) →
  top-pop-pop-AP A (λ x → x) γ ≡ reflᵉ
top-pop-pop-AP-idmap A γ = axiomK

top-pop-AP-idmap : {Δ : Tel} (A : el Δ → Type) (γ : el (ID (Δ ▸ A))) →
  top-pop-AP A (λ x → x) γ ≡ reflᵉ
top-pop-AP-idmap A γ = axiomK

top-pop-pop-AP-pop : {Γ Δ : Tel} (A : el Δ → Type) (B : el (Δ ▸ A) → Type) (f : el Γ → el (Δ ▸ A ▸ B)) (γ : el (ID Γ)) →
  top-pop-pop-AP A (λ x → pop (f x)) γ ≡ {!top-pop-pop-AP B f γ!}
top-pop-pop-AP-pop A B γ = {!!}
-}

{-# REWRITE AP-AP-idmap AP-AP-idmap′ Id′-AP-idmap #-}


------------------------------
-- Homogeneous Id and refl
------------------------------

-- Homogeneous identity types are heterogeneous over the empty
-- telescope.  However, if we *defined* them to be that:
{-
Id : (A : Type) → A → A → Type
Id A a₀ a₁ = Id′ {Δ = ε} (λ _ → A) [] a₀ a₁
-}
-- then we couldn't rewrite Id′ of an arbitrary *constant* type family
-- to Id without producing infinite loops, since the above is also a
-- particular constant type family.  So instead we postulate Id
-- separately, along with the reduction for constant type families,
-- which has as a particular consequence that the above definitional
-- equality also holds.

postulate
  Id : (A : Type) → A → A → Type
  Id-const : {Δ : Tel} (A : Type) (δ : el (ID Δ)) (a₀ a₁ : A) →
    Id′ {Δ} (λ _ → A) δ a₀ a₁ ≡ Id A a₀ a₁

{-# REWRITE Id-const #-}

-- Similarly, reflexivity is nullary ap, with the same caveat.
postulate
  refl : {A : Type} (a : A) → Id A a a
  ap-const : {Δ : Tel} (A : Type) (δ : el (ID Δ)) (a : A) →
    ap {Δ} (λ _ → a) δ ≡ refl a

{-# REWRITE ap-const #-}

-- Now we can define reflexivity for telescopes.
REFL : {Δ : Tel} (δ : el Δ) → el (ID Δ)

-- Like AP, we need to simultaneously prove that it respects ₀ and ₁
REFL₀ : {Δ : Tel} (δ : el Δ) → ((REFL δ)₀) ≡ δ
REFL₁ : {Δ : Tel} (δ : el Δ) → ((REFL δ)₁) ≡ δ

-- Moreover, in order to define REFL we'll also need to know its
-- analogue of Id′-AP, which in this case is something we can prove.
Id′-REFL : {Δ : Tel} (A : el Δ → Type) (δ : el Δ) (a₀ : A ((REFL δ)₀)) (a₁ : A ((REFL δ)₁)) →
  Id′ A (REFL δ) a₀ a₁ ≡
  Id (A δ) (coe→ (cong A (REFL₀ δ)) a₀) (coe→ (cong A (REFL₁ δ)) a₁)

-- But in order to prove *that*, we'll also need to know that REFL is
-- the image of AP on constant terms.
AP-const : {Δ : Tel} (Θ : Tel) (δ : el (ID Δ)) (t : el Θ) →
  AP {Δ} (λ _ → t) δ ≡ REFL t

Id′-REFL {Δ} A δ a₀ a₁ = rev (Id′-AP≡ {ε} (λ _ → δ) [] (REFL δ) (rev (AP-const Δ [] δ)) A
                                      (coe→≡ʰ (cong A (REFL₀ δ)) a₀) ((coe→≡ʰ (cong A (REFL₁ δ)) a₁)))

-- A useful extended version of Id′-REFL, like Id′-AP≡.
Id′-REFL≡ : {Δ : Tel} (A : el Δ → Type) (δ : el Δ)
  {a₀ : A ((REFL δ)₀)} {a₁ : A ((REFL δ)₁)} {b₀ b₁ : A δ} (e₀ : a₀ ≡ʰ b₀) (e₁ : a₁ ≡ʰ b₁) →
  Id′ A (REFL δ) a₀ a₁ ≡ Id (A δ) b₀ b₁
Id′-REFL≡ {Δ} A δ e₀ e₁ = rev (Id′-AP≡ {ε} (λ _ → δ) [] (REFL δ) (rev (AP-const Δ [] δ)) A (revʰ e₀) (revʰ e₁)) 

-- Note that in defining REFL we have to coerce along REFL₀ and REFL₁, and also ID′-REFL≡.
REFL {ε} δ = []
REFL {Δ ▸ A} δ = REFL (pop δ) ∷
                 coe← (cong A (REFL₀ (pop δ))) (top δ) ∷
                 coe← (cong A (REFL₁ (pop δ))) (top δ) ∷
                 coe← (Id′-REFL≡ A (pop δ) (coe←≡ʰ (cong A (REFL₀ (pop δ))) (top δ)) (coe←≡ʰ (cong A (REFL₁ (pop δ))) (top δ)))
                      (refl (top δ))

REFL₀ {ε} δ = reflᵉ
REFL₀ {Δ ▸ A} δ = ∷≡ʰ A (REFL₀ (pop δ)) (coe←≡ʰ (cong A (REFL₀ (pop δ))) _)

REFL₁ {ε} δ = reflᵉ
REFL₁ {Δ ▸ A} δ = ∷≡ʰ A (REFL₁ (pop δ)) (coe←≡ʰ (cong A (REFL₁ (pop δ))) _)

-- The proof of AP-const in the ▸ case also requires case-analysis on
-- the term t, whose "constructor" ∷ isn't actually a constructor, so
-- we have to do the "case analysis" in a separate lemma.  (We
-- couldn't do this for AP above, because in that case we needed the
-- *syntactic* restriction that it would only compute on ∷ terms.)
AP-const-∷ : {Δ : Tel} (Θ : Tel) (A : el Θ → Type) (δ : el (ID Δ)) (t : el Θ) (a : A t) →
  AP {Δ} (λ _ → _∷_ {Θ} {A} t a) δ ≡ REFL (_∷_ {Θ} {A} t a)
AP-const-∷ {Δ} Θ A δ t a =
  ∷≡ʰ _ (∷≡ʰ _ (∷≡ʰ _
  (AP-const {Δ} Θ δ t)
  (revʰ (coe←≡ʰ (cong A (REFL₀ t)) a)))
  (revʰ (coe←≡ʰ (cong A (REFL₁ t)) a)))
  (coe→≡ʰ (Id′-AP (λ _ → t) δ A a a) (refl a) •ʰ
   revʰ (coe←≡ʰ (Id′-REFL≡ A t (coe←≡ʰ (cong A (REFL₀ t)) a) (coe←≡ʰ (cong A (REFL₁ t)) a)) (refl a)))

AP-const {Δ} ε δ t = reflᵉ
AP-const {Δ} (Θ ▸ A) δ t = AP-const-∷ Θ A δ (pop t) (top t)

-- Many of these can be made rewrites.
{-# REWRITE REFL₀ REFL₁ Id′-REFL AP-const #-}

-- And once they are, we can make them identities, as for AP above.
REFL₀-reflᵉ : {Δ : Tel} (δ : el Δ) → REFL₀ {Δ} δ ≡ reflᵉ
REFL₀-reflᵉ δ = axiomK

REFL₁-reflᵉ : {Δ : Tel} (δ : el Δ) → REFL₁ {Δ} δ ≡ reflᵉ
REFL₁-reflᵉ δ = axiomK

AP-const-reflᵉ : {Δ : Tel} (Θ : Tel) (δ : el (ID Δ)) (t : el Θ) →
  AP-const Θ δ t ≡ reflᵉ
AP-const-reflᵉ Θ δ t = axiomK

{-# REWRITE REFL₀-reflᵉ REFL₁-reflᵉ AP-const-reflᵉ #-}

-- Id′-REFL-reflᵉ can't be a rewrite since its LHS reduces directly
-- rather than by case-analysis.  Instead we make the following a
-- rewrite, which in particular makes Id′-REFL-reflᵉ hold
-- definitionally.

Id′-AP-const : {Γ Δ : Tel} (f : el Δ) (γ : el (ID Γ)) (A : el Δ → Type) (a₀ a₁ : A f) →
  Id′-AP {Γ} (λ _ → f) γ A a₀ a₁ ≡ reflᵉ
Id′-AP-const f γ A a₀ a₁ = axiomK

{-# REWRITE Id′-AP-const #-}

Id′-REFL-reflᵉ : {Δ : Tel} (A : el Δ → Type) (δ : el Δ) (a₀ : A ((REFL δ)₀)) (a₁ : A ((REFL δ)₁)) →
  Id′-REFL A δ a₀ a₁ ≡ reflᵉ
Id′-REFL-reflᵉ A δ a₀ a₁ = reflᵉ 

-- The usefulness of having Id-REFL as a rewrite is limited in
-- practice, because if δ has internal structure, REFL will compute on
-- it, and can't be "un-rewritten" back to a REFL in order for Id-REFL
-- to fire.  So we still sometimes have to coerce along Id-REFL.  But
-- the fact that it is definitionally reflexivity, at least on
-- abstract arguments, minimizes the effect of these coercions.

-- Now we do the same for ap on reflexivity.
ap-REFL : {Δ : Tel} (A : el Δ → Type) (f : (δ : el Δ) → A δ) (δ : el Δ) →
  ap f (REFL δ) ≡ refl (f δ)
ap-REFL {Δ} A f δ = ap-AP {ε} (λ _ → δ) f []

AP-REFL : {Δ Θ : Tel} (f : el Δ → el Θ) (δ : el Δ) →
  AP f (REFL δ) ≡ REFL (f δ)
AP-REFL f δ = AP-AP {ε} (λ _ → δ) f []

{-# REWRITE ap-REFL AP-REFL #-}

-- We can now assert that the functoriality rules for constant
-- families and functions reduce to reflexivity, which is well-typed
-- since both sides reduce to a homogeneous Id or a refl.
Id′-AP-CONST : {Γ Δ : Tel} (f : el Γ → el Δ) (γ : el (ID Γ)) (A : Type) (a₀ a₁ : A) →
  Id′-AP f γ (λ _ → A) a₀ a₁ ≡ reflᵉ
Id′-AP-CONST f γ A a₀ a₁ = axiomK

{-# REWRITE Id′-AP-CONST #-}

ap-AP-CONST : {Γ Δ : Tel} (f : el Γ → el Δ) (γ : el (ID Γ)) {A : Type} (g : A) →
  ap-AP f (λ _ → g) γ ≡ reflᵉ
ap-AP-CONST f γ g = axiomK

AP-AP-CONST : {Γ Δ : Tel} (f : el Γ → el Δ) (γ : el (ID Γ)) {Θ : Tel} (g : el Θ) →
  AP-AP f (λ _ → g) γ ≡ reflᵉ
AP-AP-CONST f γ g = axiomK

{-# REWRITE ap-AP-CONST AP-AP-CONST #-}

-- The choice not to *define* Id, refl, and REFL as instances of Id′,
-- ap, and AP does mean that some of the rewrites we postulate for the
-- latter have to be given separately for the former in case the
-- latter get reduced to the former before these rules fire.

-- The computations of REFL on ε and ∷ hold already by definition.
-- The computation of REFL on pop holds by definition in the other
-- direction (since, unlike for AP, we defined REFL on ▸ to compute
-- for any term, not just ∷.  Was that the right choice?)

postulate
  top-pop-pop-REFL : {Δ : Tel} (A : el Δ → Type) (f : el (Δ ▸ A)) →
    top (pop (pop (REFL f))) ≡ coe← (cong A (REFL₀ (pop f))) (top f)
  top-pop-REFL : {Δ : Tel} (A : el Δ → Type) (f : el (Δ ▸ A)) →
    top (pop (REFL f)) ≡ coe← (cong A (REFL₁ (pop f))) (top f)
  top-pop-pop-REFL-∷ : {Δ : Tel} (A : el Δ → Type) (f : el Δ) (g : A f) →
    top-pop-pop-REFL A (f ∷ g) ≡ reflᵉ
  top-pop-REFL-∷ : {Δ : Tel} (A : el Δ → Type) (f : el Δ) (g : A f) →
    top-pop-REFL A (f ∷ g) ≡ reflᵉ

{-# REWRITE top-pop-pop-REFL-∷ top-pop-REFL-∷ #-}

postulate
  refl-top : (Δ : Tel) (A : el Δ → Type) (f : el (Δ ▸ A)) →
    refl (top f) ≡ coe→ (Id′-AP {ε} (λ _ → pop f) [] A (top f) (top f)) (top (REFL f)) 

{-# REWRITE refl-top #-}

-- The same is true for the specific type formers considered in other
-- files; all their rules for Id′ and ap have also to be given in
-- separate forms for Id and refl.
