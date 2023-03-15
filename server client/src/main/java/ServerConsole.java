import client.ChatClient;
import common.ChatIF;
import java.io.*;
import client.*;
import common.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class ServerConsole implements ChatIF {

    final public static int DEFAULT_PORT = 4444;

    ChatClient server;
    EchoServer server1;

    public ServerConsole(String host, int port)
    {
        try
        {
            server= new ChatClient(host, port, this);
        }
        catch(IOException exception)
        {
            System.out.println("Error: Can't setup connection!"
                    + " Terminating client.");
            System.exit(1);
        }
    }

    public EchoServer getServer(){
        return server1;
    }

    public void accept()
    {
        try
        {
            BufferedReader fromConsole =
                    new BufferedReader(new InputStreamReader(System.in));
            String message;

            while (true) {
                message = fromConsole.readLine();

                server.handleMessageFromClientUI(message);
            }
        }
        catch (Exception ex)
        {
            System.out.println
                    ("Unexpected error while reading from console!");
        }
    }

    @Override
    public void display(String message) {
        System.out.println("SERVER MSG> " + message);
    }

}
