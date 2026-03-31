FROM debian:bookworm as build 
RUN apt update && apt install build-essential clang -y

COPY . /agnes
WORKDIR /agnes/fuzz
RUN make

FROM debian:bookworm
COPY --from=build /agnes/fuzz .