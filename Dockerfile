FROM	cyicz123/ohmyzsh:5.9
RUN	apt-get update && \
	apt-get install --no-install-recommends -y vim nodejs npm && \
	rm -rf /var/lib/apt/lists/*
RUN	npm config set registry http://registry.npm.taobao.org && \
	npm install -g hexo-cli
WORKDIR	/root/blog

