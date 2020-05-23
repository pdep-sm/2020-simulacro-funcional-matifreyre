module Library where
import PdePreludat

{-
Nombre: Freyre, Matías
Legajo: No me acuerdo
-}

data Casillero = Propiedad { nombre :: String, precio :: Number, hipoteca :: Number, cobro :: Number } | 
                 Esquina { nombre :: String } | 
                 PagoImpuesto { nombre :: String, impuesto :: Number } 
                 deriving (Show, Eq)

cabildoYJuramento = Propiedad { nombre = "Cabildo y Juramento", precio = 1000, hipoteca = 700, cobro = 500}
cabildoYCongreso = Propiedad { nombre = "Cabildo y Congreso", precio = 1200, hipoteca = 800, cobro = 550}

carcel = Esquina "carcel"
descanso = Esquina "descanso"

impuestoPatrullaAntiOsos = PagoImpuesto "Patrulla anti osos" 5

data Posicion = Posicion { ubicacion :: Number, casillero :: Casillero } deriving Show

posicion2 = Posicion { ubicacion = 2, casillero = cabildoYJuramento }
posicion3 = Posicion { ubicacion = 3, casillero = impuestoPatrullaAntiOsos }
posicion4 = Posicion { ubicacion = 4, casillero = cabildoYCongreso }
posicion11 = Posicion { ubicacion = 11, casillero = descanso }
posicion21 = Posicion { ubicacion = 21, casillero = carcel }
posicion31 = Posicion { ubicacion = 31, casillero = carcel }

tablero = [posicion2, posicion3, posicion4, posicion11, posicion21, posicion31]

-- Punto 1
data Jugador = Jugador { ubicacionActual :: Number, propiedades :: [Casillero], dinero :: Number }

--data Jugador = Jugador { casilleroActual :: Posicion, propiedades :: [Casillero], dinero :: Number }
--ubicacionActual = ubicacion . casilleroActual

leo  = Jugador { ubicacionActual = 4, propiedades = [cabildoYJuramento], dinero = 1300 }
mati = Jugador { ubicacionActual = 10, propiedades = [], dinero = 2000 }

jugadores = [leo, mati]

-- Punto 2
buscarPosicionPara u = head . filter ((==u).ubicacion) $ tablero

-- Punto 3
tieneLaPropiedad jugador propiedad = elem propiedad $ propiedades jugador

-- Punto 4.a
cuantoCobraPor jugador propiedad
    | tieneLaPropiedad jugador propiedad = cobro propiedad
    | otherwise = 0

-- Punto 4.b
hipotecar jugador propiedad
    | tieneLaPropiedad jugador propiedad = sumarDinero (hipoteca propiedad) . quitarPropiedad propiedad $ jugador
    | otherwise = jugador

sumarDinero d jugador = jugador { dinero = dinero jugador + d } 
quitarPropiedad propiedad jugador = jugador { propiedades = filter (/= propiedad) $ propiedades jugador} 

-- Punto 5.a
casilleroActual = casillero . buscarPosicionPara . ubicacionActual
--casilleroActual' jugador = casillero . buscarPosicionPara . ubicacionActual $ jugador

-- Punto 5.b
estaParadoEn jugador casillero = (== casillero) . casilleroActual $ jugador
-- Con los parámetros invertidos:
--estaParadoEn casillero = (== casillero) . casilleroActual

-- Punto 6.a
puedeComprar jugador propiedad@(Propiedad _ _ _ _)  = and [
    ningunoTiene propiedad,
    tieneDineroPara jugador propiedad,
    estaParadoEn jugador propiedad]
puedeComprar _ _  = False

ningunoTiene :: Casillero -> Bool
ningunoTiene propiedad = all (not . flip tieneLaPropiedad propiedad) $ jugadores
--ningunoTiene' propiedad = not . any (flip tieneLaPropiedad propiedad) $ jugadores

tieneDineroPara :: Jugador -> Casillero -> Bool
tieneDineroPara jugador propiedad = (>= precio propiedad) . dinero $ jugador

-- Punto 6.b
intentarComprar jugador propiedad 
    | puedeComprar jugador propiedad    = sumarDinero (-precio propiedad) . agregarPropiedad propiedad $ jugador
    | otherwise                         = jugador

agregarPropiedad propiedad jugador = jugador { propiedades = propiedad : propiedades jugador }

-- Punto 7
intentarPagar jugador monto 
    | dinero jugador >= monto = sumarDinero (-monto) jugador
    | propiedades jugador /= [] = intentarPagar (hipotecar jugador (head $ propiedades jugador)) monto
    | otherwise = jugador { ubicacionActual = 0, dinero = 0, propiedades = [] }
--    | otherwise = Jugador 0 0 []

-- Punto 8
funcionSiniestra :: (Number->Bool) -> (a->Number) -> (b->a) -> [b] -> Bool
funcionSiniestra x y z = all x . map ((+5) . y . z)
{-
(Number->Bool) -> (a->Number) -> (b->a) -> [b] -> Bool
Tiene 4 parámetros, 3 visibles y 1 por la composición

-}
