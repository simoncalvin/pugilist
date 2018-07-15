module Request.Release exposing (Release, getCurrent)

import Debug
import Http
import HttpBuilder
import Json.Decode exposing (Decoder)
import Json.Decode.Pipeline as DecodePipeline


type alias Release =
    { title : String
    }


getCurrent : Http.Request (List Release)
getCurrent =
    let
        url =
            "http://localhost:3001/api/comics/v1/new"

        expect =
            Http.expectJson (Json.Decode.field "comics" <| Json.Decode.list decodeRelease)
    in
    HttpBuilder.get url
        |> HttpBuilder.withExpect expect
        |> HttpBuilder.toRequest


decodeRelease : Decoder Release
decodeRelease =
    DecodePipeline.decode Release
        |> DecodePipeline.required "title" Json.Decode.string
