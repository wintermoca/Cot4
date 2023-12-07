using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Cot4
{
    public partial class Left : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }
        protected void btnSubscribe_Click(object sender, EventArgs e)
        {
            // 메시지를 위한 변수
            string Message = "";
            string connectionString =
            WebConfigurationManager.ConnectionStrings["ASPNET"].ConnectionString;
            SqlConnection conn = new SqlConnection(connectionString);
            try
            {
                // 1. 이미 가입되어 있는지를 확인
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandText =
                "SELECT * FROM mailing_list WHERE email_address='" + txtEmailAddress.Text + "'";
                conn.Open();
                SqlDataReader rd = cmd.ExecuteReader();
                bool hasSubscribed = rd.Read();
                rd.Close();
                // 이미 가입되어 있을 경우 Exception을 발생시켜 catch 문으로 이동
                if (hasSubscribed)
                    throw new System.InvalidOperationException("이미 가입된 이메일 주소입니다.");

                // 2. 가입되어 있지 않을 경우 메일링 리스트에 등록
                string insertSQL = "INSERT INTO mailing_list(email_address, reg_date) ";
                insertSQL += "VALUES(@emailAddr,GETDATE())";
                cmd = new SqlCommand(insertSQL, conn);

                cmd.Parameters.AddWithValue("@emailAddr", txtEmailAddress.Text);
                cmd.ExecuteNonQuery();
                Message = @"성공적으로 가입되었습니다.\n메일링 리스트에 가입해주셔서 감사합니다.";
            }
            catch (Exception error)
            {
                Message = error.Message.Replace("'", "");
            }
            finally
            {
                conn.Close();
                txtEmailAddress.Text = "";
                Response.Write("<script language='javascript'>");
                Response.Write("alert('" + Message + "');");
                Response.Write("</script>");
            }
        }

        protected void btnUnsubscribe_Click(object sender, EventArgs e)
        {
            // 메시지를 위한 변수
            string Message = "";
            string connectionString =
            WebConfigurationManager.ConnectionStrings["ASPNET"].ConnectionString;
            SqlConnection conn = new SqlConnection(connectionString);
            try
            {
                // 1. 가입된 사용자인지를 확인
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;
                cmd.CommandText =
                "SELECT * FROM mailing_list WHERE email_address='" + txtEmailAddress.Text + "'";
                conn.Open();
                SqlDataReader rd = cmd.ExecuteReader();
                bool hasSubscribed = rd.Read();
                rd.Close();
                // 가입된 사용자가 아닐 경우 Exception을 발생시켜 catch 문으로 이동
                if (!hasSubscribed)
                    throw new System.InvalidOperationException("가입된 이메일 주소가 아닙니다.");

                // 2. 가입된 이메일 주소인 경우 삭제
                string insertSQL = "DELETE FROM mailing_list WHERE email_address = @emailAddr ";
                cmd = new SqlCommand(insertSQL, conn);

                cmd.Parameters.AddWithValue("@emailAddr", txtEmailAddress.Text);
                cmd.ExecuteNonQuery();
                Message = @"성공적으로 탈퇴되었습니다.\n그동안 메일링 리스트를 이용해주셔서 감사합니다.";
            }
            catch (Exception error)
            {
                Message = error.Message.Replace("'", "");
            }
            finally
            {
                conn.Close();
                txtEmailAddress.Text = "";
                Response.Write("<script language='javascript'>");
                Response.Write("alert('" + Message + "');");
                Response.Write("</script>");
            }

        }

    }
}