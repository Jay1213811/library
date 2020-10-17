
# library
Introduction：
在我们编写solidity中，会发现，有许多合约它们有一些共同代码，比如大多数管理系统都需要用到登陆注册，权限分配等业务。我们应该如何更好的集成这些函数，便于我们以后直接调用而不需要去重写方法。
最初我采用的是把需要用到的方法全写入一个合约中，再在新的合约中import导入去调用。这种方法极其不便而且在我们部署到链上后这两个合约是没有联系的。
查阅资料后发现solidity中有library库合约调用，为此我编写了一个library库，去调用这些通用模块。通过把共同代码部署成一个库。这将节省gas，因为gas也依赖于合约的规模。因此，可以把库想象成使用其合约的父合约。使用父合约（而非库）切分共同代码不会节省gas，因为在Solidity中，继承通过复制代码工作。库可用于给数据类型添加成员函数.
由于库被当作隐式的父合约（不过它们不会显式的出现在继承关系中，但调用库函数和调用父合约的方式是非常类似的，如库L有函数f()，使用L.f()即可访问）。库里面的内部（internal）函数被复制给使用它的合约；
同样按调用内部函数的调用方式，这意味着所有内部类型可以传进去，memory类型则通过引用传递，而不是拷贝的方式。 同样库里面的结构体structs和枚举enums也会被复制给使用它的合约。
因此，如果一个库里只包含内部函数或结构体或枚举，则不需要部署库，因为库里面的所有内容都被复制给使用它的合约。

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
引入library。关于using语法在picture中有图片说明
```bash
Using library for *
```

之后就可以调用方法了。调用时只需要
`Library.functionname(参数1，参数2...参数n）`即可

## 2包含的库函数及使用方法
首先我们大致介绍一下库函数包含的。它有一个用户的结构体和管理员的结构体定义。
用户的结构体中包含用户名，密码，用户地址，时间戳。等常规信息。由于library不允许出现全局变量，为此我们在用户结构体中设置了一个mapping变量，由用户加密后的哈希值和用户注册状态做键值对配对，用户注册后将该值改为true。用户登陆时只需要验证这个即可，注销用户将该值改为false就行了。

管理员中除了用户拥有的信息，还加了一个mapping映射，由管理员的地址映射管理员拥有的权限值。有了这个可以方便我们做权限分配和按需公开信息。

这里需要特别指出，你需要调用到结构体中的mapping变量，你需要传入自身。（类似于java中的self）主要规则是，如用户注册的时候我们在库函数中用到了mapping（bytes32=>bool），库函数中我们已经传入了自身便于外部函数调用。在调用时，在你的合约中，只要先定义一句 'Library.user_info private _userData;'.即可，user_info是库函数中用户结构体名称，后面是我们为这个的命名，这个名称可以修改。
之后我们注册调用时只需要
Library.RegisterUser(_userData,string,uint,uint)；多传一个参数即它自身即可。
管理员注册权限分配也是如此，这里就不再赘述。

用户注册函数 RegisterUser(self,string,uint,address,uint) returns(bytes32)

传入参数分别为用户自身，方便外部函数去调用。一个string类型的可以为用户名/其他。uint类型的可以为身份识别码，注册用户的地址，还有一个uint类型可以为时间戳。注册功能传入的为不可更改，不允许更改的信息。返回一个bytes32类型的加密哈希值。这个哈希值为用户登陆的凭证。因为solidity中library不允许使用状态变量，故这里无法使用mapping（bytes => struct）去通过这个哈希值映射去寻找结构体中的其他变量，只能用户在写函数时自己定义。
调用时只需要调用RegisterUser(self,string,uint,address,uint)

 2. 管理员注册函数

RegisterUser(slef,string,uint,adddress,uint)public  returns(bytes32 )
与用户注册一样。唯一的区别是，管理员注册的时候还会将结构体中该管理地址映射的权限值赋一个初值0；

 3. 用户登陆IdentifyUser(self,bytes32)returns(bool)

通过self调用user结构体中该密钥对应的注册状态为真
返回true


4.管理员登陆IdentifyAdmin(self,bytes32)returns(bool)

通过self调用admin结构体中该密钥对应的注册状态为真
返回true

5.计算进行xx操作需要的权限值
Power(uint[],uint num)returns(uint)
传入用户需要进行的操作对应的操作值以及总共需要授权的操作个数即数组长度，返回一个uint类型即需要的权限值。

6.授权函数
Authorization(self,address,uint)returns(bool)
传入管理员地址以及授权的权限值

7查看xx拥有的权限值
ViewPermission(self,adddress)returns(uint)
传入管理员地址，返回该管理拥有的权限值

8.权限验证
 IdentifyPermission(uint ,uint )  returns(bool)
传入两个值，1个是管理拥有的权限值，一个是进行xx操作需要的权限值，进行与运算
if（（own&2**need）==2**need）则返回true，拥有这个权限，去进行xx操作，否则返回false。

#后续我会利用这个library写一些example Demo
