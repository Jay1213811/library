pragma solidity >=0.4.26;
import "./library.sol";
//权限分配及权限验证采用的是权限管理控制算法
contract BankMangement{
     using Library for *;
     Library.admin_info admin_self;
     Library.user_info user_self;
    struct user_info{
        string username;//客户名字
        uint  bankcardnumber;//银行卡号
        address user_address;//用户注册地址
        uint   credit_card_points;//信用卡积分
        uint   phonenumber;//电话号码
        string Education_information;//教育信息
        string  Work_informatin;//工作信息
        uint time;//时间戳
    }
    mapping(bytes32 => user_info) public user_dic;
    //默认这个系统为中国建设银行使用，先把值写死了。传入自身，银行名，银行内部秘密，工作人员地址，时间戳
    function RegisterAdmin() public returns(bytes32){
      return  Library.RegisterAdmin(admin_self,"中国建设银行",123,msg.sender,block.timestamp);
    }
    //用户注册函数
    function Registeruser(string _username,uint _bankcardnumber,uint _phonenumber,string _Education_information,string _Work_information) public returns(bytes32 _usersecretkey){
        _usersecretkey=Library.RegisterUser(user_self,_username,_bankcardnumber,msg.sender,block.timestamp);
       user_dic[_usersecretkey]=user_info(_username,_bankcardnumber,msg.sender,0,_phonenumber,_Education_information,_Work_information,block.timestamp);
        return _usersecretkey;
    }
    //我们这里对系统操作权限设立一个数据字典 。默认银行应该有的权限为[0,2,3,4] 
    //查看用户名字-----0
    //查看教育信息，工作信息-----1
    //查看用户注册地址------2
    //查看信用卡积分，电话号码，时间戳----3
    //修改信用卡积分4
    uint[] power=[0,2,3,4];
    uint powernum;
    //查看该银行需要的权限值
    function getneedpower()public returns(string,uint _powernum)
    {
        _powernum=Library.Power(power,power.length);//调用库函数中求所需权限值函数
        powernum=_powernum;
        return("该系统需要的权限值 为",_powernum);
    }
    //用户授权函数：如果用户通用授予之前查看到的该系统需要的power值，就签署自己的密钥，默认授权，将该权限值与用户地址以键值对的形式存储起来。
    function revoke(bytes32 _usersecretkey,address _Adminaddress)public returns(bool){
        require(user_dic[_usersecretkey].user_address==msg.sender,"user error:当前登陆地址不是该用户的地址");
        return Library.Authorization(admin_self,_Adminaddress,powernum);//调用库函数中授权函数
        
    }
  //银行修改用户信用卡积分函数
    function changepoints(address _Adminaddress,bytes32 _usersecretkey, uint _points) public returns(string){
        //调用库函数，查看该管理员拥有的权限值
        uint own_power=Library.ViewPermission(admin_self,_Adminaddress);
        uint need=4;
        //调用库函数，查看该管理员是否拥有进行这个操作的权限
        if(Library.IdentifyPermission(own_power,need)==true)
            user_dic[_usersecretkey].credit_card_points=_points;
        return("修改信用卡积分成功！");
    }


    
}