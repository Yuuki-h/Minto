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

@WebServlet(name="UpdateServlet",urlPatterns={"/update"})
public class UpdateServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
    	String fowrad = "index.jsp";

    	req.setCharacterEncoding("UTF-8");

		try {
			MyDBAccess db = new MyDBAccess();

			db.open();

			String id_select = req.getParameter("dia_id_2");

			int id = Integer.parseInt(id_select);

			String UserName = req.getParameter("dia_name_change");
			String UserPass = req.getParameter("dia_pass_change");
			String DispName = req.getParameter("dia_disp_change");

			UserListEntity entity = new UserListEntity();

			entity.setUserId(id); // IDを取得
			entity.setUserName(UserName); // ユーザー名を取得
			entity.setUserPass(UserPass); // パスワードを取得
			entity.setDispName(DispName); // 表示名を取得

			UserListDao.update(db, entity);


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


