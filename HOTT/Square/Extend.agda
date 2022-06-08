{-# OPTIONS --exact-split --type-in-type --rewriting --two-level --cumulativity --without-K #-}

module HOTT.Square.Extend where

open import HOTT.Rewrite
open import HOTT.Telescope
open import HOTT.Id
open import HOTT.Square

{-
sq▸help : {Δ : Tel} (A : el Δ → Type) {δ₀₀ δ₀₁ : el Δ} (δ₀₂ : el (ID Δ δ₀₀ δ₀₁)) {δ₁₀ δ₁₁ : el Δ} (δ₁₂ : el (ID Δ δ₁₀ δ₁₁))
     (δ₂₀ : el (ID Δ δ₀₀ δ₁₀)) (δ₂₁ : el (ID Δ δ₀₁ δ₁₁)) (δ₂₂ : el (SQ Δ δ₀₂ δ₁₂ δ₂₀ δ₂₁))
     {a₀₀ : A δ₀₀} {a₀₁ : A δ₀₁} (a₀₂ : Id′ A δ₀₂ a₀₀ a₀₁) {a₁₀ : A δ₁₀} {a₁₁ : A δ₁₁} (a₁₂ : Id′ A δ₁₂ a₁₀ a₁₁)
     (a₂₀ : Id′ A δ₂₀ a₀₀ a₁₀) (a₂₁ : Id′ A δ₂₁ a₀₁ a₁₁)
     (a₂₂ : Sq {Δ} A {δ₀₀} {δ₀₁} δ₀₂ {δ₁₀} {δ₁₁} δ₁₂ δ₂₀ δ₂₁ δ₂₂ {a₀₀} {a₀₁} a₀₂ {a₁₀} {a₁₁} a₁₂ a₂₀ a₂₁) →
  PAIR (λ w → ID′ {Δ} (λ _ → Δ) {δ₀₀} {δ₀₁} w δ₁₀ δ₁₁) δ₀₂
    (coe←ᵉ (cong el (ID′-CONST {Δ} Δ {δ₀₀} {δ₀₁} δ₀₂ δ₁₀ δ₁₁)) δ₁₂)
    ≡
    AP
    {(PROD (Δ ▸ A) Δ) ▸ (λ z → A (SND (Δ ▸ A) Δ z))} {PROD Δ Δ}
    (λ z → PAIR {Δ} (λ _ → Δ) (pop (FST (Δ ▸ A) Δ (pop z))) (SND (Δ ▸ A) Δ (pop z)))
    {_∷_ {PROD (Δ ▸ A) Δ} {λ z → A (SND (Δ ▸ A) Δ z)} (PR (Δ ▸ A) Δ (δ₀₀ ∷ a₀₀) δ₁₀) a₁₀}
    {_∷_ {PROD (Δ ▸ A) Δ} {λ z → A (SND (Δ ▸ A) Δ z)} (PR (Δ ▸ A) Δ (δ₀₁ ∷ a₀₁) δ₁₁) a₁₁}
    (PAIR {ID (Δ ▸ A) (δ₀₀ ∷ a₀₀) (δ₀₁ ∷ a₀₁)}
          (λ z → ID′ {Δ ▸ A} (λ _ → Δ) {δ₀₀ ∷ a₀₀} {δ₀₁ ∷ a₀₁} z δ₁₀ δ₁₁) (δ₀₂ ∷ a₀₂)
     (coe←ᵉ (cong el (ID′-CONST {Δ ▸ A} Δ {δ₀₀ ∷ a₀₀} {δ₀₁ ∷ a₀₁} (δ₀₂ ∷ a₀₂) δ₁₀ δ₁₁)) δ₁₂)
     ∷
     coe←[] (ID′-CONST {Δ ▸ A} Δ {δ₀₀ ∷ a₀₀} {δ₀₁ ∷ a₀₁} (δ₀₂ ∷ a₀₂) δ₁₀ δ₁₁)
         (≡λ′→ (λ x₀ → rev (Id′-AP {Δ ▸ A ► (λ _ → Δ)} {Δ} (SND (Δ ▸ A) Δ)
                                    {PR (Δ ▸ A) Δ (δ₀₀ ∷ a₀₀) δ₁₀} {PR (Δ ▸ A) Δ (δ₀₁ ∷ a₀₁) δ₁₁}
                                    (PAIR {ID (Δ ▸ A) (δ₀₀ ∷ a₀₀) (δ₀₁ ∷ a₀₁)}
                                          (λ w → ID′ {Δ ▸ A} (λ _ → Δ) {δ₀₀ ∷ a₀₀} {δ₀₁ ∷ a₀₁} w δ₁₀ δ₁₁)
                                          (δ₀₂ ∷ a₀₂) x₀) A a₁₀ a₁₁)))
         a₁₂)
sq▸help {Δ} A {δ₀₀} {δ₀₁} δ₀₂ {δ₁₀} {δ₁₁} δ₁₂ δ₂₀ δ₂₁ δ₂₂ {a₀₀} {a₀₁} a₀₂ {a₁₀} {a₁₁} a₁₂ a₂₀ a₂₁ a₂₂ =
  {!AP-PAIR {(PROD (Δ ▸ A) Δ) ▸ (λ z → A (SND (Δ ▸ A) Δ z))} {Δ} (λ _ → Δ)
           (λ z → pop (FST (Δ ▸ A) Δ (pop z))) (λ z → SND (Δ ▸ A) Δ (pop z))
           {_∷_ {PROD (Δ ▸ A) Δ} {λ z → A (SND (Δ ▸ A) Δ z)} (PR (Δ ▸ A) Δ (δ₀₀ ∷ a₀₀) δ₁₀) a₁₀}
    {_∷_ {PROD (Δ ▸ A) Δ} {λ z → A (SND (Δ ▸ A) Δ z)} (PR (Δ ▸ A) Δ (δ₀₁ ∷ a₀₁) δ₁₁) a₁₁}
    (PAIR {ID (Δ ▸ A) (δ₀₀ ∷ a₀₀) (δ₀₁ ∷ a₀₁)}
          (λ z → ID′ {Δ ▸ A} (λ _ → Δ) {δ₀₀ ∷ a₀₀} {δ₀₁ ∷ a₀₁} z δ₁₀ δ₁₁) (δ₀₂ ∷ a₀₂)
     (coe←ᵉ (cong el (ID′-CONST {Δ ▸ A} Δ {δ₀₀ ∷ a₀₀} {δ₀₁ ∷ a₀₁} (δ₀₂ ∷ a₀₂) δ₁₀ δ₁₁)) δ₁₂)
     ∷ coe←[] (ID′-CONST {Δ ▸ A} Δ {δ₀₀ ∷ a₀₀} {δ₀₁ ∷ a₀₁} (δ₀₂ ∷ a₀₂) δ₁₀ δ₁₁)
         (≡λ′→ (λ x₀ → rev (Id′-AP {Δ ▸ A ► (λ _ → Δ)} {Δ} (SND (Δ ▸ A) Δ)
                                    {PR (Δ ▸ A) Δ (δ₀₀ ∷ a₀₀) δ₁₀} {PR (Δ ▸ A) Δ (δ₀₁ ∷ a₀₁) δ₁₁}
                                    (PAIR {ID (Δ ▸ A) (δ₀₀ ∷ a₀₀) (δ₀₁ ∷ a₀₁)}
                                          (λ w → ID′ {Δ ▸ A} (λ _ → Δ) {δ₀₀ ∷ a₀₀} {δ₀₁ ∷ a₀₁} w δ₁₀ δ₁₁)
                                          (δ₀₂ ∷ a₀₂) x₀) A a₁₀ a₁₁)))
         a₁₂)
           !}
-}

sq▸ : {Δ : Tel} (A : el Δ → Type) {δ₀₀ δ₀₁ : el Δ} (δ₀₂ : el (ID Δ δ₀₀ δ₀₁)) {δ₁₀ δ₁₁ : el Δ} (δ₁₂ : el (ID Δ δ₁₀ δ₁₁))
     (δ₂₀ : el (ID Δ δ₀₀ δ₁₀)) (δ₂₁ : el (ID Δ δ₀₁ δ₁₁)) (δ₂₂ : el (SQ Δ δ₀₂ δ₁₂ δ₂₀ δ₂₁))
     {a₀₀ : A δ₀₀} {a₀₁ : A δ₀₁} (a₀₂ : Id′ A δ₀₂ a₀₀ a₀₁) {a₁₀ : A δ₁₀} {a₁₁ : A δ₁₁} (a₁₂ : Id′ A δ₁₂ a₁₀ a₁₁)
     (a₂₀ : Id′ A δ₂₀ a₀₀ a₁₀) (a₂₁ : Id′ A δ₂₁ a₀₁ a₁₁)
     (a₂₂ : Sq {Δ} A {δ₀₀} {δ₀₁} δ₀₂ {δ₁₀} {δ₁₁} δ₁₂ δ₂₀ δ₂₁ δ₂₂ {a₀₀} {a₀₁} a₀₂ {a₁₀} {a₁₁} a₁₂ a₂₀ a₂₁) →
     el (SQ (Δ ▸ A) {δ₀₀ ∷ a₀₀} {δ₀₁ ∷ a₀₁} (δ₀₂ ∷ a₀₂) {δ₁₀ ∷ a₁₀} {δ₁₁ ∷ a₁₁} (δ₁₂ ∷ a₁₂) (δ₂₀ ∷ a₂₀) (δ₂₁ ∷ a₂₁))
sq▸ {Δ} A {δ₀₀} {δ₀₁} δ₀₂ {δ₁₀} {δ₁₁} δ₁₂ δ₂₀ δ₂₁ δ₂₂ {a₀₀} {a₀₁} a₀₂ {a₁₀} {a₁₁} a₁₂ a₂₀ a₂₁ a₂₂ =
  {!!}
{-
  COE→ (ID′-AP≡ {Δ ▸ A ► (λ _ → Δ) ▸ (λ w → A (SND (Δ ▸ A) Δ w))} {PROD Δ Δ}
                (λ z → PR Δ Δ (pop (FST (Δ ▸ A) Δ (pop {B = λ w → A (SND (Δ ▸ A) Δ w)} z))) (SND (Δ ▸ A) Δ (pop z)))
                {PR (Δ ▸ A) Δ (δ₀₀ ∷ a₀₀) δ₁₀ ∷ a₁₀} {PR (Δ ▸ A) Δ (δ₀₁ ∷ a₀₁) δ₁₁ ∷ a₁₁}
                (PAIR (λ z → ID′ {Δ ▸ A} (λ _ → Δ) {δ₀₀ ∷ a₀₀} {δ₀₁ ∷ a₀₁} z δ₁₀ δ₁₁) (δ₀₂ ∷ a₀₂)
                      (coe←ᵉ (cong el (ID′-CONST {Δ ▸ A} Δ {δ₀₀ ∷ a₀₀} {δ₀₁ ∷ a₀₁} (δ₀₂ ∷ a₀₂) δ₁₀ δ₁₁)) δ₁₂) ∷
  coe←[] (ID′-CONST {Δ ▸ A} Δ {δ₀₀ ∷ a₀₀} {δ₀₁ ∷ a₀₁} (δ₀₂ ∷ a₀₂) δ₁₀ δ₁₁)
         (≡λ′→ (λ x₀ → rev (Id′-AP {Δ ▸ A ► (λ _ → Δ)} {Δ} (SND (Δ ▸ A) Δ)
                                    {PR (Δ ▸ A) Δ (δ₀₀ ∷ a₀₀) δ₁₀} {PR (Δ ▸ A) Δ (δ₀₁ ∷ a₀₁) δ₁₁}
                                    (PAIR {ID (Δ ▸ A) (δ₀₀ ∷ a₀₀) (δ₀₁ ∷ a₀₁)}
                                          (λ w → ID′ {Δ ▸ A} (λ _ → Δ) {δ₀₀ ∷ a₀₀} {δ₀₁ ∷ a₀₁} w δ₁₀ δ₁₁)
                                          (δ₀₂ ∷ a₀₂) x₀) A a₁₀ a₁₁)))
         a₁₂)
                (PAIR (λ w → ID′ {Δ} (λ _ → Δ) {δ₀₀} {δ₀₁} w δ₁₀ δ₁₁) δ₀₂
                      (coe←ᵉ (cong el (ID′-CONST {Δ} Δ {δ₀₀} {δ₀₁} δ₀₂ δ₁₀ δ₁₁)) δ₁₂))
                (sq▸help {Δ} A {δ₀₀} {δ₀₁} δ₀₂ {δ₁₀} {δ₁₁} δ₁₂ δ₂₀ δ₂₁ δ₂₂ {a₀₀} {a₀₁} a₀₂ {a₁₀} {a₁₁} a₁₂ a₂₀ a₂₁ a₂₂)
                (UID Δ) δ₂₀ δ₂₁)
       δ₂₂
  ∷ {!!}
-}
