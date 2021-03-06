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
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import           DB
import           HTML

import qualified Data.Text as T
import           Control.Monad.IO.Class  (liftIO)
import           Control.Monad.Logger
import           Database.Persist hiding (get)
import           Database.Persist.Postgresql hiding (get)
import           Database.Persist.TH
import           Web.Spock hiding (SessionId)
import           Web.Spock.Config
import           Data.HVect
import qualified Data.ByteString as B
import           Data.Time
import qualified Data.Text as T
import           Control.Monad
import           Text.Blaze.Html.Renderer.String

connStr = "host=localhost dbname=comment user=comment password=comment port=5432"

main = do
  pool <- runNoLoggingT $ createPostgresqlPool connStr 5
  runNoLoggingT $ runSqlPool (runMigration migrateAll) pool
  spockCfg <- defaultSpockCfg Nothing (PCPool pool) connStr
  runSpock 8080 $ spock spockCfg commentSystem
  
data BlogState
   = BlogState
   { bs_cfg :: BlogCfg
   }

data BlogCfg
   = BlogCfg
   { bcfg_db   :: T.Text
   , bcfg_port :: Int
   , bcfg_name :: T.Text
   , bcfg_desc :: T.Text
}

type SessionVal = Maybe SessionId
type CommentSystem ctx = SpockCtxM ctx SqlBackend SessionVal B.ByteString ()
type CommentAction ctx a = SpockActionCtx ctx SqlBackend SessionVal B.ByteString a

commentSystem :: CommentSystem ()
commentSystem =
  prehook baseHook $ do
    get root $ do
      allPosts <- fmap (map (entityVal)) . runSQL $ selectList [] [Desc CommentDate]
      html . T.pack . renderHtml . withStyle defaultStyle . commentsToHTML $ allPosts
    post root $ void $ do
      now <- liftIO $ getCurrentTime
      comment@(Comment _ _ _ _ Nothing Nothing) <- jsonBody'
      runSQL $ insert comment

baseHook :: CommentAction () (HVect '[])
baseHook = return HNil
