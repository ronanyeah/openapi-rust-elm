module Codegen.Json exposing
    ( encodeData1, encodeStatsData
    , decodeData1, decodeStatsData
    )

{-|


## Encoders

@docs encodeData1, encodeStatsData


## Decoders

@docs decodeData1, decodeStatsData

-}

import Codegen.Types
import Json.Decode
import Json.Encode
import OpenApi.Common


decodeStatsData : Json.Decode.Decoder Codegen.Types.StatsData
decodeStatsData =
    Json.Decode.succeed
        (\data1 value1 -> { data1 = data1, value1 = value1 })
        |> OpenApi.Common.jsonDecodeAndMap
            (Json.Decode.field
                "data1"
                (Json.Decode.oneOf
                    [ Json.Decode.map
                        OpenApi.Common.Present
                        decodeData1
                    , Json.Decode.null OpenApi.Common.Null
                    ]
                )
            )
        |> OpenApi.Common.jsonDecodeAndMap
            (Json.Decode.field
                "value1"
                (Json.Decode.oneOf
                    [ Json.Decode.map
                        OpenApi.Common.Present
                        Json.Decode.string
                    , Json.Decode.null
                        OpenApi.Common.Null
                    ]
                )
            )


encodeStatsData : Codegen.Types.StatsData -> Json.Encode.Value
encodeStatsData rec =
    Json.Encode.object
        [ ( "data1"
          , case rec.data1 of
                OpenApi.Common.Null ->
                    Json.Encode.null

                OpenApi.Common.Present value ->
                    encodeData1 value
          )
        , ( "value1"
          , case rec.value1 of
                OpenApi.Common.Null ->
                    Json.Encode.null

                OpenApi.Common.Present value ->
                    Json.Encode.string value
          )
        ]


decodeData1 : Json.Decode.Decoder Codegen.Types.Data1
decodeData1 =
    Json.Decode.succeed
        (\value2 value3 -> { value2 = value2, value3 = value3 })
        |> OpenApi.Common.jsonDecodeAndMap
            (Json.Decode.field "value2" Json.Decode.int)
        |> OpenApi.Common.jsonDecodeAndMap
            (Json.Decode.field "value3" Json.Decode.int)


encodeData1 : Codegen.Types.Data1 -> Json.Encode.Value
encodeData1 rec =
    Json.Encode.object
        [ ( "value2", Json.Encode.int rec.value2 )
        , ( "value3", Json.Encode.int rec.value3 )
        ]
