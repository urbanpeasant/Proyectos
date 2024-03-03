package com.appSockets.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Base64;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

public class SocketServerService {
    private ConcurrentHashMap<String, ManejaCliente> sessionMap = new ConcurrentHashMap<>();

    public void startServer() throws IOException {
        try (ServerSocket serverSocket = new ServerSocket(5000)) {
			System.out.println("Servidor iniciado. Esperando clientes...");

			while (true) {
			    Socket socket = serverSocket.accept();
			    ManejaCliente manejaCliente = new ManejaCliente(socket);
			    sessionMap.put(manejaCliente.getSessionId(), manejaCliente);
			    manejaCliente.start();
			}
		}
    }

    private class ManejaCliente extends Thread {
        private final Socket socket;
        private final String idSesion;

        public ManejaCliente(Socket socket) {
            this.socket = socket;
            this.idSesion = UUID.randomUUID().toString();
        }

        public String getSessionId() {
            return idSesion;
        }

        @Override
        public void run() {
            try {
                InputStream input = socket.getInputStream();
                BufferedReader reader = new BufferedReader(new InputStreamReader(input));
                OutputStream output = socket.getOutputStream();
                PrintWriter writer = new PrintWriter(output, true);

                String mensajeCliente;
                boolean conexionAbierta = true;

                while (conexionAbierta && (mensajeCliente = reader.readLine()) != null) {
                    String response = processMessage(mensajeCliente);
                    writer.println("ID de la sesión: " + idSesion + "\n" + response);
                    writer.println(); 

                    if (mensajeCliente.equals("#0#")) {
                        conexionAbierta = false;
                    }
                }

                
                sessionMap.remove(idSesion);
                socket.close();
            } catch (IOException ex) {
                System.out.println("Server exception: " + ex.getMessage());
                ex.printStackTrace();
            }
        }

        private String processMessage(String mensaje) {
            if (mensaje.startsWith("#1#")) {
                return encodeMessage(mensaje.substring(3));
            } else if (mensaje.startsWith("#2#")) {
                return decodeMessage(mensaje.substring(3));
            } else if (mensaje.equals("#0#")) {
                return "#0# Fin de la conexión.";
            } else {
                return "Mensaje enviado: " + mensaje + "\nMensaje recibido: #99# El mensaje no está formateado para su tratamiento.";
            }
        }

        private String encodeMessage(String mensaje) {
            String codificaTexto = Base64.getEncoder().encodeToString(mensaje.getBytes());
            return "Mensaje enviado: #" + mensaje + "\nMensaje recibido: #1#" + codificaTexto;
        }

        private String decodeMessage(String mensaje) {
            String descodificaTexto = new String(Base64.getDecoder().decode(mensaje));
            return "Mensaje enviado: #" + mensaje + "\nMensaje recibido: #2#" + descodificaTexto;
        }
    }
}
