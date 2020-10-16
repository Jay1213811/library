# library
## 1 如何使用
下载library.sol文件
在你的solidity文件中添加。推荐使用solidity在线编辑器
[Remix-Ide](https://remix.ethereum.org/#optimize=false&evmVersion=null&version=soljson-v0.4.26+commit.4563c3fc.js&appVersion=0.7.7)
在自己的solidity中导入库文件
```bash
//导入库文件
import "./library.sol";
```
调用库文件中的结构体
引用
```bash
  Library.user_info private _user_info_daata;
  Library.admin_info private _user_info_daata;
```
或者

```bash
Using library for *
```

之后就可以调用方法了。调用时只需要
`Library.functionname(参数1，参数2）`即可

## 2包含的库函数及使用方法
**1.用户注册函数`RegisterUser(string,uint,uint) returns（bytes32）`**
传入参数分别为一个string类型的可以为用户名/其他。uint类型的可以为身份识别码等还有一个uint类型可以为时间戳。注册功能传入的为不可更改，不允许更改的信息。返回一个bytes32类型的加密哈希值。这个哈希值为用户登陆的凭证。因为solidity中library不允许使用状态变量，故这里无法使用mapping（bytes => struct）去通过这个哈希值映射去寻找结构体中的其他变量，只能用户在写函数时自己定义。
调用时只需要调用`Library.RegisterUser(string,uint,uint)`

**2.获取管理员做XX操作所需权限值：`Powe(uint[] power,uint num) returns(uint)`** 
传入参数为用户的操作码，操作码用数组保存，还要传入数组的长度num，返回一个uint类型的值即所需权限值。比如我们设定看用户名字为1，看电话号码为2，看信用卡积分为3.我们希望对方只能查看我们电话号码和名字即传入一个数组uint power=[1,2] num=2。然后会通过权限分配算法返回一个需要分配的权限值。
调用时只需要调用`Library.Power(power,num)`
**3.校验用户是否有进行XX操作的权限`IdentifyPermission（uint,uint) returns(bool)`**
传入两个参数，一个是用户拥有的权限值，一个是做xx操作需要的权限。通过与运算如果own&2**need==2**need 则证明拥有这个权限返回true 否则返回false。
调用时只需要`Library.IdentifyPermission(uint,uint)`
