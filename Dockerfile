FROM ubuntu:18.04
RUN apt -y update && \
    apt -y upgrade && \
    apt -y install git && \
    apt -y install cmake && \
    apt -y install libssl-dev && \
    apt -y install g++ && \
    apt -y install zlib1g-dev && \
    apt -y install wget && \
    apt -y install python3 && \
    apt -y install python3-pip
RUN git clone https://github.com/ton-blockchain/ton/ && \
    cd ./ton  && \
    git submodule update --init --recursive && \
    cd .. && \
    mkdir liteclient-build && \
    cd liteclient-build && \
    cmake ../ton -DCMAKE_BUILD_TYPE=Release && \
    cmake --build . --target lite-client && \
    cmake --build . --target fift && \
    cmake --build . --target func && \
    wget https://test.ton.org/ton-lite-client-test1.config.json
EXPOSE 8080
RUN pip3 install web.py==0.40
COPY . /astonished
WORKDIR /astonished
CMD python3 main.py 8080 "/liteclient-build/lite-client/lite-client -C /liteclient-build/ton-lite-client-test1.config.json" "/liteclient-build/crypto/fift -I/ton/crypto/fift/lib/ -i" "0QAESRAUnb6vjq27KyhyLn1qLcbiZOwvHZvr1vsgkHm8Ksyd"