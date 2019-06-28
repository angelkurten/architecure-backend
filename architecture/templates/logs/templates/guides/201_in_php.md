Navigation: En-PHP
SortOrder:  201

# Configuración

## Definición Formato

La implementación se hace con monolog

### GelfMessageInterface

Define el comportamiento del formato del Log Gelf

```
 <?php
 
 
 namespace App\Libraries\Logger;
 
 
 /**
  * Interface GelfMessageInterface
  * @package App\Libraries\Logger
  */
 interface GelfMessageInterface
 {
 
     /**
      * Returns the GELF version of the message
      *
      * @return string
      */
     public function getVersion();
 
     /**
      * Returns the host of the message
      *
      * @return string
      */
     public function getHost();
 
     /**
      * Returns the short text of the message
      *
      * @return string
      */
     public function getShortMessage();
 
     /**
      * Returns the full text of the message
      *
      * @return string
      */
     public function getFullMessage();
 
     /**
      * Returns the timestamp of the message
      *
      * @return float
      */
     public function getTimestamp();
 
     /**
      * Returns the log level of the message as a Psr\Log\Level-constant
      *
      * @return string
      */
     public function getLevel();
 
     /**
      * Returns the log level of the message as a numeric syslog level
      *
      * @return int
      */
     public function getSyslogLevel();
 
     /**
      * Returns the facility of the message
      *
      * @return string
      */
     public function getFacility();
 
     /**
      * Returns the file of the message
      *
      * @return string
      */
     public function getFile();
 
     /**
      * Returns the the line of the message
      *
      * @return string
      */
     public function getLine();
 
     /**
      * Returns the value of the additional field of the message
      *
      * @param  string $key
      * @return mixed
      */
     public function getAdditional($key);
 
     /**
      * Checks if a additional fields is set
      *
      * @param  string $key
      * @return bool
      */
     public function hasAdditional($key);
 
     /**
      * Returns all additional fields as an array
      *
      * @return array
      */
     public function getAllAdditionals();
 
     /**
      * Converts the message to an array
      *
      * @return array
      */
     public function toArray();
 
 }


```

### GelfMessage

Sirve para construir el Log en el formato Gelf

```
 <?php


namespace App\Libraries\Logger;


use Psr\Log\LogLevel;
use RuntimeException;

/**
 * Class GelfMessage
 * @package App\Libraries\Logger
 */
class GelfMessage implements GelfMessageInterface
{

    protected $host;
    protected $shortMessage;
    protected $fullMessage;
    protected $timestamp;
    protected $level;
    protected $facility;
    protected $file;
    protected $line;
    protected $additionals = array();
    protected $version;

    /**
     * A list of the PSR LogLevel constants which is also a mapping of
     * syslog code to psr-value
     *
     * @var array
     */
    private static $psrLevels = array(
        LogLevel::EMERGENCY,    // 0
        LogLevel::ALERT,        // 1
        LogLevel::CRITICAL,     // 2
        LogLevel::ERROR,        // 3
        LogLevel::WARNING,      // 4
        LogLevel::NOTICE,       // 5
        LogLevel::INFO,         // 6
        LogLevel::DEBUG         // 7
    );

    /**
     * Creates a new message
     *
     * Populates timestamp and host with sane default values
     */
    public function __construct()
    {
        $this->timestamp = microtime(true);
        $this->host = gethostname();
        $this->level = 1; //ALERT
        $this->version = "1.0";
    }

    /**
     * Tries to convert a given log-level (psr or syslog) to
     * the psr representation
     *
     * @param mixed $level
     * @return string
     */
    final public static function logLevelToPsr($level)
    {
        $origLevel = $level;

        if (is_numeric($level)) {
            $level = intval($level);
            if (isset(self::$psrLevels[$level])) {
                return self::$psrLevels[$level];
            }
        } elseif (is_string($level)) {
            $level = strtolower($level);
            if (in_array($level, self::$psrLevels)) {
                return $level;
            }
        }

        throw new RuntimeException(
            sprintf("Cannot convert log-level '%s' to psr-style", $origLevel)
        );
    }

    /**
     * Tries to convert a given log-level (psr or syslog) to
     * the syslog representation
     *
     * @param mxied
     * @return integer
     */
    final public static function logLevelToSyslog($level)
    {
        $origLevel = $level;

        if (is_numeric($level)) {
            $level = intval($level);
            if ($level < 8 && $level > -1) {
                return $level;
            }
        } elseif (is_string($level)) {
            $level = strtolower($level);
            $syslogLevel = array_search($level, self::$psrLevels);
            if (false !== $syslogLevel) {
                return $syslogLevel;
            }
        }

        throw new RuntimeException(
            sprintf("Cannot convert log-level '%s' to syslog-style", $origLevel)
        );
    }

    /**
     * Returns the GELF version of the message
     *
     * @return string
     */
    public function getVersion()
    {
        return $this->version;
    }

    /**
     * Returns the host of the message
     *
     * @return string
     */
    public function getHost()
    {
        return $this->host;
    }

    /**
     * Returns the short text of the message
     *
     * @return string
     */
    public function getShortMessage()
    {
        return $this->shortMessage;
    }

    /**
     * Returns the full text of the message
     *
     * @return string
     */
    public function getFullMessage()
    {
        return $this->fullMessage;
    }

    /**
     * Returns the timestamp of the message
     *
     * @return float
     */
    public function getTimestamp()
    {
        return (float)$this->timestamp;
    }

    /**
     * Returns the log level of the message as a Psr\Log\Level-constant
     *
     * @return string
     */
    public function getLevel()
    {
        return self::logLevelToPsr($this->level);
    }

    /**
     * Returns the log level of the message as a numeric syslog level
     *
     * @return int
     */
    public function getSyslogLevel()
    {
        return self::logLevelToSyslog($this->level);
    }

    /**
     * Returns the facility of the message
     *
     * @return string
     */
    public function getFacility()
    {
        return $this->facility;
    }

    /**
     * Returns the file of the message
     *
     * @return string
     */
    public function getFile()
    {
        return $this->file;
    }

    /**
     * Returns the the line of the message
     *
     * @return string
     */
    public function getLine()
    {
        return $this->line;
    }

    /**
     * Returns the value of the additional field of the message
     *
     * @param string $key
     * @return mixed
     */
    public function getAdditional($key)
    {
        if (!isset($this->additionals[$key])) {
            throw new RuntimeException(
                sprintf("Additional key '%s' is not defined", $key)
            );
        }

        return $this->additionals[$key];
    }

    /**
     * Checks if a additional fields is set
     *
     * @param string $key
     * @return bool
     */
    public function hasAdditional($key)
    {
        return isset($this->additionals[$key]);
    }

    /**
     * Returns all additional fields as an array
     *
     * @return array
     */
    public function getAllAdditionals()
    {
        return $this->additionals;
    }

    /**
     * Converts the message to an array
     *
     * @return array
     */
    public function toArray()
    {
        $message = array(
            'version' => $this->getVersion(),
            'host' => $this->getHost(),
            'short_message' => $this->getShortMessage(),
            'full_message' => $this->getFullMessage(),
            'level' => $this->getSyslogLevel(),
            'timestamp' => $this->getTimestamp(),
            'time' => date('Y-m-d H:m:i', $this->getTimestamp()),
            'facility' => $this->getFacility(),
            'file' => $this->getFile(),
            'line' => $this->getLine()
        );

        // Transform 1.1 deprecated fields to additionals
        // Will be refactored for 2.0, see #23
        if ($this->getVersion() == "1.1") {
            foreach (array('line', 'facility', 'file') as $idx) {
                $message["_" . $idx] = $message[$idx];
                unset($message[$idx]);
            }
        }

        // add additionals
        foreach ($this->getAllAdditionals() as $key => $value) {
            $message["_" . $key] = $value;
        }

        // return after filtering empty strings and null values
        return array_filter($message, function ($message) {
            return is_bool($message)
                || (is_string($message) && strlen($message))
                || is_int($message)
                || !empty($message);
        });
    }

    /**
     * @param $version
     * @return $this
     */
    public function setVersion($version)
    {
        $this->version = $version;

        return $this;
    }

    /**
     * @param $host
     * @return $this
     */
    public function setHost($host)
    {
        $this->host = $host;

        return $this;
    }

    /**
     * @param $shortMessage
     * @return $this
     */
    public function setShortMessage($shortMessage)
    {
        $this->shortMessage = $shortMessage;

        return $this;
    }

    /**
     * @param $fullMessage
     * @return $this
     */
    public function setFullMessage($fullMessage)
    {
        $this->fullMessage = $fullMessage;

        return $this;
    }

    public function setTimestamp($timestamp)
    {
        if ($timestamp instanceof \DateTime || $timestamp instanceof \DateTimeInterface) {
            $timestamp = $timestamp->format("U.u");
        }

        $this->timestamp = (float)$timestamp;

        return $this;
    }

    /**
     * @param $level
     * @return $this
     */
    public function setLevel($level)
    {
        $this->level = self::logLevelToSyslog($level);

        return $this;
    }

    /**
     * @param $facility
     * @return $this
     */
    public function setFacility($facility)
    {
        $this->facility = $facility;

        return $this;
    }

    /**
     * @param $file
     * @return $this
     */
    public function setFile($file)
    {
        $this->file = $file;

        return $this;
    }

    /**
     * @param $line
     * @return $this
     */
    public function setLine($line)
    {
        $this->line = $line;

        return $this;
    }

    public function setAdditional($key, $value)
    {
        if (!$key) {
            return;
        }
        $this->additionals[$key] = $value;
        return $this;
    }

}


```

### GelfMessageFormatter

Formato usado por laravel para la construcción de los logs. Utiliza el GelfMessage 

```
 <?php


namespace App\Libraries\Logger;


use Monolog\Formatter\NormalizerFormatter;
use Monolog\Logger;

/**
 * Class GelfMessageFormatter
 * @package App\Libraries\Logger
 */
class GelfMessageFormatter extends NormalizerFormatter
{

    const DEFAULT_MAX_LENGTH = 32766;

    /**
     * @var string the name of the system for the Gelf log message
     */
    protected $systemName;

    /**
     * @var string a prefix for 'extra' fields from the Monolog record (optional)
     */
    protected $extraPrefix;

    /**
     * @var string a prefix for 'context' fields from the Monolog record (optional)
     */
    protected $contextPrefix;

    /**
     * @var int max length per field
     */
    protected $maxLength;

    /**
     * @var string
     */
    protected $version;


    /**
     * Translates Monolog log levels to Graylog2 log priorities.
     */
    private $logLevels = [
        Logger::DEBUG => 7,
        Logger::INFO => 6,
        Logger::NOTICE => 5,
        Logger::WARNING => 4,
        Logger::ERROR => 3,
        Logger::CRITICAL => 2,
        Logger::ALERT => 1,
        Logger::EMERGENCY => 0,
    ];

    public function __construct($systemName = null, $version, $extraPrefix = null, $contextPrefix = 'ctxt_', $maxLength = null)
    {
        parent::__construct('U.u');

        $this->systemName = $systemName ?: gethostname();
        $this->extraPrefix = $extraPrefix;
        $this->contextPrefix = $contextPrefix;
        $this->maxLength = is_null($maxLength) ? self::DEFAULT_MAX_LENGTH : $maxLength;
        $this->version = $version;
    }

    public function format(array $record)
    {
        $record = parent::format($record);
        
        if(!isset($record['datetime'])){
            $record['datetime'] = time(); 
        }

        if (!isset($record['message'], $record['level'])) {
           $record['message'] = 'The record should at least contain datetime, message and level keys'; 
           $record['level'] = 4;
        }

        $message = new GelfMessage();
        $message->setTimestamp($record['datetime'])
            ->setFullMessage((string)$record['message'])
            ->setHost($this->systemName)
            ->setLevel($this->logLevels[$record['level']])
            ->setVersion($this->version);

        if (isset($record ['context']['short_message'])) {
            $message->setShortMessage($record ['context']['short_message']);
            unset($record ['context']['short_message']);
        } else {
            $message->setShortMessage(substr((string)$record['message'], 0, 20));
        }

        if (isset($record ['context']['line'])) {
            $message->setLine($record ['context']['line']);
            unset($record ['context']['line']);
        }

        // message length + system name length + 200 for padding / metadata
        $len = 200 + strlen((string)$record['message']) + strlen($this->systemName);

        if ($len > $this->maxLength) {
            $message->setFullMessage(substr($record['message'], 0, $this->maxLength));
        }

        if (isset($record['channel'])) {
            $message->setFacility($record['channel']);
        }

        foreach ($record['extra'] as $key => $val) {
            $val = is_scalar($val) || null === $val ? $val : $this->toJson($val);
            $len = strlen($this->extraPrefix . $key . $val);
            if ($len > $this->maxLength) {
                $message->setAdditional($this->extraPrefix . $key, substr($val, 0, $this->maxLength));
                break;
            }
            $message->setAdditional($this->extraPrefix . $key, $val);
        }

        foreach ($record['context'] as $key => $val) {
            $val = is_scalar($val) || null === $val ? $val : $this->toJson($val);
            $len = strlen($this->contextPrefix . $key . $val);
            if ($len > $this->maxLength) {
                $message->setAdditional($this->contextPrefix . $key, substr($val, 0, $this->maxLength));
                break;
            }
            $message->setAdditional($this->contextPrefix . $key, $val);
        }

        return sprintf("%s\n", json_encode($message->toArray()));
    }


}
```

### Logger

Implementa el LoggerInterface, formato estandar definido en el PSR. 

Para la construcción  por defecto de los logs se usa el Facade de Laravel. 

```
<?php

namespace App\Libraries\Logger;

use Illuminate\Support\Facades\Log;
use Psr\Log\LoggerInterface;

/**
 * Class Logger
 * @package App\Libraries\Logger
 */
class Logger implements LoggerInterface
{

    /**
     * System is unusable.
     *
     * @param string $message
     * @param array $context
     *
     * @return void
     */
    public function emergency($message, array $context = array())
    {
        Log::emergency($message, $context);
    }

    /**
     * Action must be taken immediately.
     *
     * Example: Entire website down, database unavailable, etc. This should
     * trigger the SMS alerts and wake you up.
     *
     * @param string $message
     * @param array $context
     *
     * @return void
     */
    public function alert($message, array $context = array())
    {
        Log::alert($message, $context);
    }

    /**
     * Critical conditions.
     *
     * Example: Application component unavailable, unexpected exception.
     *
     * @param string $message
     * @param array $context
     *
     * @return void
     */
    public function critical($message, array $context = array())
    {
        Log::critical($message, $context);
    }

    /**
     * Runtime errors that do not require immediate action but should typically
     * be logged and monitored.
     *
     * @param string $message
     * @param array $context
     *
     * @return void
     */
    public function error($message, array $context = array())
    {
        Log::error($message, $context);
    }

    /**
     * Exceptional occurrences that are not errors.
     *
     * Example: Use of deprecated APIs, poor use of an API, undesirable things
     * that are not necessarily wrong.
     *
     * @param string $message
     * @param array $context
     *
     * @return void
     */
    public function warning($message, array $context = array())
    {
        Log::warning($message, $context);
    }

    /**
     * Normal but significant events.
     *
     * @param string $message
     * @param array $context
     *
     * @return void
     */
    public function notice($message, array $context = array())
    {
        Log::notice($message, $context);
    }

    /**
     * Interesting events.
     *
     * Example: User logs in, SQL logs.
     *
     * @param string $message
     * @param array $context
     *
     * @return void
     */
    public function info($message, array $context = array())
    {
        Log::info($message, $context);
    }

    /**
     * Detailed debug information.
     *
     * @param string $message
     * @param array $context
     *
     * @return void
     */
    public function debug($message, array $context = array())
    {
        Log::debug($message, $context);
    }

    /**
     * Logs with an arbitrary level.
     *
     * @param mixed $level
     * @param string $message
     * @param array $context
     *
     * @return void
     */
    public function log($level, $message, array $context = array())
    {
        Log::log($message, $context);
    }
}

?>
```

### Actualizar el config/logging

* Se crea un nuevo canal con el nombre de gelf.
* Se utiliza el Handler: RotatingFileHandler del monoglog y el formato GelfMessageFormatter previamente creado.
* Se define la versión  del formato. Se iniciara con la "1.0".
* Se define el nombre del archivo en donde se almacenará el log.  
 
```
'gelf' => [
            'driver' => 'monolog',
            'handler' => Monolog\Handler\RotatingFileHandler::class,
            'formatter' => App\Libraries\Logger\GelfMessageFormatter::class,
            'handler_with' => [
                'filename' => storage_path('logs/laravel.log'),
            ],
            'formatter_with' => [
                'version' => '1.0',
            ]
        ]
```

#### Ejemplo de respuesta del log:

```

{
    "version":"1.1",
    "host":"marlon-ThinkPad-E480",
    "short_message":"haciendo la numero 1",
    "full_message":"haciendo la numero 1",
    "level":5,
    "timestamp":1558390378.10217,
    "time":"2019-05-20 22:05:12",
    "_facility":"local",
    "_ctxt_ran":482044428705
}

{
    "version":"1.1",
    "host":"marlon-ThinkPad-E480",
    "short_message":"haciendo la numero 2",
    "full_message":"haciendo la numero 2",
    "level":5,"timestamp":1558390378.114139,
    "time":"2019-05-20 22:05:12",
    "_facility":"local",
    "_ctxt_ran":67714526673
}
 
```


## Implementación

Se solicita el **LoggerInterface** en el constructor de la clase que lo va a implementar.  

```
    private $logger; 

    public function __construct(LoggerInterface $logger) {
        $this->logger = $logger; 
    }   

```

Se usa el Logger siguiendo el estandar.
 
* Log info

```
    public function __invoke(Request $request, int $id) {
        $this->logger->info("Editando producto", [
            'product_id' => $id, 
            'name'  => $request->get('name'), 
            'value' => $request->get('value'), 
            'name_method_class' => __METHOD__
            'name_class' => __CLASS__
            'line' => __LINE__ 
        ]); 
    }
```

*  Log notice

```    
    public function __invoke(int $id) {
        try{
            $product = $this->product->findById($id);
        } catch(ProductNorFoundException $error){
            $this->logger->info("Editando producto", [
                'error' => $error->getMessage(),
                'trace' => $error->getTrace(),
                'product_id' => $id,
                'name_method_class' => __METHOD__
                'name_class' => __CLASS__
                'line' => __LINE__ 
            ]);         
        }    
    }  

```    
