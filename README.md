![master version](https://img.shields.io/github/package-json/v/jerryc127/hexo-theme-butterfly/master?color=%231ab1ad&label=master)![https://img.shields.io/npm/v/hexo-theme-butterfly?color=%09%23bf00ff](https://img.shields.io/npm/v/hexo-theme-butterfly?color=%09%23bf00ff)
![hexo version](https://img.shields.io/badge/hexo-5.3.0+-0e83c)
![license](https://img.shields.io/github/license/jerryc127/hexo-theme-butterfly?color=FF5531)

![](https://cdn.jsdelivr.net/gh/jerryc127/CDN@m2/img/theme-butterfly-readme.png)

预览: 👍 [Butterfly](https://butterfly.js.org/)  ||  🤞 [CrazyWong](https://crazywong.com/)

文档: 📖 [Butterfly Docs](https://butterfly.js.org/posts/21cfbf15/)
>
> 一款基于hexo的butterfly主题封装的docker镜像，同时增加了oh-my-zsh、vim和git方便编辑和部署。[Butterfly Github](https://github.com/jerryc127/hexo-theme-butterfly)
>
## 一、准备
### 1. 配置本地git账号
无论是初始化一个新的博客网站，还是从已有文件里恢复，本镜像的启动脚本都需要git的账号信息。所以请用如下命令，查看是否有输出：
```bash
# 查看是否设置了用户名
git config --show user.name
# 查看是否设置了用户邮箱
git config --show user.email
```
如果没有设置，请用如下命令设置用户名和用户邮箱：
```bash
git config --global user.name "用户名"
git config --global user.email "邮箱"
```
### 2. （可选）配置github ssh密钥
如果需要从github等代码托管网站上恢复，需要配置ssh密钥
## 二、部署
### 2.1 Docker命令形式
**1. 新建hexo博客**
```bash
docker run -d --name blog -p 4000:4000 -v $HOME/.gitconfig:/root/.gitconfig:ro -v $HOME/.ssh:/root/.ssh:ro -v 'hexo目录':/root/blog cyicz123/butterfly:4.4.0 --init
```
用如下命令可进入docker容器
```bash
docker exec -it blog /usr/bin/zsh
```
按`ctrl + d`退出容器

容器生成一开始需要一两分钟初始化，初始化结束后可进入容器生成hexo静态网页
```bash
hexo clean # 清理，非必要
hexo g # 生成静态网页
hexo s # 本地网站4000端口预览
```
**2. 从本地恢复hexo网站**
```bash
docker run -d --name blog -p 4000:4000 -v $HOME/.gitconfig:/root/.gitconfig:ro -v $HOME/.ssh:/root/.ssh:ro -v 'hexo目录':/root/blog cyicz123/butterfly:4.4.0 --recovery .
```

**3. 从远程仓库恢复**
```bash
docker run -d --name blog -p 4000:4000 -v $HOME/.gitconfig:/root/.gitconfig:ro -v $HOME/.ssh:/root/.ssh:ro -v 'hexo目录':/root/blog cyicz123/butterfly:4.4.0 --recovery 仓库url
```
### 2.2 docker compose部署
可用如下`docker-compose.yml`模版
```YAML
version: '3.3'
services:
    butterfly:
        container_name: blog
        restart: unless-stopped
        volumes:
            - '~/.gitconfig:/root/.gitconfig:ro'
            - '~/.ssh:/root/.ssh:ro'
            - './blog_bak:/root/blog'
        ports:
            - '4000:4000'
        image: 'cyicz123/butterfly:4.4.0'
        command: 
            # 取消注释，选择对应的模式

            # blog_bak文件夹里已经存在hexo博客文件，直接恢复
            # - '--recovery'
            # - '.'

            # blog_bak文件夹为空，从url中拉取文件，然后恢复
            # - '--recovery'
            # - '个人仓库url'
            
            # blog_bak文件夹为空，新建一个hexo网站
            - '--init'
```
