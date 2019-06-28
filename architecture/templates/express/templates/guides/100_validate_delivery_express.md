Navigation: Express
SortOrder: 100

### Validar horario express 
Para generar un __horario express__, es necesario qué se cumplan __4 condiciones__ en el carrito:

Cumplidas las condiciones a continuación, el servicio de horarios retornará una franja adicional referente a express
 y el valor del parámetro __is_express__ será 1, de lo contrario, será 0.

- __Cobertura express:__ 
     
     Qué la dirección de entrega de la orden se enceuntre dentro de la cobertura express.
     Adjunto al final la imagen de la cobertura, correspondiente a la zona __Santa Paula__ asociada a la bodega 
     106

- __Productos disponibles en darksupermarket:__

    Qué los productos del carrito se encuentren disponibles en __darksupermarket__ (Bodega 106) 

- __Volumetría:__ 

    Qué los productos de la orden no exceda la capacidad máxima de 50 kg en peso o 125000 cm3 en volumen.

- __Servicio de atención darksupermarket:__  

    Qué la hora de creación de la orden esté dentro de la __franja horaria__ de servicio de __darksupermarket__
    8:00 am a 9:00 pm.          
     
    ![express](/express/cobertura-express-santa-paula.png)