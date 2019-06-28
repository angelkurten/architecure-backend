Arquitectura
====

*Este repositorio almacena la documentación de la arquitectura y las definiciones de las apis en formato Open-Api v2.*

## Download
**Linux** *(amd64, x86)* **MAC** *(darwin-amd64)* **Windows** *(amd64, x86)*
 - [Dapperdox](http://dapperdox.io/download/downloads)


## Documentation

* [Dapperdox](http://dapperdox.io/docs/overview)
* [Swagger specification V2.0](https://swagger.io/docs/specification/2-0/basic-structure/)
* [Markdown syntax guide](https://confluence.atlassian.com/bitbucketserver/markdown-syntax-guide-776639995.html)
* [Markdown Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)


Installation in Linux
---

### Unzip

- Terminal: 
```
tar -xf dapperdox.tar.tgz
```

### Add dapperdox root directory to PATH
- Open file ~/.bashrc
```
export PATH=$PATH:/path_to_dapperdox
```
- Reload your profile settings
```
source ~/.bashrc
```

### Run!

```
cd architecturebackend/

./start.sh
```

Installation in MAC
---

### Unzip

- Terminal: 

```
gunzip -c dapperdox.tar.tgz | tar xopft -
```

### Copy

```
cd dapperdox/

cp dapperdox /usr/local/bin/dapperdox
```

### Run!

```
cd architecturebackend/

./start.sh
```