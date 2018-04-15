defmodule Minimo.Util.Routee do
  @doc """
  todo: 有些操作是并发的，需要提供多个线程的访问功能。
  该模块提供两个功能：
  1. 提供多种分发定义，根据key分发，随机分发等。
  2. ChildRoute做为分发的执行进程
  其他： 考虑支持一致性hash，让消息的分发能够跨节点和动态扩展。这种功能+资源监控可以实现自动化的多机器负载均衡，常用于某一块业务的自动化扩展。
  不同于一般的进程池，这里提供了指定任务在会映射到哪个进程上的功能(通过一个hash分发消息).
  
  提供监管器，one_for_one策略重启每个ChildRoute
  """
  



  @doc """
  ChildRoute 使用GenServer处理每一个请求
  """
  defmodule ChildRoute do
    use GenServer

    
  end
  
  
  
end
