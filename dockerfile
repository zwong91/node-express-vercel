FROM node:20

# Security: Drop all capabilities
USER root
RUN apt-get update && apt-get install -y libcap2-bin
RUN setcap cap_net_bind_service=+ep /usr/local/bin/node

WORKDIR /code

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

# Security: Create non-root user and assign ownership
RUN useradd -m appuser
RUN mkdir projects && chown -R appuser:appuser projects
USER appuser

# todo user namespace mapping

EXPOSE 5173
EXPOSE 4000

CMD [ "node", "dist/index.js" ]