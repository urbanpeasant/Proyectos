package com.appSockets.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.net.UnknownHostException;

public class SocketClienteService {
    public static void main(String[] args) {
        try (Socket socket = new Socket("localhost", 5000)) {
            PrintWriter writer = new PrintWriter(socket.getOutputStream(), true);
            BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            BufferedReader consoleReader = new BufferedReader(new InputStreamReader(System.in));

            String userInput;

            System.out.println("Cliente iniciado. Escribe un mensaje para enviar al servidor:");
            while (!(userInput = consoleReader.readLine()).equals("#0#")) {
                writer.println(userInput);

                String serverResponse = readServerResponse(reader);
                System.out.println("Respuesta del servidor:\n" + serverResponse);
            }

            
            writer.println(userInput); 
            String serverResponse = readServerResponse(reader);
            System.out.println("Respuesta del servidor:\n" + serverResponse);

        } catch (UnknownHostException ex) {
            System.out.println("Server not found: " + ex.getMessage());
        } catch (IOException ex) {
            System.out.println("I/O error: " + ex.getMessage());
        }
    }

    private static String readServerResponse(BufferedReader reader) throws IOException {
        StringBuilder serverResponse = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null && !line.isEmpty()) {
            serverResponse.append(line).append("\n");
        }
        return serverResponse.toString();
    }
}
