# Executar aplicativos Windows dentro do Docker

Você está cansado de instalar milhares de aplicativos no seu Linux para conseguir rodar aquele seu aplicativo Windows?

Seus problemas acabaram, agora você consegue rodar um aplicativo Windows no Linux usando Docker e o melhor não precisa instalar nada. Tudo fica no Docker.

Neste exemplo vamos rodar Winbox no Linux mais você pode utilizar para executar outros aplicativos...


###  Você pode iniciar a construção da imagem wine1.5 com:

```shell
docker build --rm -t wine1.5 .
```

###  Após um ou dois minutos, a compilação está concluída e a imagem resultante é armazenada localmente no host do Docker. Você pode dar uma olhada usando o comando docker images:

```shell
docker images | grep wine
```

# A maneira simples

## Executando o wine em um contêiner do Docker

A maneira mais simples é expor seu xhost para que o contêiner possa renderizar para a exibição correta lendo e gravando no soquete X11 unix.

Podemos ajustar as permissões do host do servidor X. Porém, essa não é a maneira mais segura, pois você compromete o controle de acesso ao servidor X em seu host. 

Portanto, com um pouco de esforço, alguém poderia exibir algo na tela, capturar a entrada do usuário, além de facilitar a exploração de outras vulnerabilidades que possam existir no X.

```shell
# para os preguiçosos e imprudentes
xhost +local:root
```

Para testar nossa imagem wine1.5 do Docker, executaremos o notepad aplicativo que acompanha o Wine:

```shell
docker run -it --rm --name winbox \
    --env="DISPLAY" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="winbox_data:/root/.wine" \
    wine1.5 \
    wine "C:\windows\system32\notepad.exe"
```

Se você está preocupado com isso (como deveria), depois que você terminar de usar a GUI em contêiner, isso retornará os controles de acesso que foram desabilitados com o comando anterior.

```shell
xhost -local:root
```

Para o mesmo exemplo acima só que utilizando o winbox

```shell
docker run -it --rm --name winbox \
    --env="DISPLAY" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="/home/edward/docker/docker-wine/wine-root:/root/.wine" \
    wine1.5 \
    wine /winbox/winbox64.exe
```

# A maneira mais segura

Outra maneira é usar as credenciais do seu próprio usuário para acessar o servidor de exibição. Isso envolve montar diretórios adicionais e tornar-se você mesmo no contêiner:

```shell
mkdir /home/$USER/wine_docker
docker run -it --rm --name winbox \
    --user=$(id -u $USER):$(id -g $USER) \
    --env="DISPLAY" \
    --volume="/etc/group:/etc/group:ro" \
    --volume="/etc/passwd:/etc/passwd:ro" \
    --volume="/etc/shadow:/etc/shadow:ro" \
    --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="/home/$USER/wine_docker:/home/$USER/.wine" \
    wine1.5 \
    wine /winbox/winbox64.exe
```

## Caso tenha problema com as fontes do Windows, copie a pasta fontes para este caminho.

```
./wine_docker/drive_c/windows/Fonts
```

## Rodar um terminal Docker para versão do Wine que compilamos.

```shell
docker run --rm -it --entrypoint /bin/bash wine1.5
```

## Rodar um terminal Docker para o Ubuntu 20.04 para realizar testes.


```shell
docker run --rm -it --name ubuntu --entrypoint /bin/bash ubuntu:20.04
```

### Para mais informações de como usar GUI's com Docker consulte o artigo relacionado:

- http://wiki.ros.org/docker/Tutorials/GUI