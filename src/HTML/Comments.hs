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

module HTML.Comments where

import           DB

import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

commentsToHTML :: [Comment] -> H.Html
commentsToHTML comments = H.section H.! A.class_ "comments" $ mapM_ commentToHTML $ comments
  where
    commentToHTML (Comment name content steamId date _ _) =
      H.article H.! A.class_ "comment" $ do
        H.header $ do
          H.span H.! A.class_ "name" $ H.toHtml $ name
          H.span H.! A.class_ "steamId" $ H.toHtml $ steamId
          H.span H.! A.class_ "date" $ H.toHtml . show $ date
        H.p H.! A.class_ "content" $ H.toHtml $ content

