module Codegen.Types exposing
    ( Data1, StatsData
    , Empty___Or_Data1(..)
    )

{-|


## Aliases

@docs Data1, StatsData


## One of

@docs Empty___Or_Data1

-}

import OpenApi.Common


type alias StatsData =
    { data1 : Maybe Empty___Or_Data1
    , value1 : Maybe (OpenApi.Common.Nullable String)
    }


type alias Data1 =
    { value2 : Int, value3 : Int }


type Empty___Or_Data1
    = Empty___Or_Data1__Empty__ ()
    | Empty___Or_Data1__Data1 Data1
