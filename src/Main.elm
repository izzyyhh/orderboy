module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h1, h2, img, li, main_, p, section, text, ul)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)


type alias Product =
    { name : String
    , price : Float
    , id : String
    , image : String
    }


availableProducts : List Product
availableProducts =
    [ Product "Cappucino" 2.5 "1" "./images/coffee_640.jpg"
    , Product "Fresh Orange Juice" 2 "3" "./images/orange_640.jpg"
    , Product "Chocolate Milk" 2 "4" "./images/hot-chocolate_640.jpg"
    , Product "Brownie" 3.5 "2" "./images/brownie_640.jpg"
    , Product "Cheesecake" 7.5 "5" "./images/cheesecake_640.jpg"
    ]


type alias Model =
    { orderedProducts : List Product
    , availableProducts : List Product
    , currentTotal : Float
    , total : Float
    }


init : Model
init =
    { orderedProducts = []
    , availableProducts = availableProducts
    , currentTotal = 0
    , total = 0
    }


type Msg
    = ProductOrdered Product
    | ProdectOrderUndone
    | OrderPayed


update : Msg -> Model -> Model
update msg model =
    case msg of
        ProductOrdered p ->
            { model | orderedProducts = p :: model.orderedProducts, currentTotal = model.currentTotal + p.price }

        OrderPayed ->
            { model | total = model.total + model.currentTotal, currentTotal = 0, orderedProducts = [] }

        ProdectOrderUndone ->
            case model.orderedProducts of
                [] ->
                    model

                lastAdded :: rest ->
                    { model | orderedProducts = rest, currentTotal = model.currentTotal - lastAdded.price }


productView : Product -> Html Msg
productView product =
    button [ onClick (ProductOrdered product), class "product" ] [ img [ src product.image ] [], p [] [ text product.name ] ]


view : Model -> Html Msg
view model =
    main_ []
        [ h1 [] [ text "Orderboy" ]
        , section []
            [ h2 [] [ text "Products" ]
            , div [] [ ul [ class "available-list" ] (List.map (\p -> li [] [ productView p ]) model.availableProducts) ]
            , div [ class "actions-container" ]
                [ button [ onClick ProdectOrderUndone ] [ text "Undo" ]
                , button [ onClick OrderPayed ] [ text "Pay" ]
                ]
            , div [ class "info-container" ]
                [ p [] [ text ("Total Order: " ++ String.fromFloat model.currentTotal) ]
                , p [] [ text ("TOTAL: " ++ String.fromFloat model.total) ]
                ]
            , div [ class "currently-ordered-list" ] [ ul [] (List.map (\p -> li [] [ text p.name ]) model.orderedProducts) ]
            ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }
