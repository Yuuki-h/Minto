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

@WebServlet(name="InsertServlet",urlPatterns={"/insert"})
public class InsertServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
    	String fowrad = "index.jsp";

    	req.setCharacterEncoding("UTF-8");
		try {
			MyDBAccess db = new MyDBAccess();

			db.open();

	    	int id = UserListDao.getMaxId(db);

			String UserName = req.getParameter("dia_name_add");
			String UserPass = req.getParameter("dia_pass_add");
			String DispName = req.getParameter("dia_disp_add");

			UserListEntity entity = new UserListEntity();

			entity.setUserId(id + 1); // IDを取得
			entity.setUserName(UserName); // ユーザー名を取得
			entity.setUserPass(UserPass); // パスワードを取得
			entity.setDispName(DispName); // 表示名を取得

			UserListDao.insert(db, entity);


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
