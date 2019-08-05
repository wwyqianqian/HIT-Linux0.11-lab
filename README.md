# HIT-Linux0.11-lab

### lab1

* 改写 `bootsect.s` 主要完成如下功能：[实现代码](https://github.com/wwyqianqian/HIT-Linux0.11-lab/commit/0b35a50474be0b159b4e6dd597f01982dcf2e181)
  * bootsect.s 能在屏幕上打印一段提示信息“XXX is booting...”，其中 XXX 是你给自己的操作系统起的名字，例如 LZJos、Sunix 等。
  * Run 
    ```
    $ cd ~/oslab/linux-0.11/boot/
    $ as86 -0 -a -o bootsect.o bootsect.s
    $ ld86 -0 -s -o bootsect bootsect.o
    $ dd bs=1 if=bootsect of=Image skip=32
    $ cp ./Image ../Image
    $ ../../run
    ```

* 改写 `setup.s` 主要完成如下功能：[实现代码](https://github.com/wwyqianqian/HIT-Linux0.11-lab/commit/5edbd1ae8d5a98e16c56839dcb435766fb5242bd)
  * bootsect.s 能完成 setup.s 的载入，并跳转到 setup.s 开始地址执行。而 setup.s 向屏幕输出一行"Now we are in SETUP"。
  * setup.s 能获取至少一个基本的硬件参数（如内存参数、显卡参数、硬盘参数等），将其存放在内存的特定地址，并输出到屏幕上。
  * setup.s 不再加载 Linux 内核，保持上述信息显示在屏幕上即可。
  * Run
  ```
	$ cd ~/oslab/linux-0.11
	$ make BootImage
	$ ../run
  ```

* 运行截图
    ![lab1](./pics/lab1.png)
---

### lab2

此次实验的基本内容是：在 Linux 0.11 上添加两个系统调用，并编写两个简单的应用程序测试它们。

* `iam()`

	第一个系统调用是 iam()，其原型为：
	```
	int iam(const char * name);
	```

	完成的功能是将字符串参数 `name` 的内容拷贝到内核中保存下来。要求 `name` 的长度不能超过 23 个字符。返回值是拷贝的字符数。如果 `name` 的字符个数超过了 23，则返回 “-1”，并置 errno 为 EINVAL。 </br>
	在 `kernal/who.c` 中实现此系统调用。

* `whoami()`

  第二个系统调用是 whoami()，其原型为：
  
  ```
  int whoami(char* name, unsigned int size);
  ```
  
  它将内核中由 `iam()` 保存的名字拷贝到 name 指向的用户地址空间中，同时确保不会对 `name` 越界访存（`name` 的大小由 `size` 说明）。返回值是拷贝的字符数。如果 `size` 小于需要的空间，则返回“-1”，并置 errno 为 EINVAL。也是在 `kernal/who.c` 中实现。

* 测试程序

运行添加过新系统调用的 Linux 0.11，在其环境下编写两个测试程序 iam.c 和 whoami.c。最终的运行结果是：
```
$ ./iam lizhijun
$ ./whoami	
lizhijun 
```