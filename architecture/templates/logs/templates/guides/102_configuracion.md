Navigation: Configuracion 
SortOrder: 102

# Configuración

### Filebeat

Ir a `/etc/filebeat` y abrir el archivo filebeat.yml

* Modificar inputs    

```
filebeat.inputs:
- type: log
  enabled: true
  nginx_access: true
  fields:
    type: nginx_access
  paths:
    - "/var/log/nginx/access.log"    
  tags: [nginx_access]
  fields_under_root: true

- type: log
  enabled: true
  nginx_access: true
  fields:
    type: nginx_error
  paths:
    - "/var/log/nginx/error.log"    
  tags: [nginx_access]
  fields_under_root: true

- type: log
  enabled: true 
  paths:
    - path logs laravel *.log
  laravel: true
  processors:
    - add_host_metadata: ~
    - add_cloud_metadata: ~
    - decode_json_fields:
        fields: ['message']
        target: message_to_json
  fields:
    type: laravel
  tags: [laravel]
  fields_under_root: true

  
```

* Comentar  output elasticsearch.

```

#output.elasticsearch:
  # Array of hosts to connect to.
  #hosts: ["localhost:9200"]

  # Optional protocol and basic auth credentials.
  #protocol: "https"
  #username: "elastic"
  #password: "changeme"

```

* Habilitar  output logstash y definir certificados. 

```
output.logstash:
  # The Logstash hosts
  enable: true 
  hosts: ["localhost:5044"]

  # Optional SSL. By default is off.
  # List of root certificates for HTTPS server verifications
  ssl.certificate_authorities: ["logstash.crt"]
  timeout: 15

  # Certificate for SSL client authentication
  #ssl.certificate: "/etc/pki/client/cert.pem"

  # Client Certificate Key
  #ssl.key: "/etc/pki/client/cert.key"
 ```
  
### Logstash
 
 Ir a `/etc/logstash` y crear el directorio patterns
 
 * crear un archivo llamado nginx_access
 
```
#/etc/logstash/patterns/nginx_access
NGINX_ACCESS %{IPORHOST:clientip} (?:-|(%{WORD}.%{WORD})) %{USER:ident} \[%{HTTPDATE:timestamp}\] "(?:%{WORD:verb} %{NOTSPACE:request}(?: HTTP/%{NUMBER:httpversion})?|%{DATA:rawrequest})" %{NUMBER:response} (?:%{NUMBER:bytes}|-)( %{QS:referrer})?( %{QS:agent})?( %{QS:forwarder})?
```
 * crear un archivo llamado nginx_error
  
```
#/etc/logstash/patterns/nginx_error
NGINX_ERROR (?<timestamp>\d{4}/\d{2}/\d{2} \d{2}:\d{2}:\d{2}) \[%{DATA:severity}\] %{NOTSPACE} %{NOTSPACE} %{GREEDYDATA:message}(?:, client: (?<client>%{IP}|%{HOSTNAME}))(?:, server: %{IPORHOST:server})?(?:, request: %{QS:request})?(?:, upstream: "%{DATA:upstream}")?(?:, host: %{QS:host})?(?:, referrer: "%{URI:referrer}")?$
```
Ir a  `/etc/logstash/conf.d`

* crear un archivo llamado 02-beats-input.conf. Es necesario definir los certificados.

```
input {
  beats {
    port => 5044
    ssl => true
    ssl_certificate => "/etc/pki/tls/certs/logstash-beats.crt"
    ssl_key => "/etc/pki/tls/private/logstash-beats.key"
  }

```

* crear un archivo llamado 11-nginx.conf

```
filter {
  if [type] == "nginx_access" {
    grok {
      patterns_dir => "/etc/logstash/patterns"
      match => { "message" => "%{NGINX_ACCESS}" }
      remove_tag => ["_grokparsefailure"]
      add_tag => ["nginx_access"]
    }
    geoip {
      source => "clientip"
    }
  }else if [type] == "nginx_error" {
    grok {
      patterns_dir => "/etc/logstash/patterns"
      match => { "message" => "%{NGINX_ERROR}" }
      remove_tag => ["_grokparsefailure"]
      add_tag => ["nginx_error"]
    }
  }
}

```

* crear un arvhico llamado 30-output.conf

```
output {
  if [type] == "laravel" {
    elasticsearch {
      hosts => ["https://08c29a5ef00f4c6cb8a0c3dc56e5c71e.us-east-1.aws.found.io:9243"]
      user => "elastic"      
      password => "MBkrKbWmhTLHQcivATrisQSj"
      manage_template => false
      index => "%{[@metadata][beat]}-laravel-_NOMBRE_DEL_PROYECTO_-%{+YYYY.MM.dd}"
    }
  } else if [type] == "nginx_access"  {
   elasticsearch {
     hosts => ["https://08c29a5ef00f4c6cb8a0c3dc56e5c71e.us-east-1.aws.found.io:9243"]
     user => "elastic"
     password => "MBkrKbWmhTLHQcivATrisQSj"
     manage_template => false
     index => "%{[@metadata][beat]}-nginx-access-_NOMBRE_DEL_PROYECTO_-%{+YYYY.MM.dd}"
   }
  } else if [type] == "nginx_error"  {
   elasticsearch {
     hosts => ["https://08c29a5ef00f4c6cb8a0c3dc56e5c71e.us-east-1.aws.found.io:9243"]
     user => "elastic"
     password => "MBkrKbWmhTLHQcivATrisQSj"
     manage_template => false
     index => "%{[@metadata][beat]}-nginx-error-_NOMBRE_DEL_PROYECTO_-%{+YYYY.MM.dd}"
   }
  }
}
```

