FROM	cyicz123/ohmyzsh:5.9
RUN	apt-get update && \
	apt-get install --no-install-recommends -y vim openssh-client curl && \
	curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
	apt-get install --no-install-recommends -y nodejs && \
	npm install cnpm -g --registry=https://registry.npm.taobao.org && \
	cnpm install -g hexo-cli && \
	apt-get purge -y curl && \
	apt-get autoclean -y && \
	rm -rf /var/lib/apt/lists/*
WORKDIR	/root/blog

