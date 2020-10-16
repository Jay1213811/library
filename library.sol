pragma solidity ^0.4.26;
// This library has the state variables 'contractAddress' and 'name'
library Library {
     struct user_info
    {

        string user_name;//用户名
        uint user_password;//用户密码 后面其他项目调用时这里可以填某些不允许篡改的值，比如居民身份证号/证书编号等
        address user_address;//注册用户地址
        uint user_points;//信用积分
        uint time;//timestamp   时间戳自动生成，防止伪造
        mapping(bytes32 => bool) user_identify;//用户是否注册 这里设置这样的一个bool值的好处就是删除用户直接把这个设置为false即可，查看用户是否存在也只需要get这个值即可
    }
     struct admin_info
{

    string admin_name;//管理名，也可以理解为管理部门部门名
    uint admin_password;//管理员密码
    address admin_address;//管理员地址
    mapping(address => uint)admin_purview;//这里设置这样一个mapping的意义在于，后面我们通过管理员的地址去get他的权限。便于后续做权限分配以及按需公开数据
    uint time;//timestamp   时间戳自动生成，防止伪造
    mapping(bytes32 => bool) admin_identify;
}
//用户注册函数:1用户注册的时候拿用户名，注册地址，密码，时间戳时间去做一个sha256处理，得到一个哈希值，用这个值做登陆凭证
  function RegisterUser(user_info storage self,string memory _username,uint _userpassword,address _useraddress,uint time)public  returns(bytes32 _user_secrctkey){
      time=block.timestamp;
      _user_secrctkey = sha256(abi.encode(_username,_userpassword,msg.sender,block.timestamp));
         self.user_identify[_user_secrctkey]=true;//将该密钥对应的注册状态改为true
         return (_user_secrctkey);
     }
//用户登陆函数
 function Userlogin(user_info storage self,bytes32 _user_secrctkey) public returns(string){
     if(self.user_identify[_user_secrctkey])
     return "Welcome login";
 }
     //管理员注册函数
  function RegisterAdmin(string _admin_name,uint _adminpassword)public view returns(bytes32 _admin_secretkey){
      _admin_secretkey=sha256(abi.encode(_admin_name,msg.sender));
  }
  // //计算该系统进行XX操作需要的权限值
    function Power(uint[]power,uint num) public pure returns(uint purview){
              for(uint i=0;i<num;i++){
             purview=purview+2**power[i];
         }
        return purview;//用户的权限值
     }
  //授予权限函数：传入自身（便于外部函数调用） 映射的内容，管理员的地址，传入授予的权限值
   function Authorization(admin_info storage self,address _AdminAddress,uint value) public  returns (bool)
    {
        require(value > 0);
        self.admin_purview[_AdminAddress] = value;
        return true;
    }
    //查看XX拥有的权限值，返回该值
   function ViewPermission(admin_info storage self, address _AdminAddress) public view returns (uint) {
        return self.admin_purview[_AdminAddress];
    }
    //权限验证
    function IdentifyPermission(uint _own,uint _need) public pure returns(bool){
        if((_own&2**_need)==2**_need)
        {
            return true;
        }
        else{
            return false;
        }
    }
}
