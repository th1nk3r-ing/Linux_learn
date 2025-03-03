# FROM jekyll/jekyll
# ADD Gemfile /srv/jekyll
# RUN ["bundle", "install"]

# 使用官方 Jekyll Pages 镜像作为基础镜像
FROM jekyll/jekyll:pages

# 设置工作目录为 /srv/jekyll
WORKDIR /srv/jekyll


# 更新包管理器并安装必要的依赖
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk update && \
    apk add --no-cache \
    build-base \
    ruby-dev \
    tree \
    vim

# 安装 webrick gem
RUN gem install webrick

# 复制当前目录内容到容器的工作目录
COPY . .

# 暴露 Jekyll 服务器默认端口
EXPOSE 4000

# 启动 Jekyll 服务
CMD ["jekyll", "serve", "--watch", "--drafts", "--future", "--host", "0.0.0.0", "--port", "4000"]


#docker build -t my-github-pages .
