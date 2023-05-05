# 1、拉取node镜像来打包koa项目 #

## https://hub.docker.com/_/node
## 使用官方 Node.js 16 轻量级镜像.
FROM node:16-alpine

RUN mkdir -p /usr/src/app

## 定义工作目录
WORKDIR /usr/src/app

## Copy application dependency manifests to the container image.
## A wildcard is used to ensure both package.json AND package-lock.json are copied.
## Copying this separately prevents re-running npm install on every code change.
# 复制 package.json 和 package-lock.json 文件
COPY package*.json index.html webpack.config.js src/index.js /usr/src/app/

## 删除依赖
RUN rm -rf node_modules

## 安装pnpm
## RUN npm i -g cnpm --registry=https://registry.npm.taobao.org

## Install dependencies.
RUN npm install

## Env
ENV NODE_ENV=production
ENV HOST 0.0.0.0

RUN ls -a

## 打包
RUN npm run build

## 打包结果
RUN ls -a

## 删除依赖
# RUN rm -rf node_modules

## Copy local code to the container image.
## 将本地代码复制到工作目录内
COPY . /usr/src/app/

## 设置node的时区了 可能时间较长，耐心等待
# RUN apk update && apk add bash tzdata \ && cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

## 将3000端口暴露出来
EXPOSE 3000

## 2、Run the web service on container startup.
## 启动服务
CMD ["npm", "run", "server"]
