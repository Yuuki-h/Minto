package org.kdk.yuuki.yuukidb.servlet;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name="ListServlet",urlPatterns={"/list"})
public class ListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
    	String fowrad = "login.jsp";

    	RequestDispatcher dispatcher = req.getRequestDispatcher(fowrad);
    	dispatcher.forward(req, resp);
    }
}
