{-# OPTIONS --exact-split --type-in-type --rewriting --two-level --cumulativity --without-K #-}

module HOTT.Sym where

open import HOTT.Rewrite
open import HOTT.Telescope
open import HOTT.Id
open import HOTT.Square
open import HOTT.Square.Top

Sq≡ : {Δ : Tel} (A : el Δ → Type)
     {δ δ' : el (SQ Δ)} (e : δ ≡ δ')
     {a₀₀ : A (δ ₀₀)} {a₀₀' : A (δ' ₀₀)} (e₀₀ : a₀₀ ≡ʰ a₀₀')
     {a₀₁ : A (δ ₀₁)} {a₀₁' : A (δ' ₀₁)} (e₀₁ : a₀₁ ≡ʰ a₀₁')
     {a₀₂ : Id′ A (δ ₀₂) a₀₀ a₀₁} {a₀₂' : Id′ A (δ' ₀₂) a₀₀' a₀₁'} (e₀₂ : a₀₂ ≡ʰ a₀₂')
     {a₁₀ : A (δ ₁₀)} {a₁₀' : A (δ' ₁₀)} (e₁₀ : a₁₀ ≡ʰ a₁₀')
     {a₁₁ : A (δ ₁₁)} {a₁₁' : A (δ' ₁₁)} (e₁₁ : a₁₁ ≡ʰ a₁₁')
     {a₁₂ : Id′ A (δ ₁₂) a₁₀ a₁₁} {a₁₂' : Id′ A (δ' ₁₂) a₁₀' a₁₁'} (e₁₂ : a₁₂ ≡ʰ a₁₂')
     {a₂₀ : Id′ A (δ ₂₀) a₀₀ a₁₀} {a₂₀' : Id′ A (δ' ₂₀) a₀₀' a₁₀'} (e₂₀ : a₂₀ ≡ʰ a₂₀')
     {a₂₁ : Id′ A (δ ₂₁) a₀₁ a₁₁} {a₂₁' : Id′ A (δ' ₂₁) a₀₁' a₁₁'} (e₂₁ : a₂₁ ≡ʰ a₂₁') →
  Sq A δ a₀₂ a₁₂ a₂₀ a₂₁ ≡ Sq A δ' a₀₂' a₁₂' a₂₀' a₂₁'
Sq≡ A reflᵉ reflʰ reflʰ reflʰ reflʰ reflʰ reflʰ reflʰ reflʰ = reflᵉ

------------------------------
-- Symmetry
------------------------------

-- Symmetry for telescopes will be defined in terms of symmetry for types.
SYM : (Δ : Tel) → el (SQ Δ) → el (SQ Δ)

-- We also have to define it mutually with proofs that it transposes the boundary.
SYM₀₀ : {Δ : Tel} (δ : el (SQ Δ)) → (SYM Δ δ) ₀ ₀ ≡ δ ₀₀
SYM₀₁ : {Δ : Tel} (δ : el (SQ Δ)) → (SYM Δ δ) ₁ ₀ ≡ δ ₁₀
SYM₀₂ : {Δ : Tel} (δ : el (SQ Δ)) → AP _₀ (SYM Δ δ) ≡ δ ₂₀
SYM₁₀ : {Δ : Tel} (δ : el (SQ Δ)) → (SYM Δ δ) ₀ ₁ ≡ δ ₀₁
SYM₁₁ : {Δ : Tel} (δ : el (SQ Δ)) → (SYM Δ δ) ₁ ₁ ≡ δ ₁₁
SYM₁₂ : {Δ : Tel} (δ : el (SQ Δ)) → AP _₁ (SYM Δ δ) ≡ δ ₂₁
SYM₂₀ : {Δ : Tel} (δ : el (SQ Δ)) → (SYM Δ δ) ₀ ≡ δ ₀₂
SYM₂₁ : {Δ : Tel} (δ : el (SQ Δ)) → (SYM Δ δ) ₁ ≡ δ ₁₂

-- Symmetry for types, of course, is a postulated operation.
postulate
  sym : {Δ : Tel} (A : el Δ → Type) (δ : el (SQ Δ))
        {a₀₀ : A (δ ₀₀)} {a₀₁ : A (δ ₀₁)} (a₀₂ : Id′ A (δ ₀₂) a₀₀ a₀₁)
        {a₁₀ : A (δ ₁₀)} {a₁₁ : A (δ ₁₁)} (a₁₂ : Id′ A (δ ₁₂) a₁₀ a₁₁)
        (a₂₀ : Id′ A (δ ₂₀) a₀₀ a₁₀) (a₂₁ : Id′ A (δ ₂₁) a₀₁ a₁₁) →
        Sq A δ a₀₂ a₁₂ a₂₀ a₂₁ →
        Sq A (SYM Δ δ)
             (coe← (Id′≡ A (SYM₀₂ δ) (coe←≡ʰ (cong A (SYM₀₀ δ)) a₀₀)
                         (coe←≡ʰ (cong A (SYM₀₁ δ)) a₁₀)) a₂₀)
             (coe← (Id′≡ A (SYM₁₂ δ) (coe←≡ʰ (cong A (SYM₁₀ δ)) a₀₁)
                         (coe←≡ʰ (cong A (SYM₁₁ δ)) a₁₁)) a₂₁)
             (coe← (Id′≡ A (SYM₂₀ δ) (coe←≡ʰ (cong A (SYM₀₀ δ)) a₀₀)
                         (coe←≡ʰ (cong A (SYM₁₀ δ)) a₀₁)) a₀₂)
             (coe← (Id′≡ A (SYM₂₁ δ) (coe←≡ʰ (cong A (SYM₀₁ δ)) a₁₀)
                         (coe←≡ʰ (cong A (SYM₁₁ δ)) a₁₁)) a₁₂)

-- Now we can define symmetry for telescopes by decomposing a collated
-- SQ, transposing and applying symmetry, and recomposing again.
SYM ε δ = []
SYM (Δ ▸ A) δ =
  sq∷ A (SYM Δ (popsq δ))
    {coe← (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ)}
    {coe← (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)}
    (coe← (Id′≡ A (SYM₀₂ (popsq δ)) (coe←≡ʰ (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ)) (coe←≡ʰ (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)))
          (top₂₀ δ))
    {coe← (cong A (SYM₁₀ (popsq δ))) (top₀₁ δ)}
    {coe← (cong A (SYM₁₁ (popsq δ))) (top₁₁ δ)}
    (coe← (Id′≡ A (SYM₁₂ (popsq δ)) (coe←≡ʰ (cong A (SYM₁₀ (popsq δ))) (top₀₁ δ)) (coe←≡ʰ (cong A (SYM₁₁ (popsq δ))) (top₁₁ δ)))
          (top₂₁ δ))
    (coe← (Id′≡ A (SYM₂₀ (popsq δ)) (coe←≡ʰ (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ)) (coe←≡ʰ (cong A (SYM₁₀ (popsq δ))) (top₀₁ δ)))
          (top₀₂ δ))
    (coe← (Id′≡ A (SYM₂₁ (popsq δ)) (coe←≡ʰ (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)) (coe←≡ʰ (cong A (SYM₁₁ (popsq δ))) (top₁₁ δ)))
          (top₁₂ δ))
    (sym A (popsq δ) (top₀₂ δ) (top₁₂ δ) (top₂₀ δ) (top₂₁ δ) (top₂₂ δ))

-- It remains to observe that this definition indeed transposes the boundary.

SYM₀₀ {ε} δ = reflᵉ
SYM₀₀ {Δ ▸ A} δ = ∷≡ A (SYM₀₀ (popsq δ)) (coe←≡ʰ (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ))

SYM₀₁ {ε} δ = reflᵉ
SYM₀₁ {Δ ▸ A} δ = ∷≡ A (SYM₀₁ (popsq δ)) (coe←≡ʰ (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ))

SYM₀₂ {ε} δ = reflᵉ
SYM₀₂ {Δ ▸ A} δ =
  ∷≡ (λ y → Id′ A (pop (pop y)) (top (pop y)) (top y))
      -- {AP (λ z → pop (pop (pop z)) ₀) (SYM (Δ ▸ A) δ)
      --   ∷ coe← (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ)
      --   ∷ coe← (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)}
      -- {pop (δ ₂₀)}
      (∷≡ (λ y → A (pop y ₁))
           -- {AP (λ z → pop (pop (pop z)) ₀) (SYM (Δ ▸ A) δ)
           --   ∷ coe← (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ)}
           -- {pop (pop (δ ₂₀))}
           (∷≡ (λ y → A (y ₀))
                -- {AP (λ z → pop (pop (pop z)) ₀) (SYM (Δ ▸ A) δ)}
                -- {pop (pop (pop (δ ₂₀)))}
                  (rev (AP-AP (λ z → pop (pop (pop z))) _₀ (SYM (Δ ▸ A) δ)) • SYM₀₂ (popsq δ))
                -- {coe← (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ)}
                -- {top (pop (pop (δ ₂₀)))}
                (coe←≡ʰ (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ)))
           -- {coe← (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)}
           -- {top (pop (δ ₂₀))}
           (coe←≡ʰ (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)))
      -- {coe→ (Id′-AP (λ z → pop (pop (pop z)) ₀)
      --               (SYM (Δ ▸ A) δ) A
      --               (coe← (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ))
      --               (coe← (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)))
      --   (coe← (Id′-AP (λ x → pop (pop (pop x)))
      --                 (SYM (Δ ▸ A) δ) (λ z → A (z ₀))
      --                 (coe← (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ))
      --                 (coe← (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)))
      --     (coe← (Id′-AP _₀ (SYM Δ (popsq δ)) A
      --                   (coe← (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ))
      --                   (coe← (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)))
      --       (coe← (Id′≡ A (SYM₀₂ (popsq δ))
      --             (coe←≡ʰ (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ))
      --             (coe←≡ʰ (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)))
      --         (top₂₀ δ))))}
      -- {top (δ ₂₀)}
      (coe→←←←≡ʰ
        (Id′-AP (λ z → pop (pop (pop z)) ₀)
          (SYM (Δ ▸ A) δ) A
          (coe← (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ))
          (coe← (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)))
        (Id′-AP (λ x → pop (pop (pop x)))
          (SYM (Δ ▸ A) δ) (λ z → A (z ₀))
          (coe← (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ))
          (coe← (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)))
        (Id′-AP _₀ (SYM Δ (popsq δ)) A
          (coe← (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ))
          (coe← (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)))
        (Id′≡ A (SYM₀₂ (popsq δ))
          (coe←≡ʰ (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ))
          (coe←≡ʰ (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)))
        (top₂₀ δ))

SYM₁₀ {ε} δ = reflᵉ
SYM₁₀ {Δ ▸ A} δ = ∷≡ A (SYM₁₀ (popsq δ)) (coe←≡ʰ (cong A (SYM₁₀ (popsq δ))) (top₀₁ δ))

SYM₁₁ {ε} δ = reflᵉ
SYM₁₁ {Δ ▸ A} δ = ∷≡ A (SYM₁₁ (popsq δ)) (coe←≡ʰ (cong A (SYM₁₁ (popsq δ))) (top₁₁ δ))

SYM₁₂ {ε} δ = reflᵉ
SYM₁₂ {Δ ▸ A} δ =
  ∷≡ (λ y → Id′ A (pop (pop y)) (top (pop y)) (top y))
    -- {AP (λ z → pop (pop (pop z)) ₁) (SYM (Δ ▸ A) δ)
    --   ∷ coe← (cong A (SYM₁₀ (popsq δ))) (top₀₁ δ)
    --   ∷ coe← (cong A (SYM₁₁ (popsq δ))) (top₁₁ δ)}
    -- {pop (δ ₂₁)}
    (∷≡ (λ y → A (pop y ₁))
      -- {AP (λ z → pop (pop (pop z)) ₁) (SYM (Δ ▸ A) δ)
      --   ∷ coe← (cong A (SYM₁₀ (popsq δ))) (top₀₁ δ)}
      -- {pop (pop (δ ₂₁))}
      (∷≡ (λ y → A (y ₀))
        -- {AP (λ z → pop (pop (pop z)) ₁) (SYM (Δ ▸ A) δ)}
        -- {pop (pop (pop (δ ₂₁)))}
          (rev (AP-AP (λ z → pop (pop (pop z))) _₁ (SYM (Δ ▸ A) δ)) • SYM₁₂ (popsq δ))
        -- {coe← (cong A (SYM₁₀ (popsq δ))) (top₀₁ δ)}
        -- {top (pop (pop (δ ₂₁)))}
        (coe←≡ʰ (cong A (SYM₁₀ (popsq δ))) (top₀₁ δ)))
      -- {coe← (cong A (SYM₁₁ (popsq δ))) (top₁₁ δ)}
      -- {top (pop (δ ₂₁))}
      (coe←≡ʰ (cong A (SYM₁₁ (popsq δ))) (top₁₁ δ)))
    -- {coe→ (Id′-AP (λ z → pop (pop (pop z)) ₁) (SYM (Δ ▸ A) δ) A
    --         (coe← (cong A (SYM₁₀ (popsq δ))) (top₀₁ δ))
    --         (coe← (cong A (SYM₁₁ (popsq δ))) (top₁₁ δ)))
    --  (coe← (Id′-AP (λ x → pop (pop x)) (SYM (Δ ▸ A) δ) (λ z → A (pop z ₁))
    --         (coe← (cong A (SYM₁₀ (popsq δ))) (top₀₁ δ))
    --         (coe← (cong A (SYM₁₁ (popsq δ))) (top₁₁ δ)))
    --  (coe← (Id′-AP≡ (λ x → pop x ₁)
    --      (SYM Δ (popsq δ) ∷ coe← (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ) ∷
    --       coe← (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)
    --       ∷
    --       frob₀₂ A (SYM Δ (popsq δ))
    --       (coe←
    --        (Id′≡ A (SYM₀₂ (popsq δ))
    --         (coe←≡ʰ (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ))
    --         (coe←≡ʰ (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)))
    --        (top₂₀ δ)))
    --      (SYM Δ (popsq δ) ₁₂)
    --      (AP-AP pop _₁
    --       (SYM Δ (popsq δ) ∷ coe← (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ) ∷
    --        coe← (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)
    --        ∷
    --        frob₀₂ A (SYM Δ (popsq δ))
    --        (coe←
    --         (Id′≡ A (SYM₀₂ (popsq δ))
    --          (coe←≡ʰ (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ))
    --          (coe←≡ʰ (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)))
    --         (top₂₀ δ))))
    --      A reflʰ reflʰ)
    --  (coe← (Id′≡ A (SYM₁₂ (popsq δ))
    --              (coe←≡ʰ (cong A (SYM₁₀ (popsq δ))) (top₀₁ δ))
    --              (coe←≡ʰ (cong A (SYM₁₁ (popsq δ))) (top₁₁ δ)))
    --        (top₂₁ δ))))}
    -- {top (δ ₂₁)}
    (coe→←←←≡ʰ
      (Id′-AP (λ z → pop (pop (pop z)) ₁) (SYM (Δ ▸ A) δ) A
        (coe← (cong A (SYM₁₀ (popsq δ))) (top₀₁ δ))
        (coe← (cong A (SYM₁₁ (popsq δ))) (top₁₁ δ)))
      (Id′-AP (λ x → pop (pop x)) (SYM (Δ ▸ A) δ) (λ z → A (pop z ₁))
        (coe← (cong A (SYM₁₀ (popsq δ))) (top₀₁ δ))
        (coe← (cong A (SYM₁₁ (popsq δ))) (top₁₁ δ)))
      (Id′-AP≡ (λ x → pop x ₁)
         (SYM Δ (popsq δ) ∷ coe← (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ) ∷
          coe← (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)
          ∷
          frob₀₂ A (SYM Δ (popsq δ))
          (coe←
           (Id′≡ A (SYM₀₂ (popsq δ))
            (coe←≡ʰ (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ))
            (coe←≡ʰ (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)))
           (top₂₀ δ)))
         (SYM Δ (popsq δ) ₁₂)
         (AP-AP pop _₁
          (SYM Δ (popsq δ) ∷ coe← (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ) ∷
           coe← (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)
           ∷
           frob₀₂ A (SYM Δ (popsq δ))
           (coe←
            (Id′≡ A (SYM₀₂ (popsq δ))
             (coe←≡ʰ (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ))
             (coe←≡ʰ (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)))
            (top₂₀ δ))))
         A reflʰ reflʰ)
      (Id′≡ A (SYM₁₂ (popsq δ))
          (coe←≡ʰ (cong A (SYM₁₀ (popsq δ))) (top₀₁ δ))
          (coe←≡ʰ (cong A (SYM₁₁ (popsq δ))) (top₁₁ δ)))
      (top₂₁ δ))

SYM₂₀ {ε} δ = reflᵉ
SYM₂₀ {Δ ▸ A} δ =
  ∷≡ (λ y → Id′ A (pop (pop y)) (top (pop y)) (top y))
    {(SYM Δ (popsq δ) ₀)
      ∷ (coe← (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ))
      ∷ (coe← (cong A (SYM₁₀ (popsq δ))) (top₀₁ δ))}
    {pop (δ ₀₂)}
    (∷≡ (λ y → A (pop y ₁))
      {(SYM Δ (popsq δ) ₀)
        ∷ (coe← (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ)) }
      {pop (pop (δ ₀₂))}
      (∷≡ (λ y → A (y ₀))
        {SYM Δ (popsq δ) ₀}
        {pop (pop (pop (δ ₀₂)))}
          (SYM₂₀ (popsq δ) • (AP-AP (λ z → pop (pop (pop z))) _₀ δ))
        {coe← (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ)}
        {top (pop (pop (δ ₀₂)))}
        (coe←≡ʰ (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ)))
      {coe← (cong A (SYM₁₀ (popsq δ))) (top₀₁ δ)}
      {top (pop (δ ₀₂))}
      (coe←≡ʰ (cong A (SYM₁₀ (popsq δ))) (top₀₁ δ)))
    {coe← (Id′≡ A (SYM₂₀ (popsq δ))
                    (coe←≡ʰ (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ))
                    (coe←≡ʰ (cong A (SYM₁₀ (popsq δ))) (top₀₁ δ)))
              (top₀₂ δ)}
    {top (δ ₀₂)}
    (coe←≡ʰ
      (Id′≡ A (SYM₂₀ (popsq δ))
       (coe←≡ʰ (cong A (SYM₀₀ (popsq δ))) (top₀₀ δ))
       (coe←≡ʰ (cong A (SYM₁₀ (popsq δ))) (top₀₁ δ)))
      (top₀₂ δ)
    •ʰ
    -- top₀₂ δ ≡ʰ top (δ ₀₂)
     {!coe→≡ʰ (Id′-AP (_₀ {Δ}) (popsq δ) A (top₀₀ δ) (top₀₁ δ)) (top (δ ₀₂))!})


SYM₂₁ {ε} δ = reflᵉ
SYM₂₁ {Δ ▸ A} δ = 
  ∷≡ (λ y → Id′ A (pop (pop y)) (top (pop y)) (top y))
    {(SYM Δ (popsq δ) ₁)
      ∷ (coe← (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ))
      ∷ (coe← (cong A (SYM₁₁ (popsq δ))) (top₁₁ δ))}
    {pop (δ ₁₂)}
    (∷≡ (λ y → A (pop y ₁))
      {(SYM Δ (popsq δ) ₁)
        ∷ (coe← (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)) }
      {pop (pop (δ ₁₂))}
      (∷≡ (λ y → A (y ₀))
        {SYM Δ (popsq δ) ₁}
        {pop (pop (pop (δ ₁₂)))}
          (SYM₂₁ (popsq δ) • (AP-AP (λ z → pop (pop (pop z))) _₁ δ))
        {coe← (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)}
        {top (pop (pop (δ ₁₂)))}
        (coe←≡ʰ (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ)))
      {coe← (cong A (SYM₁₁ (popsq δ))) (top₁₁ δ)}
      {top (pop (δ ₁₂))}
      (coe←≡ʰ (cong A (SYM₁₁ (popsq δ))) (top₁₁ δ)))
    {coe← (Id′≡ A (SYM₂₁ (popsq δ))
                    (coe←≡ʰ (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ))
                    (coe←≡ʰ (cong A (SYM₁₁ (popsq δ))) (top₁₁ δ)))
              (top₁₂ δ)}
    {top (δ ₁₂)}
    (coe←≡ʰ
      (Id′≡ A (SYM₂₁ (popsq δ))
       (coe←≡ʰ (cong A (SYM₀₁ (popsq δ))) (top₁₀ δ))
       (coe←≡ʰ (cong A (SYM₁₁ (popsq δ))) (top₁₁ δ)))
      (top₁₂ δ)
    •ʰ
    -- top₁₂ δ ≡ʰ top (δ ₁₂)
     {!coe→≡ʰ (Id′-AP (_₀ {Δ}) (popsq δ) A (top₁₀ δ) (top₁₁ δ)) (top (δ ₁₂)) ?!})


-- {-# REWRITE SYM₀₀ SYM₀₁ SYM₀₂ SYM₁₀ SYM₁₁ SYM₂₀ SYM₁₂ SYM₂₁ #-}

------------------------------
-- Symmetry is an involution
------------------------------

-- Similarly, we postulate that symmetry on types is an involution,
-- and prove from this that it is an involution on telescopes.

{-
SYM-SYM : (Δ : Tel) (δ : el (SQ Δ)) → SYM Δ (SYM Δ δ) ≡ δ

postulate
  sym-sym : {Δ : Tel} (A : el Δ → Type) (δ : el (SQ Δ))
        {a₀₀ : A (δ ₀₀)} {a₀₁ : A (δ ₀₁)} (a₀₂ : Id′ A (δ ₀₂) a₀₀ a₀₁)
        {a₁₀ : A (δ ₁₀)} {a₁₁ : A (δ ₁₁)} (a₁₂ : Id′ A (δ ₁₂) a₁₀ a₁₁)
        (a₂₀ : Id′ A (δ ₂₀) a₀₀ a₁₀) (a₂₁ : Id′ A (δ ₂₁) a₀₁ a₁₁) (a₂₂ : Sq A δ a₀₂ a₁₂ a₂₀ a₂₁) →
        sym A (SYM Δ δ) a₂₀ a₂₁ a₀₂ a₁₂ (sym A δ a₀₂ a₁₂ a₂₀ a₂₁ a₂₂) ≡ a₂₂

SYM-SYM Δ δ = {!!}

-- {-# REWRITE sym-sym SYM-SYM #-}
-}

{-
postulate
  AP-REFL≡SYM-REFL : (Γ Δ : Tel) (f : el Γ → el Δ) (γ : el (ID Γ)) →
    AP (λ x → REFL (f x)) γ ≡ SYM Δ (REFL (AP f γ))

{-# REWRITE AP-REFL≡SYM-REFL #-}
-}

{- Unported
postulate
  ap-refl : {Δ : Tel} {A : el Δ → Type} (f : (x : el Δ) → A x)
    {δ₀ δ₁ : el Δ} (δ₂ : el (ID Δ δ₀ δ₁)) →
    ap {Δ} (λ w → refl (f w)) {δ₀} {δ₁} δ₂ ≡
    {!sym A (REFL δ₀) (REFL δ₁) δ₂ δ₂ (DEGSQ-LR Δ δ₂) (refl (f δ₀)) (refl (f δ₁)) (ap f δ₂) (ap f δ₂)!}
-}
