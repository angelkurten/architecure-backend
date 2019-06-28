Navigation: Estructura
SortOrder: 200

# The Graylog Extended Log Format (GELF)

Es un formato de logs que se crea para evitar las deficiencias presentes en el syslog.

* Longitud limitada de 1024 bytes
* No hay tipos de datos.
* Multiples dialectos. 

## Especificación

* **version**  `string (UTF-8)`
    * Versión de la especificación GELF utilizada. Debe ser establecido por el cliente.
* **host** `string (UTF-8)`
    * Aplicación/fuente que envió mensaje. Debe ser establecido por el cliente.
* **short_message** `string (UTF-8)`
    * Descripción corta. Debe ser establecido por el cliente.
* **full_message** `string (UTF-8)`
    * Descripción completa del LOG.  Debe ser establecido por el cliente.
* **timestamp** `number`
    * Fecha en la que se genera el LOG.  Debe ser establecido por el cliente.
* **time** `string (UTF-8) (YYYY-MM-DD HH:II)`
        * Fecha en la que se genera el LOG. String.  Debe ser establecido por el cliente.
* **level** `number`
    * Nivel según el estándar syslog.
* **line** `number`
    * Opcional. Linea del archivo en donde se origina el LOG. 

    
#### Syslog Severity Level:    
 
 1.    0  | EMERGENCY     | Condición de "pánico": ¿Notificar a todo el personal técnico? Se ven afectadas varias aplicaciones/servidores/sitios
 2.    1  | ALERT         | Debe ser corregida de inmediato: notificar al personal que puede solucinar el problema.
 3.    2  | CRITICAL      | Debe corregirse de inmediato, pero indica un error en un sistema primario: corrija problemas criticos antes del ALERT
 4.    3  | ERROR         | Fallos no urgentes: deben transmitirse a los desarrolladores. Cada error debe ser resuelto dentro de un tiempo determinado. 
 5.    4  | WARNING       | No es un error pero indica que se producirá un error si no se toman medidas.
 6.    5  | NOTICE        | Eventos inusuales que no son condiciones de error. No se requieren acciones inmediatas. 
 7.    6  | INFORMATIONAL | Mensajes operativos normales. Se recopilan para informar, medire rendimiento o comportamiento. 
 8.    7  | DEBUG         | Info para los desarrolladores. No se usa en produccion.
 
#### Ejemplo: 
```
    {
        "version": "1.0", 
        "host": "merqueo.com", 
        "short_message": "A short message that helps you identify what is going on", 
        "full_message": "trace", 
        "timestamp": 1385053862, 
        "time": "2019-05-21 13:01", 
        "level": 1, 
        "_name_class": "ExampleController", 
        "_name_method": "createAction"  
    }
```
