# Map
地图提供相关的存储和数据获取的方法。对于服务器来讲最需要注意的是并发环境下的处理——并发读和并发写。这里，对于地图而言，有大量的操作需要更新每个地图点上的对象，并因为帧同步机制，位置数据需要被获取发送回客户端。  
除此之外，又有一些原子操作，比如获取某个ets中的数据，并更新，最后保存回去，这是一个典型的ABA问题，对于ABA，通过actor消息的方式处理比较自然，最理想的情况是根据读写的最小作用范围进行加锁（??）。  
最简单直观的方式是在合适的作用域内加锁，对于地图来说，每个地图实例为单位是最为直观的，在一个地图实例中，读取数据是直接从ets中获取，是并发的，而写数据是顺序的。  
考虑进一步优化写操作，提供一些并行性，对比一个极限情况下的方案——为每个key创建一进程单独处理相关的操作，这能保证最小的锁范围，当然这是不太可能的，因为一个地图可能有好几百的key被维护（感觉再深入下去，就是内存数据库+内存事务了）。退一步，我们为每个地图的数据写操作创建若干个进程，进行写操作时，先把key进行hash后取余放入一个进程中处理逻辑，  
换个角度考虑，我们希望利用多核cpu的优势，当服务处理10个或100个消息时，多核优势自动被使用了。也就是说如果顺序性写操作引起的延迟能够接受的话，可以不进行优化，因为这并不会降低cpu的利用率。  
最终方案：使用最直接的抽象方式，即一个地图写操作对应一个进程，同过调节进程的优先级来加快处理速度