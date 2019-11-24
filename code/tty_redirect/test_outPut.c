/**
 * @file:   test_outPut.c
 * @note:   2010-2020, <git.oschia.net/think3r>
 * @brief:  重定向控制
 * @author: think3r
 * @date:   2019/11/24
 * @note:
 * @note \n History:
   1.日    期: 2019/11/24
     作    者:  
     修改历史: 创建文件
 */

/*----------------------------------------------*/
/*                 包含头文件                   */
/*----------------------------------------------*/

/*----------------------------------------------*/
/*                 宏类型定义                   */
/*----------------------------------------------*/

/*----------------------------------------------*/
/*                结构体定义                    */
/*----------------------------------------------*/

/*----------------------------------------------*/
/*                 函数声明                     */
/*----------------------------------------------*/

/*----------------------------------------------*/
/*                 全局变量                     */
/*----------------------------------------------*/

/*----------------------------------------------*/
/*                 函数定义                     */
/*----------------------------------------------*/
/*----------------------------------------------*/
/*                 包含头文件                   */
/*----------------------------------------------*/
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <pthread.h>

/*----------------------------------------------*/
/*                 宏类型定义                   */
/*----------------------------------------------*/
#ifndef STDIN_FILENO
/* Standard file descriptors.  */
#define STDIN_FILENO    0   /* Standard input.  */
#define STDOUT_FILENO   1   /* Standard output.  */
#define STDERR_FILENO   2   /* Standard error output.  */
#endif

#define Cprintf_green(format,...)     printf("\e[1;32m" format "\e[0m", ##__VA_ARGS__)
#define Cprintf_yellow(format,...)    printf("\e[1;33m" format "\e[0m", ##__VA_ARGS__)
#define Cprintf_red(format,...)       printf("\e[1;31m" format "\e[0m", ##__VA_ARGS__)
#define Cprintf_cyan(format,...)      printf("\e[1;36m" format "\e[0m", ##__VA_ARGS__)
#define Cprintf_purple(format,...)    printf("\e[1;35m" format "\e[0m", ##__VA_ARGS__)
#define Cprintf_underline(format,...) printf("\e[4m" format "\e[0m", ##__VA_ARGS__)
#define Cprintf_reverse(format,...)   printf("\e[7m" format "\e[0m", ##__VA_ARGS__)


#define REDIRECT_SWITCH_FILE          "./test-"

/*----------------------------------------------*/
/*                结构体定义                    */
/*----------------------------------------------*/

/*----------------------------------------------*/
/*                 函数声明                     */
/*----------------------------------------------*/

/*----------------------------------------------*/
/*                 全局变量                     */
/*----------------------------------------------*/
static int stdout_fd = -1;
static int out_fd = -1;

/*----------------------------------------------*/
/*                 函数定义                     */
/*----------------------------------------------*/


static int redirect_StdOut(char * ttyName)
{
    int ret = -1;

    if (ttyName == NULL)
    {
        Cprintf_red("[%s %d]  err! param:[%p].\n", __FUNCTION__, __LINE__, ttyName);
        return -1;
    }

    out_fd = open(ttyName, O_WRONLY);
    if (out_fd < 0)
    {
        Cprintf_red("[%s %d] open tty:[%s] error! %s.\n",
            __FUNCTION__, __LINE__, ttyName, strerror(errno));
        return -1;
    }
    else
    {
        Cprintf_green("[%s %d] open OK! \n", __FUNCTION__, __LINE__);
    }

    /* 复制标准输出描述符, 待后续恢复 */
    if(stdout_fd < 0)
    {
        stdout_fd = dup(STDOUT_FILENO);
        if(stdout_fd < 0)
        {
            Cprintf_red("[%s %d] dup error! %s.\n", __FUNCTION__, __LINE__, strerror(errno));

            close(out_fd);
            out_fd = -1;

            return -1;
        }
        else
        {
            Cprintf_green("[%s %d] dup STDOUT_FILENO OK! \n", __FUNCTION__, __LINE__);
        }
    }

    /* 替换标准输入输出 */
    ret = dup2(out_fd, STDOUT_FILENO);
    if ( ret < 0)
    {
        Cprintf_red("[%s %d] dup2 error! %s.\n", __FUNCTION__, __LINE__, strerror(errno));

        close(stdout_fd);
        stdout_fd = -1;
        close(out_fd);
        out_fd = -1;

        return -1;
    }
    else
    {
        Cprintf_green("[%s %d] dup2 OK! \n", __FUNCTION__, __LINE__);
    }

    return 0;
}

/**
 * @function:   redirect_StdOut_Reset
 * @brief:      复位标准输出
 * @param[in]:  void
 * @param[out]: None
 * @return:     static int
 */
static int redirect_StdOut_Reset(void)
{
    int ret = -1;

    /* 没有进行输出重定位, 直接返回 */
    if(out_fd < 0)
    {
        Cprintf_red("[%s %d] error! out_fd:[%d]\n", __FUNCTION__, __LINE__, out_fd);
        return -1;
    }

    /* 替换标准输入输出 */
    ret = dup2(stdout_fd, STDOUT_FILENO);
    if ( ret < 0)
    {
        Cprintf_red("[%s %d] dup2 error! %s.\n", __FUNCTION__, __LINE__, strerror(errno));
        return -1;
    }
    else
    {
        Cprintf_green("[%s %d] dup2 OK! \n", __FUNCTION__, __LINE__);
    }

    /* 关闭之前打开的文件,           释放资源 */
    close(stdout_fd);
    stdout_fd = -1;
    close(out_fd);
    out_fd = -1;

    return 0;
}


/**
 * @function:   redirect
 * @brief:      输出重定向, 使用方法:
 *                      开启: echo `tty` > ./REDIRECT_SWITCH_FILE
 *                      关闭: rm -rf ./REDIRECT_SWITCH_FILE
 * @param[in]:  void
 * @param[out]: None
 * @return:     void
 */
void redirect(void)
{
    static int bHaveFile = 0;
    FILE * fp = NULL;
    char ttyName[256] = {0};

    if ((access(REDIRECT_SWITCH_FILE, F_OK | R_OK) >= 0) && (bHaveFile == 0))
    {
        fp = fopen(REDIRECT_SWITCH_FILE, "r");
        if( fp == NULL)
        {
            Cprintf_red("[%s %d] dup error! %s.\n", __FUNCTION__, __LINE__, strerror(errno));
            return;
        }
        else
        {
            memset(ttyName, 0x00, sizeof(ttyName) * sizeof(char));
            fgets(ttyName, sizeof(ttyName) * sizeof(char), fp );        /* 读取文件第一行的内容 */
            fclose(fp);

            /* 去除字符串末尾换行符 */
            if(ttyName[strlen(ttyName) - 1] == 0xa)
            {
                ttyName[strlen(ttyName) - 1] = 0;
            }

            Cprintf_yellow("[%s %d]  ttyName:[%s]\n", __FUNCTION__, __LINE__, ttyName);

            if(redirect_StdOut(ttyName) == 0)
            {
                bHaveFile = 1;
            }
        }
    }

    if((access(REDIRECT_SWITCH_FILE, F_OK) < 0) && (bHaveFile == 1))
    {
        redirect_StdOut_Reset();
        bHaveFile = 0;
    }

    return;
}


void Thread1()
{
	int i = 0;
	int policy = 0xFF;
    struct sched_param param;

    Cprintf_green("[%s %d] policy:[%d]\n",__FUNCTION__,__LINE__, policy);
    pthread_getschedparam(pthread_self(),&policy,&param);
    Cprintf_green("[%s %d] policy:[%d]\n",__FUNCTION__,__LINE__, policy);

    if(policy == SCHED_OTHER)
      Cprintf_green("SCHED_OTHER %s %d\n", __FUNCTION__, policy);
    if(policy == SCHED_RR)
      Cprintf_green("SCHED_RR %s \n", __FUNCTION__);
    if(policy==SCHED_FIFO)
      Cprintf_green("SCHED_FIFO %s\n", __FUNCTION__);

    while(1)
    {
        sleep(2);
		Cprintf_yellow("thread-1 [%d]\n", i);
		i++;
	}

	Cprintf_red("Pthread 1 exit\n");

    return;
}



int main()
{
    printf("************************************************\n");
	
    pthread_t ppid1;
    pthread_create(&ppid1,NULL,(void *)Thread1, NULL);

    int inTimes = 0;

    while (1)
    {
        redirect();

        sleep(1);
        Cprintf_cyan("[%s() %d]  inTimes:[%d]\n",__FUNCTION__,__LINE__, inTimes);

        inTimes++;
    }

    return 0;
}


