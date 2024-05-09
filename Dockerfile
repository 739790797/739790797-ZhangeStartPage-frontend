# 基于 Node.js 镜像构建
FROM node:14.17.0 AS build

# 设置工作目录
WORKDIR /app

# 将 package.json 和 package-lock.json 复制到工作目录
COPY package*.json ./

# 安装依赖
RUN npm install

# 将应用程序复制到工作目录
COPY . .

# 构建应用程序
RUN npm run build

# 使用 Nginx 镜像构建
FROM nginx:1.19.10

# 将 Nginx 配置文件复制到容器中
COPY nginx.conf /etc/nginx/nginx.conf

# 将应用程序复制到 Nginx 默认站点目录
COPY --from=build /app/build /usr/share/nginx/html

# 暴露 80 端口
EXPOSE 80

# 启动 Nginx 服务器
CMD ["nginx", "-g", "daemon off;"]
