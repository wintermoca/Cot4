<%@ Application Language="C#" %>
<%@ Import Namespace="System.IO" %>

<script runat="server">
    public int Counter
    {
        get
        {
            // Counter.txt 파일의 물리적 경로를 얻기 위해 Server 객체의 MapPath 메서드 사용
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
        //  응용 프로그램이 종료될 때 실행되는 코드입니다.

    }
        
    void Application_Error(object sender, EventArgs e) 
    { 
        // 처리되지 않은 오류가 발생할 때 실행되는 코드입니다.

    }

    void Session_Start(object sender, EventArgs e) 
    {
        Application.Lock();
        // 메모리 상의 Application 변수 값을 1 증가
        Application["counter"] = 1 + (int)Application["counter"];
        // 속성의 set 메서드 호출
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
