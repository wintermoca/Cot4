<%@ Application Language="C#" %>
<%@ Import Namespace="System.IO" %>

<script runat="server">
    public int Counter
    {
        get
        {
            // Counter.txt ������ ������ ��θ� ��� ���� Server ��ü�� MapPath �޼��� ���
            string filePath = Server.MapPath(@"App_Data\Counter.txt");
            FileStream fs = new FileStream(filePath, FileMode.Open, FileAccess.Read,
                                                                FileShare.ReadWrite);
            StreamReader sr = new StreamReader(fs);
            string readString = sr.ReadLine();
            int counter = int.Parse(readString);

            sr.Close();
            fs.Close();

            return counter;
        }

        set
        {
            string filePath = Server.MapPath(@"App_Data\Counter.txt");
            FileStream fs = new FileStream(filePath, FileMode.Open, FileAccess.Write,
                                                                FileShare.ReadWrite);
            StreamWriter sw = new StreamWriter(fs);
            sw.Write(value.ToString());

            sw.Close();
            fs.Close();
        }
    }
    
    void Application_Start(object sender, EventArgs e) 
    {
        Application["counter"] = Counter;
        Application["activecounter"] = 0;
    }
    
    void Application_End(object sender, EventArgs e) 
    {
        //  ���� ���α׷��� ����� �� ����Ǵ� �ڵ��Դϴ�.

    }
        
    void Application_Error(object sender, EventArgs e) 
    { 
        // ó������ ���� ������ �߻��� �� ����Ǵ� �ڵ��Դϴ�.

    }

    void Session_Start(object sender, EventArgs e) 
    {
        Application.Lock();
        // �޸� ���� Application ���� ���� 1 ����
        Application["counter"] = 1 + (int)Application["counter"];
        // �Ӽ��� set �޼��� ȣ��
        Counter = (int)Application["counter"];
        
        Application["activecounter"] = 1 + (int)Application["activecounter"];
        Application.UnLock();

    }

    void Session_End(object sender, EventArgs e) 
    {
        Application.Lock();
        Application["activecounter"] = (int)Application["activecounter"] - 1;
        Application.UnLock();
    }
       
</script>
