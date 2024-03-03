package com.appSockets;

import java.io.IOException;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import com.appSockets.service.SocketServerService;

@SpringBootApplication
public class TrabajoSocketsApplication {

    public static void main(String[] args) {
        SpringApplication.run(TrabajoSocketsApplication.class, args);
    }

    @Bean
    public CommandLineRunner run() {
        return args -> {
            new Thread(() -> {
                try {
                    new SocketServerService().startServer();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }).start();
        };
    }
}