package org.kdk.yuuki.yuukidb.servlet;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.kdk.yuuki.yuukidb.entity.UserListDao;
import org.kdk.yuuki.yuukidb.entity.UserListEntity;

import atmarkit.MyDBAccess;

@WebServlet(name="DeleteServlet",urlPatterns={"/delete"})
public class DeleteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
    	String fowrad = "index.jsp";

    	req.setCharacterEncoding("UTF-8");
		try {
			MyDBAccess db = new MyDBAccess();

			db.open();

			String id_select = req.getParameter("name_select");
			int id = Integer.parseInt(id_select);

			UserListEntity entity = new UserListEntity();

			entity.setUserId(id); // IDを取得

			UserListDao.delete(db, entity);

    	RequestDispatcher dispatcher = req.getRequestDispatcher(fowrad);
    	dispatcher.forward(req, resp);
		} catch (Exception e) {
			throw new ServletException(e);
		}
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
    	doGet(req, resp);
    }
}
