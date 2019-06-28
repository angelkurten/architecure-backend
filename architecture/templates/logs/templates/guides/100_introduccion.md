Navigation: Introducción
SortOrder: 100

# Introducción

![arquitectura_general](/logs/elk-general.png)

### ¿Qué es ELK?

Es un conjunto de herramientas de gran potencial de código abierto que se combinan para crear una herramienta de administración de registros permitiendo la monitorización, consolidación y análisis de logs generados en múltiples servidores, estas herramientas son:ElasticSearch, Logstash y Kibana.

También pueden ser utilizadas como herramientas independientes, pero la unión de todas ellas hace una combinación perfecta para la gestión de registros como ya hemos mencionado.

ELK es un stack compuesta por tres pilares fundamentales: Elasticsearch, Logstash y Kibana. Podemos resumir diciendo que ELK:

### ¿Qué problemas intenta resolver Logstash?

#### Falta de consistencia

Tenemos muchos dispositivos con logs, y dentro de nuestros servidores, por ejemplo, tenemos distintos servicios funcionando y cada servicio tiene un tipo de log distinto. Los administradores de sistemas y DevOps genéricamente, o administradores web o desarrolladores, necesitan acceder a dichos logs para comprobarlos, para lo que hay una gran dificultad, ya que los formatos varían y son difíciles de entender.

#### Formato de Tiempo

En algunos logs se incluye la fecha, otros vienen con timestamp, otros con la hora al finalizar, etc.

* Ejemplo:
 
 ```
 Oct 04 12:15:21, 020289 07:23:24, 150260505
 ```
 
#### Descentralizado
 
 Los logs se encuentran repartidos en todos los servidores que tengamos, cada servidor puede tener un tipo de log y dentro de un servidor puede haber diferentes rutas donde encontrarlos. Un administrador de sistemas, si tiene pocos servidores que administrar, puede acceder a ellos por “ssh + grep”, pero si tiene muchos más, esta opción no es escalable.
 
#### Falta de conocimiento
 
 Falta de conocimientos o que no se implementan bien las políticas. Pueden deberse a varios motivos, por ejemplo:
 
 Las personas que tienen que acceder a un log no tienen permiso para acceder al mismo, por políticas de empresa.
 
 Estas personas no tienen experiencia para entender una línea de log. Algunos logs que tienen mucha información incluida en campos y cuando la información es tanta, a veces es complicado saber a qué representa cada número o cadena de texto.
 
 Desconocen dónde se encuentran los logs, cómo se actualizan, cómo se van repartiendo, si se van borrando cada día. etc
 
### ¿Qué busca realmente Elasticsearch?
 
 Lo que se consigue con ELK es coger toda esta información, procesarla y almacenarla de forma distribuida. Así se va a poder escalar en Big Data y obtener buenos rendimientos con grandes cantidades de información, y transformarla en visualizaciones, con las que poder identificar anomalías, comportamientos, eventos, picos, etc., de forma gráfica y visual, como en la diapositiva mostrada
 
### ¿Resumen?
  
  A modo de resumen, podemos decir que ELK lo que hace es:
  
  * Recolecta logs de eventos y de aplicaciones.
  * Procesa dicha información y la pone a disposición de las personas que la necesitan: Tiene módulos de seguridad para implementar que cada usuario accede a la información que realmente pueda administrar, evitando que un usuario acceda a información que no le pertenece.
  * Formatea los campos y los convierte en opciones de búsqueda y filtrado: Hay logs que tienen formatos irregulares, ya sean de aplicaciones propias o de servicios que no sigan ningún formato. Dichos logs son prácticamente cadenas de texto muy complicadas de entender. Con Logstach (parte de preprocesamiento que veremos a continuación) trabajaremos con dichos logs convertidos en distintos campos, que después podremos utilizar después para el filtrado.
  * Presenta esa información y esos campos en visualizaciones, donde podremos realizar búsquedas, filtrados, agregaciones y ver la información mucho mejor que módulos de texto.

### ¿Qué componentes forman ELK?
 
#### Elasticsearch
 
 Es una base de datos distribuida. Distribuye toda la información en todos los nodos, por tanto es tolerante a fallos y tiene alta disponibilidad. Al igual que distribuye la información, distribuye el procesamiento. Cuando se realiza una consulta o búsqueda y esa información se encuentra distribuida, será cada nodo el que procese dicha información y devuelva los resultados. Por tanto, podemos obtener mejores rendimientos.
 
#### Logstach
 
 Es la parte de preprocesamiento antes de guardar la información en Elasticsearch que hemos comentado, donde recogemos un input, una entrada, trabajamos los eventos y los sacamos por una salida, antes de almacenarlos en las bases de datos.
 
#### Kibana
 
Es el más visual, dónde vamos a generar las visualizaciones sobre la información y dónde vamos a generar los dashboards.

Estos tres componentes son los pilares, pero no son los únicos módulos que tiene ELK.

## Resumen Final

![arquitectura_general](/logs/elk.jpg)

Tenemos todas nuestras fuentes de datos, que envían información a Logstash, que al tener muchos plugins de entrada y salida, podemos introducir gran cantidad de datos. Esos datos son procesados antes de almacenarlos en la base de datos de Elasticsearch, y con Kibana se montan las visualizaciones que accedan a esa información, para poder así monitorizarlas.

##### Referencias

OPENWEBINARS. Academia en Linea. [Fecha de consulta: 14 mayo 2019], Disponible en: [https://openwebinars.net/blog/que-es-elk-elasticsearch-logstash-y-kibana/](https://openwebinars.net/blog/que-es-elk-elasticsearch-logstash-y-kibana/)
