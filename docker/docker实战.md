# <font color=#0099ff> **docker 实战** </font>

## <font color=#009A000> 0x00 docker github-pages 本地构建预览 </font>

- [使用Jekyll的docker在本地部署GitHub Pages](https://rz1970.github.io/2018/12/06/deploy-github-pages-locally.html)
- [Building GitHub Pages using Docker](https://avcu.github.io/programming/building-github-pages-using-docker/)
- <https://github.com/soulteary/docker-quick-docs>
- <https://github.com/github/pages-gem>
- <https://github.com/Starefossen/docker-github-pages>

```sh
#镜像构建
docker build -t my-github-pages .

# github-pages 本地预览
docker run \
  --rm \
  --name jekyll \
  -e PAGES_REPO_NWO=th1nk3r-ing/Linux_learn \
  -e JEKYLL_THEME=my-hacker \
  -e JEKYLL_ENV=development \
  -p 4000:4000 \
  -v "./:/srv/jekyll" \
  --tty \
  my-github-pages \
  jekyll serve --watch --force_polling --host 0.0.0.0 --config _config.yml
```

## <font color=#009A000> 0x01 [my-ubuntu-dockerfile](../config/Dockerfile) </font>
