#!/bin/bash
set -e

if [ -z "$WORKDIR" ]
then
    echo "WORKDIR set /root/blog"
    WORKDIR="/root/blog"
fi

helpInfo(){
    echo  "\nButterfly - A beautiful hexo theme."
    echo  "Theme Gihub url: https://github.com/jerryc127/hexo-theme-butterfly"
    echo  "\n"
    echo  'Usage: docker run -d -v $HOME/.ssh:/root/.ssh:ro -v $HOME/.gitconfig:/root/.gitconfig:ro cyicz123/butterfly:[TAG] [COMMAND]'
    echo  "\n"
    echo  "Commands:"
    echo  "       -i, --init \t\t Init a blog which theme is butterfly."
    echo  "       -r, --recovery [URL] \t Recovery from /root/blog. If [URL] is set, it will recovery after git clone [URL]."
    echo  "       -h, --help \t\t Print the help info."
}

genGitIgnore(){
    echo '/node_modules' > .gitignore
    echo '/themes' >> .gitignore
    echo '/public' >> .gitignore
    echo '/.github' >> .gitignore
    echo 'db.json' >> .gitignore
}

initBlog(){
    echo "cd ${WORKDIR}"
    cd ${WORKDIR}

    echo "rm -rf ${WORKDIR}"
    rm -rf *

    echo "hexo init"
    hexo init .
    echo "git init"
    git init .
    echo "Generate .gitignore"
    genGitIgnore
    cnpm install hexo-theme-butterfly hexo-renderer-pug hexo-renderer-stylus hexo-wordcount --save
    cp node_modules/hexo-theme-butterfly/_config.yml _config.butterfly.yml
    sed -i 's/^theme: .*/theme: butterfly/g' _config.yml
    echo "Init blog successful!"
}

recoveryBlog(){
    echo "cd ${WORKDIR}"
    cd ${WORKDIR}

    if [ "$1" != '.' ]
    then
    	echo "rm -rf ${WORKDIR}"
    	rm -rf *
	echo "git clone $1 ."
        git clone $1 .
    fi
    cnpm install
}

#-o或--options选项后面接可接受的短选项，如ab:c::，表示可接受的短选项为-a -b -c，其中-a选项不接参数，-b选项后必须接参数，-c选项的参数为可选的
#-l或--long选项后面接可接受的长选项，用逗号分开，冒号的意义同短选项。
#-n选项后接选项解析错误时提示的脚本名字
ARGS=`getopt -o ir:h --long init,recovery:,help -n "$0" -- "$@"`
if [ $? != 0 ]; then
    helpInfo
    exit 1
fi

#将规范化后的命令行参数分配至位置参数（$1,$2,...)
eval set -- "${ARGS}"
echo alias npm='cnpm' >> /root/.zshrc

while true
do
    case "$1" in
        -i|--init) 
            initBlog
            shift
            ;;
        -h|--help)
            helpInfo
            shift 
            ;;
        -r|--recovery)
            recoveryBlog $2
            shift 2  
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Internal error!"
            exit 1
            ;;
    esac
done

while true
do
    sleep 1000
done
