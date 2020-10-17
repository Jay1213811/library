pragma solidity >=0.4.22 <0.6.0;
import "./library.sol";
contract Comment{
       using Library for *;
      struct user_info{
          bool login_permission;
          string name;
          uint password;
          uint points;
         address user_address;//注册用户地址
         uint time;//timestamp   时间戳自动生成，防止伪造
      }
    mapping(bytes32 => user_info) public user_dic;
    Library.user_info private userself;
    function register(string _name,uint _password) public returns(bytes32 user_secretkey){
        uint time=block.timestamp;
            user_secretkey=Library.RegisterUser(userself,_name,_password,msg.sender,time);
           user_dic[user_secretkey]=user_info(true,_name,_password,100,msg.sender,time);
    }
    string[] goodwords=["thanks","good","sorry","hello"];
    string[] badwords=["fuck","sb","cc","dd"];
    function talk(bytes32 user_secretkey,string information)public returns(string,uint){
        require(Library.IdentifyUser(userself,user_secretkey),"You have not regist");
        if(user_dic[user_secretkey].points<20){
            user_dic[user_secretkey].login_permission=false;
            revert("您信用分已经低于20，已经被封禁");
        }
        
        for(uint i=0;i<goodwords.length;i++)
        {
           if (bytes(information).length != bytes(goodwords[i]).length) {
                continue;
           }
          else
            if(keccak256(abi.encode(information)) == keccak256(abi.encode(goodwords[i]))){
                user_dic[user_secretkey].points+=10;
                 return("感谢您的文明发言，作为奖励，您的信用积分将加十分，再接再厉.您目前信用积分为：",user_dic[user_secretkey].points);
            }
            else{
               continue;
            }
             
        }
        for(uint k=0;k<badwords.length;k++)
        {
            
             if (bytes(information).length != bytes(badwords[k]).length) {
                    continue;
             }
            else{
                if(keccak256(abi.encode(information)) == keccak256(abi.encode(badwords[k]))){
                     user_dic[user_secretkey].points-=10;
                        return("由于你的不文明发言你的信用积分将被扣十分，如果分数低于20分，你将无法再登陆系统",user_dic[user_secretkey].points);
                }
                else{
                     continue;
                }
            }
        }
    } 
    
}