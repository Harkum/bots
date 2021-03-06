module ParseMemoryReadingTest exposing (allTests)

import EveOnline.MemoryReading exposing (MaybeVisible(..))
import Expect
import Test exposing (..)


allTests : Test
allTests =
    describe "Parse memory reading"
        [ overview_entry_distance_text_to_meter
        , inventory_capacity_gauge_text
        ]


overview_entry_distance_text_to_meter : Test
overview_entry_distance_text_to_meter =
    [ ( "2,856 m", Ok 2856 )
    , ( "123 m", Ok 123 )
    , ( "16 km", Ok 16000 )
    , ( "   345 m  ", Ok 345 )
    ]
        |> List.map
            (\( displayText, expectedResult ) ->
                test displayText <|
                    \_ ->
                        displayText
                            |> EveOnline.MemoryReading.parseOverviewEntryDistanceInMetersFromText
                            |> Expect.equal expectedResult
            )
        |> describe "Overview entry distance text"


inventory_capacity_gauge_text : Test
inventory_capacity_gauge_text =
    [ ( "1,211.9/5,000.0 m³", Ok { used = 1211, maximum = Just 5000, selected = Nothing } )
    , ( " 123.4 / 5,000.0 m³ ", Ok { used = 123, maximum = Just 5000, selected = Nothing } )

    -- Example from https://forum.botengine.org/t/standard-mining-bot-problems/2715/14?u=viir
    , ( "4 999,8/5 000,0 m³", Ok { used = 4999, maximum = Just 5000, selected = Nothing } )

    -- 2020-01-31 sample 'process-sample-2FA2DCF580-[In Space with selected Ore Hold].zip' from Leon Bechen.
    , ( "0/5.000,0 m³", Ok { used = 0, maximum = Just 5000, selected = Nothing } )

    -- 2020-02-16-eve-online-sample
    , ( "(33.3) 53.6/450.0 m³", Ok { used = 53, maximum = Just 450, selected = Just 33 } )
    ]
        |> List.map
            (\( text, expectedResult ) ->
                test text <|
                    \_ ->
                        text
                            |> EveOnline.MemoryReading.parseInventoryCapacityGaugeText
                            |> Expect.equal expectedResult
            )
        |> describe "Inventory capacity gauge text"
