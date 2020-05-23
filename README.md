# Simulacro de Parcial de Funcional

## Monopoly

![Monopoly](https://upload.wikimedia.org/wikipedia/commons/thumb/d/df/German_Monopoly_board_in_the_middle_of_a_game.jpg/245px-German_Monopoly_board_in_the_middle_of_a_game.jpg)

Vamos a modelar el clásico juego Monopoly (y, por extensión, también el Estanciero y el Trust). Para eso, contamos con un modelo parcial para usar de base. El mismo incluye los siguientes elementos:

__Casillero__: para simplificar, vamos a manejar tres tipos de casilleros dentro del tablero del juego:
Con PdePreludat:
```
{-Con PdePreludat-}
data Casillero = Propiedad { nombre :: String, precio :: Number, hipoteca :: Number, cobro :: Number } | 
                 Esquina { nombre :: String } | 
                 PagoImpuestos { nombre :: String, impuesto :: Number } 
                 deriving (Show, Eq)

{-Sin PdePreludat-}
data Casillero = Propiedad { nombre :: String, precio :: Int, hipoteca :: Int, cobro :: Int } | 
                 Esquina { nombre :: String } | 
                 PagoImpuestos { nombre :: String, impuesto :: Int } 
                 deriving (Show, Eq)
```

- __Propiedad__: localidad que cualquier jugador puede comprar, mientras que no haya sido comprada por otro jugador. De la misma, conocemos su nombre, su precio (un número entero), su valor de hipoteca (un número entero) y el cobro que recibe su propietario en caso de que otro jugador caiga en la propiedad. Algunos ejemplos de propiedades:
  ```
  cabildoYJuramento = Propiedad { nombre = "Cabildo y Juramento", precio = 1000, hipoteca = 700, cobro = 500}
  cabildoYCongreso = Propiedad { nombre = "Cabildo y Congreso", precio = 1200, hipoteca = 800, cobro = 550}
  ```
- __Esquina__: es un casillero dentro del cual, no hay nada para hacer, excepto recibir un premio, un castigo, o nada. Pero esto depende del tablero, más adelante veremos cómo usar esta información.
  
  ```
  carcel = Esquina "carcel"
  descanso = Esquina "descanso"
  ```
- __PagoImpuesto__: es un casillero en el cual, el jugador, al caer en el, debe pagar un impuesto definido por este casillero. Para el PagoImpuesto, conocemos su nombre, y su valor a pagar, que es un número entero (el juego viene sin centavos).
  
  ```
  impuestoPatrullaAntiOsos = PagoImpuesto "Patrulla anti osos" 5
  ```
__Posición__: de una posición, conocemos su ubicación, que es un valor numérico (que indica su orden dentro del tablero), y el casillero que involucra. Algunos ejemplos:
```
{-Con PdePreludat-}
data Posicion = Posicion { ubicacion :: Number, casillero :: Casillero } deriving Show

{-Sin PdePreludat-}
data Posicion = Posicion { ubicacion :: Int, casillero :: Casillero } deriving Show
```
```
posicion2 = Posicion { ubicacion = 2, casillero = cabildoYJuramento }
posicion3 = Posicion { ubicacion = 3, casillero = impuestoPatrullaAntiOsos }
posicion4 = Posicion { ubicacion = 4, casillero = cabildoYCongreso }
posicion11 = Posicion { ubicacion = 11, casillero = descanso }
posicion21 = Posicion { ubicacion = 21, casillero = carcel }
posicion31 = Posicion { ubicacion = 31, casillero = carcel }
```
__Tablero__: es una lista de posiciones, que relacionan a todas los casilleros del juego (tiene exactamente 40 elementos, pero no necesariamente ordenados). Conocemos al tablero, que puede usarse en cualquier momento del juego:
```
tablero = [posicion2, posicion3, posicion4... posicion11... posicion21... posicion31...]  --(etc.)
```
Se pide definir las funciones requeridas a continuación, maximizando el uso de composición, aplicación parcial y orden superior. __No usar recursividad__ a menos que se indique como permitida. La falta de aplicación o uso incorrecto de alguno de los conceptos mencionados puede implicar recuperación del tema en cuestión.

1. Crear un nuevo tipo de datos para representar al jugador. El mismo tendrá la información de la ubicación actual (número del casillero, de 1 a 40), las propiedades que tiene en su haber, y el dinero del cual dispone actualmente (número entero, el juego no maneja centavos). Sabiendo que se dispone de una función constante jugadores que devuelve la lista con todos los jugadores (vaya coincidencia), modelar a los mismos:
   1. Leo: Se encuentra en la ubicación 4, compró la propiedad de Cabildo y Juramento, y tiene $1300.
   2. Mati: Se encuentra en la ubicación 10, no compró propiedades y dispone de $2000.
2. __buscarPosicionPara__: recibe una ubicación (numérica), y devuelve la posición del tablero que corresponde a la ubicación recibida.
    __Notas__: No asumir que el tablero está ordenado, ya se indicó que puede no estarlo, y tampoco controlar que el número de ubicación sea válido, se asume que lo es.

3. __tieneLaPropiedad__: recibe un jugador y una propiedad, y nos dice si ese jugador ya la compró.

4. 
   1. __cuantoCobraPor__: para un jugador y una propiedad, determina cuánto cobra el jugador por dicha propiedad, en caso de que otro jugador caiga en ella. Si el jugador no tiene la propiedad, cobra 0.
   2. __hipotecar__: recibe un jugador y una propiedad, y si dicho jugador la posee, puede hipotecarla, perdiéndola de su lista de propiedades, y ganando dinero extra correspondiente al valor de hipoteca de la propiedad.

5. 
   1. __casilleroActual__: recibe un jugador, y nos dice en qué casillero está actualmente.
   2. __estaParadoEn__: recibe un jugador y un casillero, y nos dice si el jugador está parado en ese casillero (es decir, si existe una posición con dicho casillero, y con una ubicación que coincida con el del jugador).

6. 
   1. __puedeComprar__: nos dice si un jugador puede comprar un casillero. Para una propiedad, esto se da cuando ningún jugador tiene la propiedad aún, el jugador tiene suficiente dinero para comprarla y, además, el jugador se encuentra parado sobre esa propiedad. Los casilleros que no son propiedades nunca pueden comprarse.
   2. __intentarComprar__: recibe un jugador y una propiedad, y nos devuelve al jugador con la propiedad comprada, siempre que pueda comprarla con el dinero que ya tiene. El nuevo jugador, deberá tener dicha propiedad entre sus pertenencias, y además se debe disminuir su dinero en el precio de la propiedad.

7. __Nota__: Para este punto, se puede usar recursividad.
   
   __intentarPagar__: esta función recibe un jugador y un monto, y devuelve al jugador con el monto pagado. Para ello, se debe restar del dinero que tiene el jugador, el monto correspondiente; si no llega, debe hipotecar la primer propiedad que tenga en la lista, y verificar si llega al monto; si no llega, debe seguir hipotecando. Por ejemplo, si tiene que pagar un impuesto, ya hipotecó todo lo que tenía y aún así no puede pagar el impuesto, entonces queda fuera de juego (su ubicación asume el valor 0, su dinero también, y sus propiedades se vuelven una lista vacía). 

8. Explicar la inferencia del tipo de la siguiente función:
    ```
    funcionSiniestra x y z = all x . map ((+5) . y . z)
    ```