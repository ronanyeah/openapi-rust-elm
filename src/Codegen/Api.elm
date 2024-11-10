module Codegen.Api exposing (healthHandler, healthHandlerTask, statsHandler, statsHandlerTask)

{-|


## Operations

@docs healthHandler, healthHandlerTask, statsHandler, statsHandlerTask

-}

import Codegen.Json
import Codegen.Types
import Dict
import Http
import Json.Decode
import OpenApi.Common
import Task
import Url.Builder


healthHandler config =
    Http.request
        { url = Url.Builder.crossOrigin "http://localhost:8888" [ "healthz" ] []
        , method = "GET"
        , headers = []
        , expect =
            OpenApi.Common.expectJsonCustom
                config.toMsg
                (Dict.fromList [])
                (Json.Decode.succeed ())
        , body = Http.emptyBody
        , timeout = Nothing
        , tracker = Nothing
        }


healthHandlerTask : {} -> Task.Task (OpenApi.Common.Error e String) ()
healthHandlerTask config =
    Http.task
        { url = Url.Builder.crossOrigin "http://localhost:8888" [ "healthz" ] []
        , method = "GET"
        , headers = []
        , resolver =
            OpenApi.Common.jsonResolverCustom
                (Dict.fromList [])
                (Json.Decode.succeed ())
        , body = Http.emptyBody
        , timeout = Nothing
        }


statsHandler config =
    Http.request
        { url = Url.Builder.crossOrigin "http://localhost:8888" [ "stats" ] []
        , method = "GET"
        , headers = []
        , expect =
            OpenApi.Common.expectJsonCustom
                config.toMsg
                (Dict.fromList [])
                Codegen.Json.decodeStatsData
        , body = Http.emptyBody
        , timeout = Nothing
        , tracker = Nothing
        }


statsHandlerTask : {} -> Task.Task (OpenApi.Common.Error e String) Codegen.Types.StatsData
statsHandlerTask config =
    Http.task
        { url = Url.Builder.crossOrigin "http://localhost:8888" [ "stats" ] []
        , method = "GET"
        , headers = []
        , resolver =
            OpenApi.Common.jsonResolverCustom
                (Dict.fromList [])
                Codegen.Json.decodeStatsData
        , body = Http.emptyBody
        , timeout = Nothing
        }
