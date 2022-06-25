{-# OPTIONS --exact-split --type-in-type --rewriting --two-level --without-K #-}

module HOTT.Everything where

import HOTT.Rewrite
import HOTT.Telescope
import HOTT.Id
import HOTT.Refl

import HOTT.Square
import HOTT.Sym
import HOTT.Transport
import HOTT.Fill

import HOTT.Unit
import HOTT.Prod
import HOTT.Sigma

-- Since the identity types of non-dependent function types involve
-- *dependent* function types, the Arrow files import Pi.Base.
-- However, Arrow.Transport is unfeasibly slow if it also imports
-- Pi.Transport, and because of
-- https://github.com/agda/agda/issues/4343 this happens even if
-- Pi.Transport has been imported by another file previously.  Thus,
-- here we import Arrow before Pi, and allow Pi.Base to be compiled
-- automatically as needed by Arrow.
import HOTT.Arrow

import HOTT.Pi
import HOTT.Copy
import HOTT.Universe

import HOTT.Test
