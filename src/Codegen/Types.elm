module Codegen.Types exposing (Data1, StatsData)

{-|


## Aliases

@docs Data1, StatsData

-}

import OpenApi.Common


type alias StatsData =
    { data1 : OpenApi.Common.Nullable Data1
    , value1 : OpenApi.Common.Nullable String
    }


type alias Data1 =
    { value2 : Int, value3 : Int }
