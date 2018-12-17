FROM golang:alpine as base

RUN apk add -U --no-cache git
RUN go get github.com/ericchiang/pup

FROM node:10.5-alpine as node
# xml2json needs python and other shit
RUN apk add -U --no-cache python make --virtual build-dependencies build-base gcc 
RUN yarn global add ramda-cli html-table-cli@1.3.0 xml2json

FROM node:10.5-alpine
RUN apk add -U --no-cache curl bash python
COPY --from=node /usr/local/bin /usr/local/bin
COPY --from=node /usr/local/share/.config /usr/local/share/.config
COPY --from=node /usr/local/share/.cache /usr/local/share/.cache
COPY --from=base /go/bin/pup /bin/pup
RUN cd $HOME && yarn add he
ENV PATH="/home/root/.yarn/bin:$PATH"
WORKDIR app/
COPY run .
CMD ["./run"]
