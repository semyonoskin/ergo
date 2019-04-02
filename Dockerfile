FROM openjdk:10-jre-slim as builder
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-transport-https apt-utils bc dirmngr gnupg && \
    echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 && \
    # seems that dash package upgrade is broken in Debian, so we hold it's version before update
    echo "dash hold" | dpkg --set-selections && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends sbt
COPY . /ergo
WORKDIR /ergo
RUN sbt reload clean assembly
RUN mv `find . -name ergo-assembly*.jar` /ergo.jar
CMD ["/usr/bin/java", "-jar", "/ergo.jar"]

FROM openjdk:10-jre-slim
LABEL maintainer="Andrey Andreev <andyceo@yandex.ru> (@andyceo)"
RUN adduser --disabled-password --home /var/lib/ergo --uid 9052 --gecos "ErgoPlatform" ergo && \
    install -m 0755 -o ergo -g ergo -d /var/cache/ergo /var/cache/ergo/data
COPY --from=builder /ergo.jar /var/lib/ergo/ergo.jar
USER ergo
EXPOSE 9007 9052
WORKDIR /var/cache/ergo
VOLUME ["/var/cache/ergo/data"]
ENV DATADIR=/var/cache/ergo/data
ENTRYPOINT ["/usr/bin/java", "-jar", "/var/lib/ergo/ergo.jar"]
CMD [""]
