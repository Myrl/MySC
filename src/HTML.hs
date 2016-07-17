-- | This file is part of MySC.
-- |
-- | MySC is free software: you can redistribute it and/or modify
-- | it under the terms of the GNU General Public License as published by
-- | the Free Software Foundation, either version 3 of the License, or
-- | (at your option) any later version.
-- |
-- | MySC is distributed in the hope that it will be useful,
-- | but WITHOUT ANY WARRANTY; without even the implied warranty of
-- | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- | GNU General Public License for more details.
-- |
-- | You should have received a copy of the GNU General Public License
-- | along with MySC.  If not, see <http://www.gnu.org/licenses/>.

{-# LANGUAGE OverloadedStrings #-}

module HTML (module HTML.Comments, withStyle, defaultStyle) where

import           HTML.Comments

import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import           Clay

defaultStyle :: Css
defaultStyle = do
  importUrl "https://fonts.googleapis.com/css?family=Inconsolata"
  ".comment" ? do
    overflow hidden
    fontFamily ["Inconsolata"] [monospace]
    header ? do
      sym padding (px 2)
      star <? display inlineBlock
      ".steamId" <? marginLeft (px 10)
      ".date" <? float floatRight
      backgroundColor gray
    p ? do sym margin (px 0)
           sym padding (px 2)
    background lightgray
    sym borderRadius (px 4)
  ".comment" |+ ".comment" ? do
    marginTop (px 10)

withStyle :: Css -> H.Html -> H.Html
withStyle css html = H.docTypeHtml $ do
  H.head $ do
    H.style H.! A.type_ "text/css" $ H.toHtml $ renderWith compact [] css
  H.body html
