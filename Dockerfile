FROM golang:1.15-alpine3.12 AS gobuilder-stage

MAINTAINER thsohn <rdfs.kr@gmail.com>
LABEL "purpose"="Service Deployment using multi stage builds."

# /usr/src/goapp ㄱㅕㅇ로로 이동한다. 
WORKDIR /usr/src/goapp

#현재 디렉터리의 goapp.go 파일을 이미지 내부으 ㅣ현재 경로에 복사한다. 
COPY goapp.go .

#GO 환경변수 지정, /usr/local/bin 경로에 gostart 실행 파일을 생성 
#CGO_ENABLED=0 cgo 비활성화,
#GOOS=linux GOARCH=amd64 : 
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /usr/local/bin/gostart

# 두번쨰 단계 두번째 Dockerfile을 작성한 것고 ㅏ같음. 베이스 이미지를 작성 
# 마지막은 컨테이너로 실행되는 단계이므로 일반적으로 단계명을 명시하지 않는다. 
FROM scratch AS runtime-stage 

#첫 번째 단계의 이름을 --from 옵션에 넣으면 해당 단계로부터 파일을 가져와서 복사한다. 
COPY --from=gobuilder-stage /usr/local/bin/gostart /usr/local/bin/gostart

#3컨테이너 실행 시 파일을 실행한다. 
CMD ["/usr/local/bin/gostart"]
