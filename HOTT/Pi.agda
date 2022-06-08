{-# OPTIONS --exact-split --type-in-type --rewriting --two-level --cumulativity --without-K #-}

module HOTT.Pi where

open import HOTT.Rewrite
open import HOTT.Telescope
open import HOTT.Id
open import HOTT.Transport
open import HOTT.Square
open import HOTT.Fill

--------------------
-- Π-types
--------------------

postulate
  Π : (A : Type) (B : A → Type) → Type
  lamΠ : {A : Type} {B : A → Type} (f : (x : A) → B x) → Π A B
  _⊙_ : {A : Type} {B : A → Type} (f : Π A B) (a : A) → B a

infixr 27 lamΠ
syntax lamΠ (λ x → f) = Λ x ⇛ f

infixl 30 _⊙_

postulate
  β⊙ : {A : Type} {B : A → Type} (f : (x : A) → B x) (a : A) → ((Λ x ⇛ f x) ⊙ a) ≡ f a
  ηΠ : {A : Type} {B : A → Type} (f : Π A B) → (Λ x ⇛ f ⊙ x) ≡ f

{-# REWRITE β⊙ ηΠ #-}

postulate
  Id′Π : {Δ : Tel} (A : el Δ → Type) (B : (w : el Δ) → A w → Type)
    {δ₀ δ₁ : el Δ} (δ₂ : el (ID Δ δ₀ δ₁)) (f₀ : Π (A δ₀) (λ a → B δ₀ a)) (f₁ : Π (A δ₁) (λ a → B δ₁ a)) →
    Id′ (λ w → Π (A w) (λ a → B w a)) δ₂ f₀ f₁ ≡
      Π (A δ₀) (λ a₀ →
      Π (A δ₁) (λ a₁ →
      Π (Id′ A δ₂ a₀ a₁) (λ a₂ →
        Id′ {Δ ▸ A} (uncurry B) {δ₀ ∷ a₀} {δ₁ ∷ a₁} (δ₂ ∷ a₂) (f₀ ⊙ a₀) (f₁ ⊙ a₁))))
  IdΠ : (A : Type) (B : A → Type) (f₀ f₁ : Π A B) →
    Id (Π A B) f₀ f₁ ≡
      Π A (λ a₀ →
      Π A (λ a₁ →
      Π (Id A a₀ a₁) (λ a₂ →
        Id′ {ε ▸ (λ _ → A)} (λ a → B (top a)) {[] ∷ a₀} {[] ∷ a₁} ([] ∷ a₂) (f₀ ⊙ a₀) (f₁ ⊙ a₁))))

{-# REWRITE Id′Π IdΠ #-}

postulate
  apΛ : {Δ : Tel} (A : el Δ → Type) (B : (w : el Δ) → A w → Type) {δ₀ δ₁ : el Δ} (δ₂ : el (ID Δ δ₀ δ₁))
    (f : (x : el Δ) (a : A x) → B x a) →
    ap (λ x → Λ y ⇛ f x y) δ₂ ≡ Λ a₀ ⇛ Λ a₁ ⇛ Λ a₂ ⇛ ap (λ w → f (pop w) (top w)) {δ₀ ∷ a₀} {δ₁ ∷ a₁} (δ₂ ∷ a₂) 
  reflΛ : (A : Type) (B : A → Type) (f : (a : A) → B a) →
    refl (Λ x ⇛ f x) ≡ Λ a₀ ⇛ Λ a₁ ⇛ Λ a₂ ⇛ ap {ε ▸ (λ _ → A)} (λ x → f (top x)) {[] ∷ a₀} {[] ∷ a₁} ([] ∷ a₂)
  ap⊙ : {Δ : Tel} (A : el Δ → Type) (B : (w : el Δ) → A w → Type) {δ₀ δ₁ : el Δ} (δ₂ : el (ID Δ δ₀ δ₁))
    (f : (x : el Δ) → Π (A x) (B x)) (a : (x : el Δ) → A x) →
    ap (λ x → f x ⊙ a x) δ₂ ≡
    coe→ (Id′-AP (λ w → (w ∷ a w)) {δ₀} {δ₁} δ₂ (uncurry B) _ _) (ap f δ₂ ⊙ (a δ₀) ⊙ (a δ₁) ⊙ (ap a δ₂))
  refl⊙ : (A : Type) (B : A → Type) (f : Π A B) (a : A) →
    refl (f ⊙ a) ≡ coe→ (Id′-AP {ε} (λ _ → [] ∷ a) [] (λ x → B (top x)) (f ⊙ a) (f ⊙ a)) (refl f ⊙ a ⊙ a ⊙ (refl a))

{-# REWRITE apΛ reflΛ ap⊙ refl⊙ #-}

----------------------------------------
-- Transport in Π-types
----------------------------------------

postulate
  tr→Π : {Δ : Tel} (A : el Δ → Type) (B : (w : el Δ) → A w → Type)
    {δ₀ δ₁ : el Δ} (δ₂ : el (ID Δ δ₀ δ₁)) (f₀ : Π (A δ₀) (B δ₀)) →
    tr→ (λ w → Π (A w) (B w)) δ₂ f₀ ≡
    Λ a₁ ⇛ tr→ (uncurry B) {δ₀ ∷ tr← A δ₂ a₁} {δ₁ ∷ a₁} (δ₂ ∷ lift← A δ₂ a₁) (f₀ ⊙ (tr← A δ₂ a₁))
  tr←Π : {Δ : Tel} (A : el Δ → Type) (B : (w : el Δ) → A w → Type)
    {δ₀ δ₁ : el Δ} (δ₂ : el (ID Δ δ₀ δ₁)) (f₁ : Π (A δ₁) (B δ₁)) →
    tr← (λ w → Π (A w) (B w)) δ₂ f₁ ≡
    Λ a₀ ⇛ tr← (uncurry B) {δ₀ ∷ a₀} {δ₁ ∷ tr→ A δ₂ a₀} (δ₂ ∷ lift→ A δ₂ a₀) (f₁ ⊙ (tr→ A δ₂ a₀))

{-# REWRITE tr→Π tr←Π #-}

{-
postulate
  lift→Π : {Δ : Tel} (A : el Δ → Type) (B : (w : el Δ) → A w → Type)
    {δ₀ δ₁ : el Δ} (δ₂ : el (ID Δ δ₀ δ₁)) (f₀ : Π (A δ₀) (B δ₀)) →
    lift→ (λ w → Π (A w) (B w)) δ₂ f₀ ≡
    Λ a₀ ⇛ Λ a₁ ⇛ Λ a₂ ⇛
    comp← (uncurry B)
      {δ₀ ∷ a₀} {δ₀ ∷ tr← A δ₂ a₁}
      (REFL δ₀ ∷ coe← (Id-REFL A δ₀ a₀ (tr← A δ₂ a₁)) (utr← A δ₂ a₁ a₀ (tr← A δ₂ a₁) a₂ (lift← A δ₂ a₁)))
      {δ₁ ∷ a₁} {δ₁ ∷ a₁}
      (REFL δ₁ ∷ coe← (Id-REFL A δ₁ a₁ a₁) (refl a₁))
      (δ₂ ∷ a₂) (δ₂ ∷ lift← A δ₂ a₁)
      -- We need a square in (Δ ▸ A), and we need a way to make that
      -- from a square in Δ and a dependent square in A.  This
      -- requires some context rearranging, since a square in (Δ ▸ A)
      -- mixes the As in with the Δs in the contexts.
      {!(sq▸ A (REFL δ₀) (REFL δ₁) δ₂ δ₂ (DEGSQ-LR Δ δ₂)
           (coe← (Id-REFL A δ₀ a₀ (tr← A δ₂ a₁)) (utr← A δ₂ a₁ a₀ (tr← A δ₂ a₁) a₂ (lift← A δ₂ a₁)))
           (coe← (Id-REFL A δ₁ a₁ a₁) (refl a₁))
           a₂ (lift← A δ₂ a₁)
           ((coe→ (cong (λ ρ → Id′ {TID Δ ▸ (λ w → A (left {Δ} w)) ▸ (λ w → A (right {Δ} (pop {TID Δ} {λ w₁ → A (left {Δ} w₁)} w)))}
                                   (λ w → Id′ A (mid {Δ} (pop (pop w))) (top (pop w)) (top w))
                                   {tot δ₀ δ₁ δ₂ ∷ a₀ ∷ a₁} {tot δ₀ δ₁ δ₂ ∷ (tr← A δ₂ a₁) ∷ a₁} ρ
                                   a₂ (lift← A δ₂ a₁))
           -- Now we need to prove that tsq-tb-lift, in the special
           -- case of our partially degenerate square, specializes to
           -- something that arose otherwise.
                        {! !})
             (coe← (Id-AP {ε ▸ (λ _ → A δ₀)} {TID Δ ▸ (λ w → A (left w)) ▸ (λ w → A (right (pop w)))}
                  (λ z → tot δ₀ δ₁ δ₂ ∷ top z ∷ a₁)
                  {[] ∷ a₀} {[] ∷ tr← A δ₂ a₁}
                  ([] ∷ utr← A δ₂ a₁ a₀ (tr← A δ₂ a₁) a₂ (lift← A δ₂ a₁))
                  (λ w → Id′ {Δ} A (mid {Δ} (pop (pop w))) (top (pop w)) (top w))
                  a₂ (lift← A δ₂ a₁))
              (ulift← A δ₂ a₁ a₀ (tr← A δ₂ a₁) a₂ (lift← A δ₂ a₁))))))!}
      {f₀ ⊙ a₀} {f₀ ⊙ tr← A δ₂ a₁}
      (coe← {!(Id-REFL∷ A (uncurry B) δ₀ (utr← A δ₂ a₁ a₀ (tr← A δ₂ a₁) a₂ (lift← A δ₂ a₁)) (f₀ ⊙ a₀) (f₀ ⊙ tr← A δ₂ a₁))!}
        (ap {ε ▸ (λ _ → A δ₀)} (λ w → f₀ ⊙ (top w))
            {[] ∷ a₀} {[] ∷ tr← A δ₂ a₁} ([] ∷ utr← A δ₂ a₁ a₀ (tr← A δ₂ a₁) a₂ (lift← A δ₂ a₁))))
      {tr→ (uncurry B) {δ₀ ∷ tr← A δ₂ a₁} {δ₁ ∷ a₁} (δ₂ ∷ lift← A δ₂ a₁) (f₀ ⊙ (tr← A δ₂ a₁))}
      {tr→ (uncurry B) {δ₀ ∷ tr← A δ₂ a₁} {δ₁ ∷ a₁} (δ₂ ∷ lift← A δ₂ a₁) (f₀ ⊙ (tr← A δ₂ a₁))}
      (coe← (Id-REFL (uncurry B) (δ₁ ∷ a₁) (tr→ (uncurry B) {δ₀ ∷ tr← A δ₂ a₁} {δ₁ ∷ a₁} (δ₂ ∷ lift← A δ₂ a₁) (f₀ ⊙ tr← A δ₂ a₁))
                                           (tr→ (uncurry B) {δ₀ ∷ tr← A δ₂ a₁} {δ₁ ∷ a₁} (δ₂ ∷ lift← A δ₂ a₁) (f₀ ⊙ tr← A δ₂ a₁)))
        (refl (tr→ (uncurry B) {δ₀ ∷ tr← A δ₂ a₁} {δ₁ ∷ a₁} (δ₂ ∷ lift← A δ₂ a₁) (f₀ ⊙ (tr← A δ₂ a₁)))))
      (lift→ (uncurry B) {δ₀ ∷ tr← A δ₂ a₁} {δ₁ ∷ a₁} (δ₂ ∷ lift← A δ₂ a₁) (f₀ ⊙ tr← A δ₂ a₁)) 
-}
