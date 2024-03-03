package com.appSockets.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.Scanner;

public class SocketClienteMultiple implements Runnable {
    private final String clientId;
    private final Socket socket;
    private PrintWriter writer;
    private BufferedReader reader;

    public SocketClienteMultiple(String clientId, Socket socket) {
        this.clientId = clientId;
        this.socket = socket;
    }

    @Override
    public void run() {
        try {
            this.writer = new PrintWriter(socket.getOutputStream(), true);
            this.reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        } catch (IOException e) {
            System.out.println(clientId + " - Ha pasado algo que no he tenido en cuenta así que espero que no leas esto.");
            return;
        }

        System.out.println(clientId + " iniciado.");
    }

    public void sendMessage(String message) throws IOException {
        writer.println(message);
        System.out.println(clientId + " envió: " + message);

        String serverResponse = readServerResponse();
        System.out.println(clientId + " - Respuesta del servidor:\n" + serverResponse);
    }

    private String readServerResponse() throws IOException {
        StringBuilder serverResponse = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null && !line.isEmpty()) {
            serverResponse.append(line).append("\n");
        }
        return serverResponse.toString();
    }

    public static void main(String[] args) throws IOException {
        Socket socket1 = new Socket("localhost", 5000);
        Socket socket2 = new Socket("localhost", 5000);

        SocketClienteMultiple cliente1 = new SocketClienteMultiple("Cliente 1", socket1);
        SocketClienteMultiple cliente2 = new SocketClienteMultiple("Cliente 2", socket2);

        new Thread(cliente1).start();
        new Thread(cliente2).start();

        Scanner scanner = new Scanner(System.in);

        while (true) {
            System.out.println("Escribe un mensaje para Cliente 1:");
            String mensaje1 = scanner.nextLine();
            cliente1.sendMessage(mensaje1);

            if (mensaje1.equals("#0#")) {
                break;
            }

            System.out.println("Escribe un mensaje para Cliente 2:");
            String mensaje2 = scanner.nextLine();
            cliente2.sendMessage(mensaje2);

            if (mensaje2.equals("#0#")) {
                break;
            }
        }

        scanner.close();
        socket1.close();
        socket2.close();
    }
}
