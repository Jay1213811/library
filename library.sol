pragma solidity ^0.4.26;
// This library has the state variables 'contractAddress' and 'name'
library Library {
     struct user_info
    {
        bool identify;
        string Name;//用户名
        uint userpassword;
        address useraddress;//注册用户地址
        uint points;//信用积分
        uint time;//timestamp   时间戳自动生成，防止伪造
  
    }
     struct admin_info
{
    bool identify;
    string admin_name;
    uint adminpassword;
    address adminaddress;
    uint purview;
    mapping(bytes32 => address)admin;
}
  function RegisterUser(string memory _Name,uint _Password,uint time)public  returns(bytes32 _user_secrctkey){
       _user_secrctkey = sha256(abi.encode(_Name,_Password,block.timestamp));
         return (_user_secrctkey);
     }
     //计算该系统进行XX操作需要的权限值
  function RegisterAdmin(string _admin_name,uint _adminpassword)public view returns(bytes32 _admin_secretkey){
      _admin_secretkey=sha256(abi.encode(_admin_name,msg.sender));
  }

    function Power(uint[]power,uint num) public pure returns(uint purview){
              for(uint i=0;i<num;i++){
             purview=purview+2**power[i];
         }
        return purview;//用户的权限值
     }
  //授予权限函数：传入自身（便于外部函数调用） 映射的内容，管理员的地址，传入授予的权限值

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

