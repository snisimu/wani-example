{-# LANGUAGE OverloadedStrings #-}
module Main where

import qualified DTS.Prover.Wani.Prove as Wani
import qualified DTS.QueryTypes as QT
import qualified DTS.DTTdeBruijn as U

import qualified Data.Text.Lazy as T 
import qualified Data.Maybe as M
import qualified ListT as ListT
import qualified Control.Monad  as Monad

data QType = QType
  {label :: T.Text, -- ^ A short textual description of the query.
   predicted :: Bool, -- ^ Set to `True` if proof terms are expected as the results.
   maxDepth :: Int, -- ^ Maximum depth allowed for the proof search.
   maxTime :: Int, -- ^ Maximum time(milisecond) allowed for the proof search.
   debugDepth :: Int, -- ^ Maximum depth for displaying or debugging intermediate proof trees.
   mode :: QT.LogicSystem, -- ^ The logical system used for reasoning (e.g., 'QT.Classical' for classical logic).
   query :: U.ProofSearchQuery -- ^ The actual proof search query to be evaluated.
  }deriving (Show,Eq)


questions :: [QType]
questions = [q1,q2,q3,q4,q5,q6,q7,q8]

defaultQ :: QType
defaultQ = QType{
        label = "",
        predicted=True,
        maxDepth=5,
        maxTime=30000,
        debugDepth=(-1),
        mode=QT.Intuitionistic,
        query= U.ProofSearchQuery [] [] (U.Pi (U.Entity) (U.Var 0))
      }

q1 :: QType
q1 = 
  let
    sigEnv = [("p",U.Type)]
    varEnv = []
    pre_type = U.Pi (U.Con "p") (U.Con "p")
    predicted = True
    maxDepth = 5
    label = "q1 id"  
  in defaultQ{label = label,predicted=predicted,maxDepth=maxDepth,query=U.ProofSearchQuery sigEnv varEnv pre_type}


q2 :: QType
q2 = 
  let
    sigEnv = [("p",U.Type)]
    varEnv = []
    pre_type = U.Pi (U.Con "p") (U.Con "p")
    predicted = True
    maxDepth = 5
    debugDepth = 1
    label = "q2 id with debug"  
  in defaultQ{label = label,predicted=predicted,maxDepth=maxDepth,debugDepth=debugDepth,query=U.ProofSearchQuery sigEnv varEnv pre_type}

q3 :: QType
q3 = 
  let
    sigEnv = [("mammals",U.Pi (U.Entity) (U.Type)),("green",U.Pi (U.Entity) (U.Type)),("reptiles",U.Pi (U.Entity) (U.Type)),("wani",U.Pi (U.Entity) (U.Type))]
    varEnv = [(U.Pi (U.Sigma (U.Entity) (U.App (U.Con "wani") (U.Var 0))) ( U.Sigma (U.App (U.Con "green") (U.Proj U.Fst (U.Var 0))) (U.App (U.Con "reptiles") (U.Proj U.Fst (U.Var 1)))))]
    pre_type = (U.Pi (U.Sigma (U.Entity) (U.App (U.Con "wani") (U.Var 0))) (U.App (U.Con "reptiles") (U.Proj U.Fst (U.Var 0))))
    predicted = True
    maxDepth = 5
    label = "q3 p : Wanis are green reptiles. h : Wanis are reptiles."  
  in defaultQ{label = label,predicted=predicted,maxDepth=maxDepth,query=U.ProofSearchQuery sigEnv varEnv pre_type}

q4 :: QType
q4 = 
  let
    sigEnv = [("mammals",U.Pi (U.Entity) (U.Type)),("green",U.Pi (U.Entity) (U.Type)),("reptiles",U.Pi (U.Entity) (U.Type)),("wani",U.Pi (U.Entity) (U.Type))]
    varEnv = [(U.Pi (U.Sigma (U.Entity) (U.App (U.Con "wani") (U.Var 0))) ( U.Sigma (U.App (U.Con "green") (U.Proj U.Fst (U.Var 0))) (U.App (U.Con "reptiles") (U.Proj U.Fst (U.Var 1)))))]
    pre_type = (U.Pi (U.Sigma (U.Entity) (U.App (U.Con "wani") (U.Var 0))) ( U.Pi (U.App (U.Con "mammals") (U.Proj U.Fst (U.Var 0))) U.Bot))
    predicted = False
    maxDepth = 5
    label = "q4 p : Wanis are green reptiles. h : Wanis are not mammals."  
  in defaultQ{label = label,predicted=predicted,maxDepth=maxDepth,query=U.ProofSearchQuery sigEnv varEnv pre_type}

q5 :: QType
q5 = 
  let
    sigEnv = [("mammals",U.Pi (U.Entity) (U.Type)),("green",U.Pi (U.Entity) (U.Type)),("reptiles",U.Pi (U.Entity) (U.Type)),("wani",U.Pi (U.Entity) (U.Type))]
    varEnv = [
        (U.Pi (U.Sigma (U.Entity) (U.App (U.Con "reptiles") (U.Var 0))) (U.Pi (U.App (U.Con "mammals") (U.Proj U.Fst (U.Var 0))) (U.Bot))),
        (U.Pi (U.Sigma (U.Entity) (U.App (U.Con "wani") (U.Var 0))) ( U.Sigma (U.App (U.Con "green") (U.Proj U.Fst (U.Var 0))) (U.App (U.Con "reptiles") (U.Proj U.Fst (U.Var 1)))))
      ]
    pre_type = (U.Pi (U.Sigma (U.Entity) (U.App (U.Con "wani") (U.Var 0))) ( U.Pi (U.App (U.Con "mammals") (U.Proj U.Fst (U.Var 0))) U.Bot))
    predicted = True
    maxDepth = 5
    label = "q5 p : Wanis are green reptiles. reptiles cannot be a mammals. h : Wanis are not mammals."  
  in defaultQ{label = label,predicted=predicted,maxDepth=maxDepth,query=U.ProofSearchQuery sigEnv varEnv pre_type}

q6 :: QType
q6 = 
  let
    sigEnv = [("p",U.Type),("q",U.Type)]
    varEnv = []
    pre_type = U.Pi (U.Pi (U.Pi (U.Con "p") (U.Con "q")) (U.Con "p")) (U.Con "p")
    predicted = True
    maxDepth = 20
    mode = QT.Classical
    label = "q6 pars with DNE"  
  in defaultQ{label = label,predicted=predicted,maxDepth=maxDepth,query=U.ProofSearchQuery sigEnv varEnv pre_type}


q7 :: QType
q7 = 
  let
    sigEnv = [("p",U.Type),("q",U.Type)]
    varEnv = []
    pre_type = U.Pi (U.Pi (U.Pi (U.Con "p") (U.Con "q")) (U.Con "p")) (U.Con "p")
    predicted = False
    maxDepth = 20
    label = "q7 pars without DNE"
  in defaultQ{label = label,predicted=predicted,maxDepth=maxDepth,query=U.ProofSearchQuery sigEnv varEnv pre_type}

q8 :: QType
q8 = 
  let
    sigEnv = [("human",U.Pi U.Entity U.Type),("prof",U.Pi U.Entity U.Type),("aProf",U.Pi U.Entity U.Type),("wAtM",U.Pi U.Entity U.Type)]
    varEnv = [
        U.Disj (U.Sigma (U.Sigma (U.Entity) (U.App (U.Con "prof") (U.Var 0))) (U.App (U.Con "wAtM") (U.Proj U.Fst (U.Var 0)))) (U.Sigma (U.Sigma (U.Entity) (U.App (U.Con "aProf") (U.Var 0))) (U.App (U.Con "wAtM") (U.Proj U.Fst (U.Var 0)))),
        U.Pi (U.Sigma (U.Entity) (U.App (U.Con "aProf") (U.Var 0))) (U.App (U.Con "human") (U.Proj U.Fst (U.Var 0))),
        U.Pi (U.Sigma (U.Entity) (U.App (U.Con "prof") (U.Var 0))) (U.App (U.Con "human") (U.Proj U.Fst (U.Var 0)))
      ]
    pre_type = U.Sigma (U.Entity) (U.App (U.Con "human") (U.Var 0))
    predicted = True
    maxDepth = 9
    label = "q8 A professor or an assistant professor will attend the meeting of the university board. [She] will report to the faculy."
  in defaultQ{label = label,predicted=predicted,maxDepth=maxDepth,query=U.ProofSearchQuery sigEnv varEnv pre_type}


qn :: QType
qn =  defaultQ{query=undefined}

main :: IO ()
main = do
  let setting = QT.ProofSearchSetting{QT.maxDepth=Just 5,QT.maxTime=Just 300000,QT.logicSystem=Just QT.Classical,QT.oracle=M.Nothing}
  -- results <- ListT.toList $ Wani.prove' setting query1
  results <- Monad.forM questions $ (\q -> do
      isNull <- ListT.null $ Wani.prove' setting{QT.maxTime= Just (maxTime q),QT.maxDepth=Just (maxDepth q),QT.logicSystem=Just (mode q)} (query q)
      return $ ((label q),(predicted q) == not isNull)) 
  putStrLn "wani-example: testing lightblue imports"
  putStrLn (show results)